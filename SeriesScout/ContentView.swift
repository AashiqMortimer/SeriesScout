//
//  ContentView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = SeriesScoutViewModel(repository: SeriesScoutRepository())
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text(viewModel.seriesName)
            Text(viewModel.streamingWebsite)
        }
        .padding()
        .onAppear(perform: {
            viewModel.fetchUtellyData()
        })
    }
}

#Preview {
    ContentView(viewModel: SeriesScoutViewModel(repository: SeriesScoutRepository()))
}
