//
//  JikanModels.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-20.
//

struct JikanAnimeResponse: Codable {
    let data: [JikanAnime]
}

struct JikanTrailer: Codable {
    let url: String?
}

struct JikanAnime: Codable {
    let mal_id: Int
    let title: String
    let synopsis: String?
    let episodes: Int?
    let score: Double?
    let year: Int?
    let trailer: JikanTrailer?
    let images: JikanImages
    
    let genres: [JikanGenre]?
    let studios: [JikanStudio]?
    
    func toAnime() -> Anime {
        Anime(from: self)
    }
}

struct JikanImages: Codable {
    let jpg: JikanImage
}

struct JikanImage: Codable {
    let image_url: String
}

struct JikanGenre: Codable {
    let name: String
}

struct JikanStudio: Codable {
    let name: String
}
