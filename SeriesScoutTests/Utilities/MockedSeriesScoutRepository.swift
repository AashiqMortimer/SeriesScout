//
//  MockedSeriesScoutRepository.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation
@testable import SeriesScout

class MockSeriesScoutRepository: SeriesScoutNetworkServiceRepresentable {
    var shouldReturnError = false
    var utellyDataToReturn: UtellyModel?

    func fetchUtellyData(completion: @escaping (Result<SeriesScout.UtellyModel, SeriesScout.NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.invalidURL)) // Choose appropriate error for testing
        } else {
            completion(.success(utellyDataToReturn!))
        }
    }
}
