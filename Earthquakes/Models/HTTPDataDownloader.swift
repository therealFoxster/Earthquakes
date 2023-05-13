//
//  HTTPDataDownloader.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-08.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

let validStatusCodes = 200...299

protocol HTTPDataDownloader {
    func httpData(from: URL) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    func httpData(from url: URL) async throws -> Data {
        // If unable to cast URLResponse -> HTTPURLResponse or if the cast succeeded but received an HTTP failure status code, throw networkError.
        guard let (data, response) = try? await self.data(from: url, delegate: nil) as? (Data, HTTPURLResponse),
              validStatusCodes.contains(response.statusCode)
        else {
            throw QuakeError.networkError
        }
        return data
    }
}
