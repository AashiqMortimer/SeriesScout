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
    var repository: SeriesScoutRepository!
    
    override func setUp() {
        super.setUp()
        repository = SeriesScoutRepository()
        
        let dependencies = SeriesScoutViewModel.Dependencies(repository: repository)
//        viewModel = SeriesScoutViewModel(dependencies: SeriesScoutViewModel.Dependencies.)
        
    }

}
