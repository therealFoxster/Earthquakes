//
//  QuakeDetail.swift
//  Earthquakes-iOS
//
//  Created by Huy Bui on 2023-05-13.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct QuakeDetail: View {
    var quake: Quake
    @EnvironmentObject private var quakesProvider: QuakesProvider
    @State private var location: QuakeLocation? = nil
    
    @State var formatStyle = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(3))
    @State var fullPrecision = false {
        didSet {
            formatStyle = fullPrecision ? .number : .number.precision(.fractionLength(3))
        }
    }
    
    var body: some View {
        VStack {
            if let location = self.location {
                QuakeDetailMap(location: location, tintColor: quake.color)
                    .ignoresSafeArea(.container)
            }
            QuakeMagnitude(quake: quake)
            Text(quake.place)
                .font(.title3)
                .bold()
            Text("\(quake.time.formatted())")
                .foregroundColor(.secondary)
            if let location = self.location {
                Text("Latitude: \(location.latitude.formatted(formatStyle))")
                    .onTapGesture {
                        fullPrecision.toggle()
                    }
                Text("Longitude: \(location.longitude.formatted(formatStyle))")
                    .onTapGesture {
                        fullPrecision.toggle()
                    }
            }
        }
        .task { // Canceled automatically when view disappears
            if self.location == nil {
                if let quakeLocation = quake.location {
                    self.location = quakeLocation
                } else {
                    self.location = try? await quakesProvider.location(for: quake)
                }
            }
        }
    }
}

struct QuakeDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuakeDetail(quake: Quake.preview)
    }
}
