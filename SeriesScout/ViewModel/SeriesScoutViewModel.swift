//
//  SeriesScoutViewModel.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation
import SwiftUI

class SeriesScoutViewModel: ObservableObject {
    
    let repository: SeriesScoutRepositoryRepresentable
    
    @Published var utellyData: UtellyModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var seriesName: String = ""
    @Published var seriesPicture: String? = nil
    @Published var streamingWebsite: String = ""
    @Published var streamingWebsiteIcon: String = ""
    @Published var searchText: String = "BoJack Horseman"
    // When a number is entered as a search term, it doesn't return anything. I need to handle the int values; look into this further. 
    
    init(repository: SeriesScoutRepositoryRepresentable) {
        self.repository = repository
    }
    
    func fetchUtellyData() {
        isLoading = true
        repository
            .fetchUtellyData(searchTerm: searchText) { [weak self] result in
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
    
    func returnBrandColor(streamingWebsite: String) -> Color {
        switch streamingWebsite {
        case "Netflix":
            return Color.red
        case _ where streamingWebsite.contains("iTunes"):
            return Color.white
        case _ where streamingWebsite.contains("Amazon"):
            return Color.blue
        case _ where streamingWebsite.contains("YouTube"):
            return Color.red
        case _ where streamingWebsite.contains("Disney"):
            return Color.blue
        case _ where streamingWebsite.contains("Hulu"):
            return Color.green
        case _ where streamingWebsite.contains("Google"):
            return Color.orange
        default:
            return Color.gray
        }
    }
}
