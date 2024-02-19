//
//  SeriesScoutViewModelTests.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import XCTest
@testable import SeriesScout

final class SeriesScoutViewModelTests: XCTestCase, MockedRequest {

    var viewModel: SeriesScoutViewModel!
    var repository: MockedSeriesScoutRepository!
    
    override func setUp() {
        super.setUp()
        repository = MockedSeriesScoutRepository()
        viewModel = SeriesScoutViewModel(repository: repository)
        
    }
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }
    
    func testViewModelReturnsExpectedValues() {
        viewModel.fetchUtellyData()
        
        XCTAssertEqual(viewModel.seriesName, "Bojack Horseman")
    }

}
