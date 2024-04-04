//
//  SeriesScoutRepository.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import Foundation

protocol SeriesScoutNetworkServiceRepresentable {
    func fetchUtellyData(searchTerm: String, completion: @escaping (Result<UtellyModel, NetworkError>) -> Void)
}

class SeriesScoutNetworkService: SeriesScoutNetworkServiceRepresentable {
    
    let session: URLSession
    private let baseURL = URL(string: "https://utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com")!
    private let apiKey = "855daeef13msh6294ff64512c2dcp1a86dfjsn60afe6ddc0dd"
    private let host = "utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com"
    
    init(session: URLSession = .shared) {
            self.session = session
        }
    
    func fetchUtellyData(searchTerm: String, completion: @escaping (Result<UtellyModel, NetworkError>) -> Void) {
        let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/lookup"
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: encodedSearchTerm),
            URLQueryItem(name: "country", value: "uk"),
            URLQueryItem(name: "rapidapi-key", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(host, forHTTPHeaderField: "X-RapidAPI-Host")
        
        print("Request is: \(request)")
        
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let utelly = try JSONDecoder().decode(UtellyModel.self, from: data)
                completion(.success(utelly))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}
