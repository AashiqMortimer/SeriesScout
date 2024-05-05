//
//  ContentView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import SwiftUI

struct ResultView: View {
    
    @ObservedObject var viewModel = SeriesScoutViewModel(networkService: SeriesScoutNetworkService())
    @State private var isSearchActive = false
    
    var body: some View {
        let brandColor = viewModel.returnBrandColor(streamingWebsite: viewModel.streamingWebsite)
        
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                //TODO: Could add a skeleton loading view with a flashing animation where opacity changes
            case .success:
                NavigationStack {
                    VStack() {
                        iconImage
                            .padding(.top, 90)
                            .colorMultiply(brandColor)
                            .saturation(1.5)
                        Spacer()
                        NavigationLink(destination: TestView2()) {
                            Text("Open TestView")
                        }
                        .buttonStyle(.borderedProminent)
                        NavigationLink(destination: GeometryReaderTestView()) {
                            Text("Open PointerTest")
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                        headerImage
                        Spacer()
                        Text(viewModel.seriesName)
                            .foregroundStyle(brandColor.opacity(0.8))
                            .font(.largeTitle)
                            .bold()
                            .saturation(1)
                        Spacer()
                    }
                    .background(Constants.Colors.background.tint(.clear))
                    .edgesIgnoringSafeArea(.bottom)
                }
                .tint(Constants.Colors.titleColor)
                
            case .failure:
                //TODO: Could use NetworkError enum (in NetworkService) to create contextual error pages. Can add an initialiser to error view to change the text dependent on the error type.
                GenericErrorView()
            }
        }
        .onAppear(perform: {
            viewModel.fetchUtellyData()
        })
        .searchable(text: $viewModel.searchText, isPresented: $isSearchActive, placement: .navigationBarDrawer, prompt: "Search for TV Series")
        .onSubmit(of: .search) {
            viewModel.fetchUtellyData()
        }
    }
    
    private enum Constants {
        enum Colors {
            static var background: Color = Color(.gray)
            static var titleColor: Color = Color(.title)
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
}

#Preview {
    ResultView(viewModel: SeriesScoutViewModel(networkService: SeriesScoutNetworkService()))
}
