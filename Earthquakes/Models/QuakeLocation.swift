//
//  QuakeLocation.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-07.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct QuakeLocation: Decodable {
    var latitude: Double {
        properties.products.origin.first!.properties.latitude
    }
    var longitude: Double {
        properties.products.origin.first!.properties.longitude
    }
    private var properties: RootProperties
    
    // GeoJSON.features[].properties.products.origin[].properties.latitude/longitude
    
    struct RootProperties: Decodable {
        var products: Products
    }
    struct Products: Decodable {
        var origin: [Origin]
    }
    struct Origin: Decodable {
        var properties: OriginProperties
    }
    struct OriginProperties {
        var latitude: Double
        var longitude: Double
    }
}

extension QuakeLocation.OriginProperties: Decodable {
    private enum OriginPropertiesCodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OriginPropertiesCodingKeys.self)
        let latitude = try container.decode(String.self, forKey: .latitude)
        let longitude = try container.decode(String.self, forKey: .longitude)
        guard let latitude = Double(latitude),
              let longtitude = Double(longitude)
        else {
            throw QuakeError.missingData
        }
        self.latitude = latitude
        self.longitude = longtitude
    }
}
