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
    
    private var watchlistFileURL: URL {
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("watchlist.json")
    }

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
        watchlist.contains(where: { $0.id == anime.id })
    }

    func saveWatchlist() {
        do {
            let data = try JSONEncoder().encode(watchlist)
            try data.write(to: watchlistFileURL)
        } catch {
            print("Error saving watchlist: \(error)")
        }
    }

    func loadWatchlist() {
        do {
            let data = try Data(contentsOf: watchlistFileURL)
            watchlist = try JSONDecoder().decode([Anime].self, from: data)
        } catch {
            print("No saved watchlist found or failed to decode: \(error)")
            watchlist = [] // fallback
        }
    }
    
    func updateStatus(for anime: Anime, to status: WatchStatus) {
        if let index = watchlist.firstIndex(where: { $0.id == anime.id }) {
            watchlist[index].watchStatus = status
            saveWatchlist()
        }
    }
    
    func updateEpisode(for anime: Anime, to episode: Int) {
        if let index = watchlist.firstIndex(where: { $0.id == anime.id }) {
            watchlist[index].currentEpisode = episode
            saveWatchlist()
        }
    }
    
    func updateRating(for anime: Anime, to rating: Double) {
        guard let index = watchlist.firstIndex(where: { $0.id == anime.id }) else { return }
        watchlist[index].personalRating = rating
        saveWatchlist()
    }
    
    func isFinished(_ anime: Anime) -> Bool {
        return watchlist.first(where: { $0.id == anime.id })?.watchStatus == .finished
    }
}

