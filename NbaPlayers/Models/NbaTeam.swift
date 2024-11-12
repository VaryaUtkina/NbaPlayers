//
//  GameStatistic.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 11.11.2024.
//

import Foundation

struct NbaTeam: Decodable {
    let sports: [Sport]
}

struct Sport: Decodable {
    let leagues:  [League]
}

struct League: Decodable {
    let teams: [TeamList]
}

struct TeamList: Decodable {
    let team: Team
}

struct Team: Decodable {
    let displayName: String
    let color: String
    let logos: [Logo]
}

struct Logo: Decodable {
    let href: URL
}
