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
        let list = await fetchAnime(from: "https://api.jikan.moe/v4/top/anime?filter=bypopularity")
            DispatchQueue.main.async {
                self.trending = list
            }
    }
    
    func fetchUpcoming() async {
        let list = await fetchAnime(from: "https://api.jikan.moe/v4/top/anime?filter=upcoming")
            DispatchQueue.main.async {
                self.upcoming = list
            }
    }
    
    func fetchTopRated() async {
        let list = await fetchAnime(from: "https://api.jikan.moe/v4/top/anime?filter=favorite")
            DispatchQueue.main.async {
                self.topRated = list
            }
    }

    func fetchNowAiring() async {
        let list = await fetchAnime(from: "https://api.jikan.moe/v4/seasons/now")
            DispatchQueue.main.async {
                self.nowAiring = list
            }
        
    }


//    func loadDiscoverData() {
//        Task {
//            nowAiring = await fetchDiscoverCategory(filter: "airing")
//            topRated = await fetchDiscoverCategory(orderBy: "score")
//            romance = await fetchByGenre(genreID: 22)
//        }
//    }

    func search(query: String) {
        // Fetch from Jikan
    }

//    private func fetchDiscoverCategory(filter: String? = nil, orderBy: String? = nil) async -> [Anime] {
//        // API call logic
//    }

//    private func fetchByGenre(genreID: Int) async -> [Anime] {
//        // API call logic
//    }
}
