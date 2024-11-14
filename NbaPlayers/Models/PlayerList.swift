//
//  PlayerList.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 12.11.2024.
//

import Foundation

struct PlayerList: Decodable {
    let athletes: [Player]
}

struct Player: Decodable {
    let fullName: String
    let weight: Int
    let displayHeight: String
    let age: Int
    let dateOfBirth: String
    let birthPlace: BirthPlace
    let headshot: Photo
    let position: Position
    let contract: Contract
    let experience: Experience
}

struct BirthPlace: Decodable {
    let city: String
    let country: String
}

struct Photo: Decodable {
    let href: URL
}

struct Position: Decodable {
    let displayName: String
    let abbreviation: String
}

struct Experience: Decodable {
    let years: Int
}

struct Contract: Decodable {
    let salary: Int
    let season: Season
}

struct Season: Decodable {
    let year: Int
}
