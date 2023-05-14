//
//  CacheEntryObject.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-13.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

enum CacheEntry {
    case inProgress(Task<QuakeLocation, Error>)
    case ready(QuakeLocation)
}

// Wrapper class for CacheEntry enumeration (value type) since NSCache only holds reference type
final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) {
        self.entry = entry
    }
}
