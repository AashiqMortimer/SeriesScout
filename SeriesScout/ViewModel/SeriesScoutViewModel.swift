//
//  SeriesScoutViewModel.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation
import SwiftUI

enum SeriesScoutViewModelState {
    case loading
    case success
    case failure
}

class SeriesScoutViewModel: ObservableObject {
    
    let networkService: SeriesScoutNetworkServiceRepresentable
    
    @Published var utellyData: UtellyModel?
    @Published var state: SeriesScoutViewModelState = .loading
    @Published var errorMessage: String?
    @Published var seriesName: String = ""
    @Published var seriesPicture: String? = nil
    @Published var streamingWebsite: String = ""
    @Published var streamingWebsiteIcon: String = ""
    //TODO: Remove starting string and create a starting view to invite users to search (State -> welcome)
    @Published var searchText: String = "BoJack Horseman"
    
    init(networkService: SeriesScoutNetworkServiceRepresentable) {
        self.networkService = networkService
    }
    
    func fetchUtellyData() {
        state = .loading
        networkService
            .fetchUtellyData(searchTerm: searchText) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if !data.results.isEmpty{
                            self?.utellyData = data
                            self?.buildSeries(utellyModel: data)
                            self?.state = .success
                        } else {
                            self?.state = .failure
                        }
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.state = .failure
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
