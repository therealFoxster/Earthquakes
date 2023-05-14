//
//  QuakeClient.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-08.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

actor QuakeClient { // Using actor instead of class to prevent simulitaneous access to quakeCache from different threads
    private let quakeCache: NSCache<NSString, CacheEntryObject> = NSCache()
    
    private lazy var decoder: JSONDecoder = { // Initialize using anonymous clousure to set date decoding strategy
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    private let feedURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
    private let downloader: any HTTPDataDownloader
    
    var quakes: [Quake] {
        get async throws {
            let data = try await downloader.httpData(from: feedURL)
            let allQuakes = try decoder.decode(GeoJSON.self, from: data)
            var updatedQuakes = allQuakes.quakes // Sorted by newest to oldest
            if let olderThanOneHour = updatedQuakes.firstIndex(where: { $0.time.timeIntervalSinceNow > 3600 }) {
                let indexRange = updatedQuakes.startIndex..<olderThanOneHour
                try await withThrowingTaskGroup(of: (Int, QuakeLocation).self) { group in // Int: array index, QuakeLocation: location
                    for index in indexRange {
                        group.addTask {
                            let location = try await self.quakeLocation(from: allQuakes.quakes[index].detail)
                            return (index, location)
                        }
                    }
                    while let result = await group.nextResult() { // nextResult() -> Result<(Int, QuakeLocation), Error>
                        switch result {
                        case .success(let (index, location)):
                            updatedQuakes[index].location = location
                        case .failure(let error):
                            throw error
                        }
                    }
                }
            }
            return updatedQuakes
        }
    }
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }
    
    func quakeLocation(from url: URL) async throws -> QuakeLocation {
        if let cached = quakeCache[url] { // Value cached previously
            switch cached {
            case .inProgress(let task):
                return try await task.value // Wait for in-progress task instead of making a second network request
            case .ready(let quakeLocation):
                return quakeLocation
            }
        }
        // Fetch un-cached value
        let task = Task<QuakeLocation, Error> {
            let data = try await downloader.httpData(from: url)
            let location = try decoder.decode(QuakeLocation.self, from: data)
            return location
        }
        quakeCache[url] = .inProgress(task)
        do {
            let location = try await task.value // Suspends thread; another thread may now call quakeLocation(from:) while current thread is suspended
            quakeCache[url] = .ready(location)
            return location
        } catch {
            quakeCache[url] = nil
            throw error
        }
    }
}
