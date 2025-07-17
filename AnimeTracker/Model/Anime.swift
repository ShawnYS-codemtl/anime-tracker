//
//  Anime.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import Foundation

struct Anime: Identifiable, Decodable {
    var id: Int
    var title: String
    var imageUrl: String
    var description: String
    var episodes: Int?
    var averageScore: Int?
    var genres: [String]
    var studio: String
    var seasonYear: Int?
    var trailerUrl: String?
}
