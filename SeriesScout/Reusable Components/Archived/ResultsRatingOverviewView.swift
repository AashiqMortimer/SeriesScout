//
//  ResultsRatingOverviewView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/05/2024.
//

import SwiftUI

struct ResultsRatingOverviewView: View  {

    var body: some View {
        HStack(spacing: Constants.padding) {
            HStack(spacing: Constants.padding) {
                Image(.error)
                    .renderingMode(.template)
                    .foregroundColor(.yellow)
                    .frame(width: Constants.imageDimension, height: Constants.imageDimension)
                Text("5")
                    .foregroundColor(.yellow)

            }

            Text("100")
                .foregroundColor(.gray)
        }
        .frame(height: Constants.ratingTotalHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension ResultsRatingOverviewView {
    private enum Constants {
        static var cornerRadius: CGFloat { 2.0 }
        static var padding: CGFloat { 4.0 }
        static var ratingTotalHeight: CGFloat { 17.0 }
        static var starAndRatingHeight: CGFloat { 22.0 }
        static var starAndRatingWidth: CGFloat { 41.0 }
        static var imageDimension: CGFloat { 16.0 }
    }
}
