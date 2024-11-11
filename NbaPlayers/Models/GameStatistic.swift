//
//  GameStatistic.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 11.11.2024.
//

import Foundation

struct GameStatistic {
    let player: Player
    let team: Team
    let points: Int
    
    static func getGameStatistics() -> [GameStatistic] {
        [
            GameStatistic(
                player: Player.getPlayer(),
                team: Team.getTeam(),
                points: 14
            )
        ]
    }
}

struct Player {
    let firstname: String
    let lastname: String
    
    var fullName: String {
        "\(firstname) \(lastname)"
    }
    
    static func getPlayer() -> Player {
        Player(
            firstname: "Dwayne",
            lastname: "Bacon"
        )
    }
}

struct Team {
    let name: String
    let logo: URL
    
    static func getTeam() -> Team {
        Team(
            name: "Orlando Magic",
            logo: URL(string: "https://upload.wikimedia.org/wikipedia/fr/b/bd/Orlando_Magic_logo_2010.png")!
        )
    }
}
