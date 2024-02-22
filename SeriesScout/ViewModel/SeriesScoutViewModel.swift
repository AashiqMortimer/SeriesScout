//
//  SeriesScoutViewModel.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation

class SeriesScoutViewModel: ObservableObject {
    
    let repository: SeriesScoutRepositoryRepresentable
    
    @Published var utellyData: UtellyModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var seriesName: String = ""
    @Published var seriesPicture: String? = nil
    @Published var streamingWebsite: String = ""
    @Published var streamingWebsiteIcon: String = ""
    
    init(repository: SeriesScoutRepositoryRepresentable) {
        self.repository = repository
    }
    
    func fetchUtellyData() {
        isLoading = true
        repository
            .fetchUtellyData { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let utellyData):
                        self?.buildSeries(utellyModel: utellyData)
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
    func buildSeries(utellyModel: UtellyModel) {
        let results = utellyModel.results
        
        seriesName = results.map { $0.name }.first!
        seriesPicture = results.map { $0.picture }.first!
        streamingWebsite = results.map { $0.locations.first!.platformDisplayName }.first!
        streamingWebsiteIcon = results.map { $0.locations.first!.icon }.first!
        
    }
}
