//
//  MainResponseModel.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 29.12.2022.
//

import Foundation

struct MainResponseModel: Codable, Identifiable, Hashable {
    let id = UUID()
    let idResponse: Int
    let title: String
    let thumbnail: String
    let shortDescription: String
    let gameURL: String
    let genre: Genre
    let platform: Platform
    let publisher, developer, releaseDate: String
    let freetogameProfileURL: String

    enum CodingKeys: String, CodingKey {
        case idResponse = "id"
        case title, thumbnail
        case shortDescription = "short_description"
        case gameURL = "game_url"
        case genre, platform, publisher, developer
        case releaseDate = "release_date"
        case freetogameProfileURL = "freetogame_profile_url"
    }
}

enum Genre: String, Codable, CaseIterable {
    case all = "All Games"
    case actionRPG = "Action RPG"
    case arpg = "ARPG"
    case battleRoyale = "Battle Royale"
    case cardGame = "Card Game"
    case fantasy = "Fantasy"
    case fighting = "Fighting"
    case genreMMORPG = " MMORPG"
    case mmo = "MMO"
    case mmoarpg = "MMOARPG"
    case mmofps = "MMOFPS"
    case mmorpg = "MMORPG"
    case moba = "MOBA"
    case racing = "Racing"
    case shooter = "Shooter"
    case social = "Social"
    case sports = "Sports"
    case strategy = "Strategy"
    
    
}

enum Platform: String, Codable {
    case pcWindows = "PC (Windows)"
    case pcWindowsWebBrowser = "PC (Windows), Web Browser"
    case webBrowser = "Web Browser"
}
