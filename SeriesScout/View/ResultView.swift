//
//  ContentView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import SwiftUI

struct ResultView: View {
    
    @ObservedObject var viewModel = SeriesScoutViewModel(networkService: SeriesScoutNetworkService())
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 200) {
                    VStack(spacing: 90) {
                        iconImage
                            .frame(width: geometry.size.width)
                            .padding(.top, 90)
                        Text(viewModel.seriesName)
                            .foregroundStyle(Constants.Colors.titleColor)
                            .font(.largeTitle)
                            .padding(.top, 50)
                        headerImage
                            .frame(width: geometry.size.width, alignment: .bottom)
                            .ignoresSafeArea(.all)
                            .padding(.top, 76)
                    }
                    
                }
                .background(Constants.Colors.background.tint(.clear))
                //TODO: Change to a .task with a do / catch block to handle errors (requires changing fetch method)
                .onAppear(perform: {
                    viewModel.fetchUtellyData()
                })
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: "Search for TV Series")
                
                .onSubmit(of: .search) {
                    viewModel.fetchUtellyData()
                }
            }
            .toolbarBackground(Color.red, for: .navigationBar)
        }
        .tint(Constants.Colors.titleColor)
        .ignoresSafeArea()
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
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(height: 100)
                    .colorInvert()
                    .colorMultiply(viewModel.returnBrandColor(streamingWebsite: viewModel.streamingWebsite))
            },
            placeholder: {
                ProgressView()
            })
    }
    
    var searchBar: some View {
        
        
        HStack {
            TextField("Search", text: $viewModel.searchText)
            
            Button(action: {
                viewModel.searchText = ""
            }) {
                Image(systemName: "magnifyingglass.circle")
                    .foregroundColor(.black)
            }
        }.padding()
    }
    
    private enum Constants {
        
        enum Colors {
            static var background: Color = Color(.appBackground)
            static var titleColor: Color = Color(.title)
        }
    }
}

#Preview {
    ResultView(viewModel: SeriesScoutViewModel(networkService: SeriesScoutNetworkService()))
}
