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
            Anime(
                id: mal_id,
                title: title,
                imageUrl: images.jpg.image_url,
                description: synopsis ?? "",
                episodes: episodes ?? 0,
                averageScore: score ?? 0.0,
                genres: genres?.map { $0.name } ?? [],
                studio: studios?.first?.name ?? "",
                seasonYear: year ?? 0,
                trailerUrl: trailer?.url,
                watchStatus: .notStarted,
                currentEpisode: 0,
                personalRating: 0.0
            )
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
