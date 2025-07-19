//
//  AnimeDiscover.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import SwiftUI
import Kingfisher

struct AnimeDiscover: View {
    @State private var searchText = ""
    @State private var results: [Anime] = []

    var body: some View {
        VStack {
            TextField("Search anime...", text: $searchText, onCommit: search)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            List(results) { anime in
                NavigationLink(destination: AnimeDetailView(anime: anime)) {
                    HStack {
                        KFImage(URL(string: anime.imageUrl))
                                        .resizable()
                                        .placeholder {
                                            ProgressView()
                                        }
                                        .fade(duration: 0.25)
                                        .frame(width: 60, height: 90)
                                        .cornerRadius(8)
                        
                        Text(anime.title)
                            .font(.headline)
                            .padding(.leading, 8)
                    }
                }
            }
        }
        .navigationTitle("Anime Search")
    }

    func search() {
        AnimeAPI.searchAnime(query: searchText) { fetched in
            DispatchQueue.main.async {
                self.results = fetched
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AnimeViewModel())
}
