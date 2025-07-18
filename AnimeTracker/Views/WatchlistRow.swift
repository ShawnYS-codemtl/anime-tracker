//
//  WatchlistRow.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-18.
//

import SwiftUI

struct WatchlistRow: View {
    let anime: Anime
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: anime.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 70)
            .cornerRadius(6)
            
            VStack(alignment: .leading) {
                Text(anime.title)
                    .font(.headline)
                if let episodes = anime.episodes {
                    Text("\(episodes) episodes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text("Episode \(anime.currentEpisode)/\(anime.episodes ?? 0)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
            }
            Spacer()
            
            if anime.watchStatus == .finished && anime.personalRating > 0 {
                        Text("⭐️ \(String(format: "%.1f", anime.personalRating))")
                            .foregroundColor(.yellow)
                            .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
        
    }
}
