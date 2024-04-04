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
        let brandColor = viewModel.returnBrandColor(streamingWebsite: viewModel.streamingWebsite)
        
        NavigationStack {
            GeometryReader { geometry in
                VStack() {
                    VStack() {
                        iconImage
                            .frame(width: geometry.size.width)
                            .padding(.top, 90)
                            .colorMultiply(brandColor)
                            .saturation(1.5)
                        Spacer()
                        headerImage
                            .frame(width: geometry.size.width)
                        Spacer()
                        Text(viewModel.seriesName)
                            .foregroundStyle(brandColor.opacity(0.8))
                            .font(.largeTitle)
                            .bold()
                            .saturation(1)
                        Spacer()
                    }
                    
                }
                //TODO: Change to a .task with a do / catch block to handle errors (requires changing fetch method)
                .onAppear(perform: {
                    viewModel.fetchUtellyData()
                })
                .searchable(text: $viewModel.searchText, isPresented: .constant(true), placement: .navigationBarDrawer, prompt: "Search for TV Series")
                .onSubmit(of: .search) {
                    viewModel.fetchUtellyData()
                }
            }
            .toolbarBackground(Color.red, for: .navigationBar)
            .background(Constants.Colors.background.tint(.clear))
            .edgesIgnoringSafeArea(.bottom)
        }
        .tint(Constants.Colors.titleColor)
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
            static var background: Color = Color(.gray)
            static var titleColor: Color = Color(.title)
        }
    }
}

#Preview {
    ResultView(viewModel: SeriesScoutViewModel(networkService: SeriesScoutNetworkService()))
}
