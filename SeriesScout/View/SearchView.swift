//
//  SearchView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 22/02/2024.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ZStack {
            Color(.appBackground)
                .ignoresSafeArea(.all)
            VStack {
                Image("BrandImage")
                    .resizable()
                    .frame(height: 200)
                    .clipped()
            }
        }
    }
}

#Preview {
    SearchView()
}
