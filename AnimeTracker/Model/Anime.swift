//
//  Anime.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import Foundation

enum WatchStatus: String, CaseIterable, Codable {
    case notStarted = "Not Started"
    case watching = "Watching"
    case finished = "Finished"
}

struct Anime: Identifiable, Equatable, Codable {
    var id: Int
    var title: String
    var imageUrl: String
    var description: String
    var episodes: Int?
    var averageScore: Double?
    var genres: [String]
    var studio: String
    var seasonYear: Int?
    var trailerUrl: String?
    var watchStatus: WatchStatus = .notStarted
    var currentEpisode: Int = 1
    var personalRating: Double = 0.0
}
