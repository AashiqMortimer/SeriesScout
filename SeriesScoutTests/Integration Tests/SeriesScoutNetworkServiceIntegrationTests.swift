//
//  SeriesScoutNetworkServiceIntegrationTests.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 18/03/2024.
//

import XCTest
@testable import SeriesScout

final class SeriesScoutNetworkServiceIntegrationTests: XCTestCase {
    var uTellyModel: UtellyModel!
    
    func testNetworkServiceRetrievesData() {
        // Given
        let networkService = SeriesScoutNetworkService()
        let searchTerm = "Barry"
        
        // When
        networkService.fetchUtellyData(searchTerm: searchTerm) { [weak self] result in
            switch result {
            case .success(let utellyData):
                self?.uTellyModel = utellyData
            case .failure(let error):
                XCTFail("Network request encountered error: \(error.localizedDescription)")
            }
        }
        let expectation = XCTestExpectation(description: "Waiting for data fetch")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        // Then
        XCTAssertNotNil(uTellyModel)
        XCTAssertEqual(uTellyModel.results.first?.name, "Barry")
    }

}
