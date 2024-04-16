//
//  ShortlistView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 16/04/2024.
//

import SwiftUI

struct ShortlistView: View {
    @StateObject private var coachMarks = CoachMarksUserDefaults(viewKey: "shortlistViewCount", interactionKey: "shortlistButtonTapped")
    
    var body: some View {
        VStack {
            Button(action: {
                coachMarks.setInteraction()
            }) {
                Image(systemName: coachMarks.interactionOccurred ? "star.fill" : "star")
            }
            
            Text("View Count: \(coachMarks.viewCount)")
            Text("Interaction Occurred: \(coachMarks.interactionOccurred.description)")
        }
        .onAppear {
            coachMarks.incrementViewCount()
        }
    }
}

#Preview {
    ShortlistView()
}
