//
//  WatchlistView.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-17.
//
import Foundation
import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var viewModel: AnimeViewModel

    var body: some View {
        List(viewModel.watchlist) { anime in
                    NavigationLink(destination: AnimeDetailView(anime: anime)
                                    .environmentObject(viewModel)) {
                        HStack {
                            AsyncImage(url: URL(string: anime.imageUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 50, height: 70)
                            .cornerRadius(8)

                            Text(anime.title)
                                .font(.headline)
                        }
                    }
                }
        .navigationTitle("Watchlist")
    }
}

#Preview {
    NavigationView {
        WatchlistView()
            .environmentObject(mockViewModel)
    }
}

private var mockViewModel: AnimeViewModel {
    let viewModel = AnimeViewModel()

    let exampleAnime = Anime(
        id: 1,
        title: "Attack on Titan",
        imageUrl: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx16498-B6pgDEBuwLOr.jpg",
        description: "After his hometown is destroyed and his mother is killed, Eren joins the military to fight Titans.",
        episodes: 25,
        averageScore: 85,
        genres: ["Action", "Drama", "Fantasy"],
        studio: "Wit Studio",
        seasonYear: 2013,
        trailerUrl: "https://youtube.com/watch?v=MGRm4IzK1SQ"
    )

    viewModel.addToWatchlist(exampleAnime)
    return viewModel
}
