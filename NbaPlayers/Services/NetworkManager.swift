//
//  NetworkManager.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 12.11.2024.
//

import Foundation

enum NetworkError: Error {
    case noData
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let headers = [
        "x-rapidapi-key": "8b70de7122mshf7d8da5b54e7c8ap129e91jsn91405a76579c",
        "x-rapidapi-host": "nba-api-free-data.p.rapidapi.com"
    ]
    
    private init() {}
    
    func fetchTeams(from nsUrl: NSURL, completion: @escaping(Result<[Team], NetworkError>) -> Void) {
        let request = NSMutableURLRequest(
            url: nsUrl as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request as URLRequest){ data, _, error in
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let teamList = try decoder.decode(TeamList.self, from: data)
                let teams = teamList.teams
                DispatchQueue.main.async {
                    completion(.success(teams))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    // TODO: - Fetch Players
    func fetchPlayers(with nsUrl: NSURL) {
        let request = NSMutableURLRequest(
            url: nsUrl as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else if let data, let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
        })

        dataTask.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchTeams() async throws -> [Team] {
        let nsUrl = Link.teams.url
        let request = NSMutableURLRequest(
            url: nsUrl as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        let (data, _) = try await URLSession.shared.data(for: request as URLRequest)
        let decoder = JSONDecoder()
        
        do {
            let teamList = try decoder.decode(TeamList.self, from: data)
            return teamList.teams
        } catch {
            throw NetworkError.decodingError
        }
    }
}
