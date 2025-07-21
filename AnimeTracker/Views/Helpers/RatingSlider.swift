//
//  RatingSlider.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-18.
//

import SwiftUI

struct RatingSlider: View {
    @Binding var rating: Double

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Rating: \(String(format: "%.1f", rating)) / 10")
                .font(.headline)

            Slider(value: $rating, in: 0...10, step: 0.5)
        }
        .padding(.vertical)
    }
}
