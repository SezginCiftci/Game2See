//
//  DetailResponseModel.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 29.12.2022.
//

import Foundation

struct DetailResponseModel: Codable, Identifiable {
    let id = UUID()
    let idResonse: Int
    let title: String
    let thumbnail: String
    let status, shortDescription, welcomeDescription: String
    let gameURL: String
    let genre, platform, publisher, developer: String
    let releaseDate: String
    let freetogameProfileURL: String
    let screenshots: [Screenshot]

    enum CodingKeys: String, CodingKey {
        case idResonse = "id"
        case title, thumbnail, status
        case shortDescription = "short_description"
        case welcomeDescription = "description"
        case gameURL = "game_url"
        case genre, platform, publisher, developer
        case releaseDate = "release_date"
        case freetogameProfileURL = "freetogame_profile_url"
        case screenshots
    }
}

// MARK: - Screenshot
struct Screenshot: Codable, Hashable {
    let id: Int
    let image: String
}
