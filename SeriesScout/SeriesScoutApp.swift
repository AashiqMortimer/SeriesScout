//
//  SeriesScoutApp.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import SwiftUI

@main
struct SeriesScoutApp: App {
    var body: some Scene {
        WindowGroup {
            ResultView(viewModel: SeriesScoutViewModel(networkService: SeriesScoutNetworkService()))
        }
    }
}
