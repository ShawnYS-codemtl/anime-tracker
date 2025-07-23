//
//  WatchlistRow.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-18.
//

import SwiftUI
import Kingfisher

struct WatchlistRow: View {
    let anime: Anime
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: anime.imageUrl))
                            .resizable()
                            .placeholder {
                                ProgressView()
                            }
                            .fade(duration: 0.25)
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)
            
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
