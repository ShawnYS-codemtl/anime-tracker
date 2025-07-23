//
//  GenreSearch.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-22.
//

import SwiftUI

struct GenreSearchView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @State private var selectedGenreId: Int = -1

    var body: some View {
        VStack(spacing: 20) {
            Picker("Genre", selection: $selectedGenreId) {
                Text("Select").tag(-1)
                ForEach(viewModel.allGenres) { genre in
                    Text(genre.name).tag(genre.mal_id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onAppear {
                Task {
                    await viewModel.fetchGenres()
                }
            }
            .onChange(of: selectedGenreId) { _, new in
                if new != -1 {
                    Task {
                        viewModel.resetGenreSearch(with: new)
                        await viewModel.fetchByGenre(new)
                    }
                }
            }

            ScrollView {
                LazyVStack {
                    ForEach(viewModel.genreAnime) { anime in
                        HStack(alignment: .top, spacing: 12){
                            AsyncImage(url: URL(string: anime.imageUrl)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Color.gray
                                }
                            }
                            .frame(width: 50, height: 70)
                            .cornerRadius(6)
                            .clipped()

                            VStack(alignment: .leading, spacing: 4) {
                                Text(anime.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                Text("Score: \(anime.averageScore != nil ? String(format: "%.1f", anime.averageScore!) : "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
//

                        // Infinite scroll trigger
                        .onAppear {
                            if anime == viewModel.genreAnime.last {
                                Task {
                                    await viewModel.fetchByGenre(selectedGenreId)
                                }
                            }
                        }
                    }

                    if viewModel.isLoadingMore {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Search by Genre")
    }
}



#Preview {
    GenreSearchView()
        .environmentObject(AnimeViewModel())
}
