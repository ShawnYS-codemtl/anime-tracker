//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: anime.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
                
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
                        Link("Watch Trailer", destination: URL(string: trailer)!)
                            .foregroundColor(.blue)
                            .underline()
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
        imageUrl: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx16498-B6pgDEBuwLOr.jpg",
        description: "After his hometown is destroyed and his mother is killed, young Eren Yeager joins the military to fight the Titans.",
        episodes: 25,
        averageScore: 85,
        genres: ["Action", "Drama", "Fantasy"],
        studio: "Wit Studio",
        seasonYear: 2013,
        trailerUrl: "https://youtube.com/watch?v=MGRm4IzK1SQ"
    ))
}
