//
//  QuakesProvider.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-13.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

@MainActor // Force methods to execute on main thread
class QuakesProvider: ObservableObject {
    @Published var quakes: [Quake] = []
    
    let client: QuakeClient
    
    func fetchQuakes() async throws {
        let latestQuakes = try await client.quakes
        self.quakes = latestQuakes
    }
    
    func deleteQuakes(atOffsets offsets: IndexSet) { // Using IndexSet to match parameters of onDelete(perform:) modifier of List
        quakes.remove(atOffsets: offsets)
    }
    
    func location(for quake: Quake) async throws -> QuakeLocation {
        return try await client.quakeLocation(from: quake.detail)
    }
    
    init(client: QuakeClient = QuakeClient()) {
        self.client = client
    }
}
