//
//  NSCache+Subscript.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-13.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ url: URL) -> CacheEntry? {
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key) // Takes NSString and returns CacheEntryObject (due to extension constrain)
            return value?.entry
        }
        set {
            // var newValue: CacheEntry // Synthesized by compiler, no need for explicit declaration
            let key = url.absoluteString as NSString
            if let value = newValue {
                let value = CacheEntryObject(entry: value)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
