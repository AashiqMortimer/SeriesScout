//
//  SeriesScoutViewModel.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation

class SeriesScoutViewModel: ObservableObject {
    
    struct Dependencies {
        var repository: SeriesScoutRepository
    }
    
    let dependencies: SeriesScoutViewModel.Dependencies
    
    @Published var utellyData: UtellyModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(dependencies: SeriesScoutViewModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    func fetchUtellyData() {
        isLoading = true
        dependencies
            .repository
            .fetchUtellyData { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let utellyModel):
                        self?.utellyData = utellyModel
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
    // Maybe worth turning this into a function so that it's called each time fetch is triggered. Then the variables can be constants, and can be guard lets. I should also work with optional handling.
    
    var results: [UtellyModel.Result] {
        return utellyData?.results ?? []
    }
    
    var seriesPicture: [String] {
        return results.map { $0.picture }
    }
    
    var seriesName: [String] {
        return results.map { $0.name }
    }
    
    var locations: [UtellyModel.Result.Locations] {
        return results.flatMap { $0.locations }
    }
    
    var streamingWebsite: [String] {
        return locations.map { $0.platformDisplayName }
    }
    
    var streamingWebsiteIcon: [String] {
        return locations.map { $0.icon }
    }
}
