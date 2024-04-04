//
//  MockedSeriesScoutRepository.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation
@testable import SeriesScout

class MockSeriesScoutNetworkService: SeriesScoutNetworkServiceRepresentable {
    var shouldReturnError = false
    let resource: String
    
    init(resource: String, shouldReturnError: Bool = false) {
        self.resource = resource
        self.shouldReturnError = shouldReturnError
    }

    func fetchUtellyData(searchTerm: String, completion: @escaping (Result<SeriesScout.UtellyModel, SeriesScout.NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.invalidURL))
        } else {
            let decoder = JSONDecoder()
            
            let bundle = Bundle(for: type(of: self))
            
            guard let filePath = bundle.path(forResource: resource, ofType: "json") else {
                fatalError("\(resource) not found")
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                try completion(.success(decoder.decode(UtellyModel.self, from: data)))
            } catch {
                print("❌: \(error.localizedDescription)")
            }
        }
    }
}
