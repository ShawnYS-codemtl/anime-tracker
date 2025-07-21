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
    @ObservedObject var viewModel = DiscoverViewModel()
    @State private var results: [Anime] = []

    var body: some View {
        Group {
            if searchText.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        DiscoverSection(title: "Trending", animeList: viewModel.trending)
                        DiscoverSection(title: "Now Airing", animeList: viewModel.nowAiring)
                        DiscoverSection(title: "Upcoming", animeList: viewModel.upcoming)
                        DiscoverSection(title: "Top Rated", animeList: viewModel.topRated)
                        // Add more sections as needed
                    }
                    .padding(.top)
                }
                .onAppear {
                    print("onAppear triggered")
                    Task {
                        await viewModel.fetchTrending()
                        await viewModel.fetchNowAiring()
                        await viewModel.fetchUpcoming()
                        await viewModel.fetchTopRated()
                    }
                }
            } else {
                List {
                    ForEach(results) { anime in
                        NavigationLink(destination: AnimeDetailView(anime: anime)) {
                            HStack {
                                KFImage(URL(string: anime.imageUrl))
                                    .resizable()
                                    .placeholder { ProgressView() }
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
            }
        }
        .searchable(text: $searchText, prompt: "Search anime")
        .navigationTitle("Discover") // ✅ Always visible
        .onSubmit(of: .search) {
            search()
        }
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
