//
//  SearchBar.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-20.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search anime...", text: $text)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
