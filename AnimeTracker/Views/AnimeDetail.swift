//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import SwiftUI
import Kingfisher

struct AnimeDetailView: View {
    let anime: Anime
    
    @EnvironmentObject var viewModel: AnimeViewModel
    @State private var fullAnime: Anime? = nil  // Loaded later
    @State private var isLoading = false
    @State private var localEpisode: Int

    init(anime: Anime) {
        self.anime = anime
        _localEpisode = State(initialValue: anime.currentEpisode)
    }
    
    var isPreview: Bool {
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KFImage(URL(string: (fullAnime ?? anime).imageUrl))
                            .resizable()
                            .placeholder {
                                ProgressView()
                            }
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                
                Text((fullAnime ?? anime).title)
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    if let episodes = (fullAnime ?? anime).episodes {
                        Text("Episodes: \(episodes)")
                    }

                    if let score = (fullAnime ?? anime).averageScore {
                        Text("Score: \(String(format: "%.1f", score))/100")
                    }

                    Text("Genres: \((fullAnime ?? anime).genres.joined(separator: ", "))")
                    Text("Studio: \((fullAnime ?? anime).studio)")

                    if let year = (fullAnime ?? anime).seasonYear {
                        Text("Year: \(String(year))")
                    }

                    if let trailer = (fullAnime ?? anime).trailerUrl {
                        Link("▶ Watch Trailer", destination: URL(string: trailer)!)
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .font(.subheadline)
                Divider()

                let desc = (fullAnime ?? anime).description
                Text(stripHTML(from: desc.isEmpty ? "No description available." : desc))
                    .font(.body)
                
                Divider()
                
                if viewModel.watchlist.contains(where: { $0.id == anime.id }) {
                    Stepper(value: $localEpisode, in: 0...(anime.episodes ?? 999)) {
                        Text("Episode \(localEpisode)")
                    }
                    .padding()
                    .onChange(of: localEpisode) { oldValue, newValue in
                        viewModel.updateEpisode(for: anime, to: newValue)
                    }
                }
                if viewModel.isFinished(anime),
                   let index = viewModel.watchlist.firstIndex(where: { $0.id == anime.id }) {
                    RatingSlider(rating: $viewModel.watchlist[index].personalRating)
                }
            }
            .padding()
        }
        .navigationTitle(anime.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if fullAnime == nil && !isLoading {
                isLoading = true
                Task {
                    if let fetched = await viewModel.fetchAnimeDetails(id: anime.id) {
                        fullAnime = fetched
                    }
                    isLoading = false
                }
            }
        }
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

                        Button(role: .destructive) {
                            viewModel.removeFromWatchlist(anime)
                        } label: {
                            Label("Remove", systemImage: "trash")
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

