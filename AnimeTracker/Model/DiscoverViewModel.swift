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
}
