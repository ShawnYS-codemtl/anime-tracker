//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime
    
    @EnvironmentObject var viewModel: AnimeViewModel
    var isPreview: Bool {
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !isPreview {
                    AsyncImage(url: URL(string: anime.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                }
                
                Text(anime.title)
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    if let episodes = anime.episodes {
                        Text("Episodes: \(episodes)")
                    }

                    if let score = anime.averageScore {
                        Text("Score: \(score)/100")
                    }

                    Text("Genres: \(anime.genres.joined(separator: ", "))")
                    Text("Studio: \(anime.studio)")

                    if let year = anime.seasonYear {
                        Text("Year: \(String(year))")
                    }

                    if let trailer = anime.trailerUrl {
                        Link(destination: URL(string: trailer)!) {
                            Text("▶ Watch Trailer")
                                .fontWeight(.semibold)
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    Button(action: {
                        if viewModel.isInWatchlist(anime) {
                            viewModel.removeFromWatchlist(anime)
                        } else {
                            viewModel.addToWatchlist(anime)
                        }
                    }) {
                        Text(viewModel.isInWatchlist(anime) ? "Remove from Watchlist" : "Add to Watchlist")
                            .padding()
                            .background(viewModel.isInWatchlist(anime) ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .font(.subheadline)
                Divider()

                Text(stripHTML(from: anime.description))
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(anime.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isInWatchlist(anime) {
                    Menu {
                        ForEach(WatchStatus.allCases, id: \.self) { status in
                            Button(action: {
                                viewModel.updateStatus(for: anime, to: status)
                            }) {
                                Text(status.rawValue)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                } else {
                    Button(action: {
                        viewModel.addToWatchlist(anime)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }

    }
    

    // Remove HTML tags from AniList's description
    func stripHTML(from html: String) -> String {
        let encodings: [String.Encoding] = [.utf8, .isoLatin1, .utf16]

        for encoding in encodings {
            if let data = html.data(using: encoding) {
                if let attributed = try? NSAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html,
                              .characterEncoding: encoding.rawValue],
                    documentAttributes: nil
                ) {
                    return attributed.string
                }
            }
        }

        return html // fallback if nothing works
    }
}

#Preview {
    AnimeDetailView(anime: Anime(
        id: 1,
        title: "Attack on Titan",
        imageUrl: "aot_preview",
        description: "After his hometown is destroyed and his mother is killed, young Eren Yeager joins the military to fight the Titans.",
        episodes: 25,
        averageScore: 85,
        genres: ["Action", "Drama", "Fantasy"],
        studio: "Wit Studio",
        seasonYear: 2013,
        trailerUrl: "https://youtube.com/watch?v=MGRm4IzK1SQ"
    ))
    .environmentObject(AnimeViewModel()) 
}
