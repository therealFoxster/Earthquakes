//
//  QuakeError.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-05.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

enum QuakeError: Error {
    case missingData
}

extension QuakeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingData:
            return NSLocalizedString("Found and will discard a Quake object missing a valid code, magnitude, place or time.", comment: "Missing data description")
        }
    }
}
