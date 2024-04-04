//
//  GenericErrorView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 04/04/2024.
//

import Foundation
import SwiftUI

struct GenericErrorView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Image(.error)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                .border(.black, width: 2)
                
                VStack(spacing: 20) {
                    Text("Sorry, something \n went wrong 😔")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text("Please try searching again or check your internet connection.")
                        .font(.subheadline)
                        .frame(width: 275)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

#Preview {
    GenericErrorView()
}
