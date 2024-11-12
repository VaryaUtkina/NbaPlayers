//
//  NbaTeam.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 11.11.2024.
//

import Foundation

struct TeamList: Decodable {
    let teams: [Team]
}

struct Team: Decodable {
    let displayName: String
    let color: String
    let logos: [Logo]
}

struct Logo: Decodable {
    let href: URL
}
