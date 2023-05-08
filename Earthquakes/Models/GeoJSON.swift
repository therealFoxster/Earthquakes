//
//  GeoJSON.swift
//  EarthquakesTests
//
//  Created by Huy Bui on 2023-05-05.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct GeoJSON: Decodable {
    // This enumeration tells the decoder which keys of GeoJSON root object to decode, in this case "features".
    private enum RootCodingKeys: String, CodingKey {
        case features
    }
    // This enumeration tells the decoder which keys of the features object to decode, in this case "properties". These will later be decoded to Quake objects.
    private enum FeaturesCodingKeys: String, CodingKey {
        case properties
    }
    
    private(set) var quakes: [Quake] = [] // "private(set)": only code in this structure can modify the array.
    
    init(from decoder: Decoder) throws {
        // 1. GeoJSON
        // 2. GeoJSON.features[]
        // 3. GeoJSON.features[].properties
        // 4. Quake object
        
        // 1.
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        // 2.
        var featuresContainer = try rootContainer.nestedUnkeyedContainer(forKey: .features) // Using unkeyed container since GeoJSON.features[] is an array and its elements are unnamed (i.e., they can't be referred to by keys)
        
        // Loop through each element of the features[] array.
        while !featuresContainer.isAtEnd {
            // 3.
            let propertiesContainer = try featuresContainer.nestedContainer(keyedBy: FeaturesCodingKeys.self)
            // 4.
            if let properties = try? propertiesContainer.decode(Quake.self, forKey: .properties) {
                quakes.append(properties)
            }
        }
    }
}
