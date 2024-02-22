//
//  ContentView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import SwiftUI

struct ResultView: View {
    
    @ObservedObject var viewModel = SeriesScoutViewModel(repository: SeriesScoutRepository())
    @State private var searchText: String = ""
    
    
//    var body: some View {
//        GeometryReader { geometry in
//            Color(Constants.Colors.background)
//                .ignoresSafeArea(.all)
//            
//            VStack(spacing: 200) {
//                headerImage
//                    .frame(width: geometry.size.width, alignment: .top)
//                    .ignoresSafeArea(.all)
//                VStack(spacing: 90) {
//                    Text(viewModel.seriesName)
//                        .foregroundStyle(Constants.Colors.titleColor)
//                        .font(.largeTitle)
//                    iconImage
//                        .frame(width: geometry.size.width - 60)
//                }
//            }
//            .onAppear(perform: {
//                viewModel.fetchUtellyData()
//            })
//        }
//    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Color(Constants.Colors.background)
                    .ignoresSafeArea(.all)
                VStack(spacing: 200) {
                    VStack(spacing: 90) {
                        iconImage
                            .frame(width: geometry.size.width - 60)
                            .padding(.top, 60)
                        Text(viewModel.seriesName)
                            .foregroundStyle(Constants.Colors.titleColor)
                            .font(.largeTitle)
                            .padding(.top, 50)
                        headerImage
                            .frame(width: geometry.size.width, alignment: .bottom)
                            .ignoresSafeArea(.all)
                            .padding(.top, 76)
                    }
                    .searchable(text: $searchText, placement: .toolbar, prompt: "Search for TV Series")
                    
                }
                .onAppear(perform: {
                    // Need to add an argument to this fetch so it takes $searchText and in the function, it can use this to populate the URL call:
                    viewModel.fetchUtellyData()
                })
            }
        }
    }
    
    var headerImage: some View {
        AsyncImage(
            url: URL(string: viewModel.seriesPicture ?? "Error"),
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: 200)
                    .ignoresSafeArea(.all)
            },
            placeholder: {
                ProgressView()
            })
    }
    
    var iconImage: some View {
        AsyncImage(
            url: URL(string: viewModel.streamingWebsiteIcon),
            content: { icon in
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: 100)
            },
            placeholder: {
                ProgressView()
            })
    }
    
    private enum Constants {
        
        enum Colors {
            static var background: Color = Color(.appBackground)
            static var titleColor: Color = Color(.title)
        }
    }
}

#Preview {
    ResultView(viewModel: SeriesScoutViewModel(repository: SeriesScoutRepository()))
}
