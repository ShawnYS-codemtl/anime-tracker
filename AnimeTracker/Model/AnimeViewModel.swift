//
//  AnimeViewModel.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-17.
//

// AnimeViewModel.swift
import Foundation

class AnimeViewModel: ObservableObject {
    @Published var watchlist: [Anime] = []

    private let watchlistKey = "watchlist"

    init() {
        loadWatchlist()
    }

    func addToWatchlist(_ anime: Anime) {
        if !watchlist.contains(where: { $0.id == anime.id }) {
            watchlist.append(anime)
            saveWatchlist()
        }
    }

    func removeFromWatchlist(_ anime: Anime) {
        watchlist.removeAll { $0.id == anime.id }
        saveWatchlist()
    }

    func isInWatchlist(_ anime: Anime) -> Bool {
        return watchlist.contains(where: { $0.id == anime.id })
    }

    private func saveWatchlist() {
        if let encoded = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(encoded, forKey: watchlistKey)
        }
    }

    private func loadWatchlist() {
        if let data = UserDefaults.standard.data(forKey: watchlistKey),
           let decoded = try? JSONDecoder().decode([Anime].self, from: data) {
            self.watchlist = decoded
        }
    }
    
    func updateStatus(for anime: Anime, to status: WatchStatus) {
        if let index = watchlist.firstIndex(where: { $0.id == anime.id }) {
            watchlist[index].watchStatus = status
        }
    }
}

