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
    var currentEpisode: Int = 0
    var personalRating: Double = 0.0
    
    init(from jikan: JikanAnime) {
        self.id = jikan.mal_id
        self.title = jikan.title
        self.description = jikan.synopsis ?? ""
        self.imageUrl = jikan.images.jpg.image_url
        self.averageScore = jikan.score.map { $0 * 10 } // convert from /10 to /100 if needed
        self.episodes = jikan.episodes
        self.trailerUrl = jikan.trailer?.url
        self.seasonYear = jikan.year
        self.genres = jikan.genres?.map { $0.name } ?? []
        self.studio = jikan.studios?.first?.name ?? ""
        self.currentEpisode = 0 // or keep existing progress if stored
    }
    
    init(
        id: Int,
        title: String,
        imageUrl: String,
        description: String,
        episodes: Int?,
        averageScore: Double?,
        genres: [String],
        studio: String,
        seasonYear: Int?,
        trailerUrl: String?,
        watchStatus: WatchStatus = .notStarted,
        currentEpisode: Int = 1,
        personalRating: Double = 0.0
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.description = description
        self.episodes = episodes
        self.averageScore = averageScore
        self.genres = genres
        self.studio = studio
        self.seasonYear = seasonYear
        self.trailerUrl = trailerUrl
        self.watchStatus = watchStatus
        self.currentEpisode = currentEpisode
        self.personalRating = personalRating
    }

}


