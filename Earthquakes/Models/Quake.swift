/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A structure for representing quake data.
*/

import Foundation

struct Quake {
    let magnitude: Double
    let place: String
    let time: Date
    let code: String
    let detail: URL
}

extension Quake: Identifiable {
    var id: String { code }
}
