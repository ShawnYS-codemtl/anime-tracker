//
//  DiscoverViewModel.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-20.
//

import SwiftUI

@MainActor
class DiscoverViewModel: ObservableObject {
    @Published var trending: [Anime] = []
    @Published var nowAiring: [Anime] = []
    @Published var upcoming: [Anime] = []
    @Published var topRated: [Anime] = []
    @Published var allGenres: [JikanGenre] = []
    @Published var genreAnime: [Anime] = []
    @Published var isLoadingMore = false
    private var currentPage = 1
    private var hasNextPage = true
    private var currentGenreId: Int?
    
    struct JikanGenre: Codable, Identifiable {
        let mal_id: Int
        let name: String
        var id: Int { mal_id }
    }

    struct JikanGenreResponse: Codable {
        let data: [JikanGenre]
    }
    
    struct JikanAnimeResponse: Decodable {
        let data: [JikanAnime]
        let pagination: Pagination
    }

    struct Pagination: Decodable {
        let last_visible_page: Int
        let has_next_page: Bool
    }

    
    private func fetchAnime(from urlString: String) async -> [Anime] {
        guard let url = URL(string: urlString) else { return [] }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(JikanAnimeResponse.self, from: data)
            return decoded.data.map { $0.toAnime() }
        } catch {
            print("Failed to fetch from \(urlString):", error)
            return []
        }
    }
    
    func fetchTrending() async {
        trending = await fetchAnime(from: "https://api.jikan.moe/v4/top/anime?filter=bypopularity")
    }
    
    func fetchUpcoming() async {
        upcoming = await fetchAnime(from: "https://api.jikan.moe/v4/top/anime?filter=upcoming")
    }
    
    func fetchTopRated() async {
        topRated = await fetchAnime(from: "https://api.jikan.moe/v4/top/anime?filter=favorite")
    }

    func fetchNowAiring() async {
        nowAiring = await fetchAnime(from: "https://api.jikan.moe/v4/seasons/now")
    }
    
    func resetGenreSearch(with genreId: Int) {
        currentGenreId = genreId
        currentPage = 1
        hasNextPage = true
        genreAnime = []
    }
    
    func fetchByGenre(_ genreId: Int) async {
        guard !isLoadingMore, hasNextPage else { return }

        if currentGenreId != genreId {
            resetGenreSearch(with: genreId)
        }

        isLoadingMore = true
        let urlString = "https://api.jikan.moe/v4/anime?genres=\(genreId)&page=\(currentPage)"

        guard let url = URL(string: urlString) else {
            isLoadingMore = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(JikanAnimeResponse.self, from: data)
            let newAnime = decoded.data.map { $0.toAnime() }

            DispatchQueue.main.async {
                self.genreAnime.append(contentsOf: newAnime)
                self.hasNextPage = decoded.pagination.has_next_page
                self.currentPage += 1
                self.isLoadingMore = false
            }
        } catch {
            print("Fetch failed:", error)
            isLoadingMore = false
        }
    }
    
    func fetchGenres() async {
        let urlString = "https://api.jikan.moe/v4/genres/anime"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(JikanGenreResponse.self, from: data)
            allGenres = decoded.data
        } catch {
            print("Failed to load genres:", error)
        }
    }
}
