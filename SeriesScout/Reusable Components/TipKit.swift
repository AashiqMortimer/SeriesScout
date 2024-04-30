//
//  TipKit.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 29/04/2024.
//

import SwiftUI
import TipKit

struct TipKitTestView: View {
    let tip = TipKit()
    
    var body: some View {
        VStack {
            Text("This is a test space")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.red)
                .padding(.bottom, 10)
            Text("Visits Not Shown")
                .foregroundStyle(.white)
                .frame(width: 250, height: 30)
                .background(.green)
            Text("Interaction Not Shown")
                .foregroundStyle(.white)
                .frame(width: 250, height: 30)
                .background(.yellow)
            Button("Shortlist"){
                
            }
            .buttonStyle(.borderedProminent)
            .padding(.leading, 300)
            .popoverTip(tip, arrowEdge: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}

struct TipKit: Tip {
    var title: Text {
        Text("Add to your shortlist")
    }
    var message: Text? {
        Text("You can save and compare your favourite holidays by adding them to your shortlist")
    }
}

#Preview {
    TipKitTestView()
        .task {
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}
