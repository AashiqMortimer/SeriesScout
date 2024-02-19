//
//  MockedSeriesScoutRepository.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation
@testable import SeriesScout

class MockedSeriesScoutRepository: SeriesScoutRepositoryRepresentable {
    
    internal let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchUtellyData(completion: @escaping (Result<SeriesScout.UtellyModel, SeriesScout.NetworkError>) -> Void) {
        guard let url = mockDataURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, _, error in
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
    
    private func mockDataURL() -> URL? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "UtellySampleResponse", withExtension: "json") else {
            return nil
        }
        return path
    }
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}
