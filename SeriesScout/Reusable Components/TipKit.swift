//
//  TipKit.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 29/04/2024.
//

import SwiftUI
import TipKit

struct TipKitTestView: View {
    // List of things I cannot do with TipKit:
    // 1. Change arrow color
    // 2. Modify shadow effect
    
    // Positive things with TipKit:
    // 1. Dynamically handles positioning
    // 2. Can setup custom Rules, similar to the implementation of CoachMarks
    
    // Other considerations:
    // 1. Would have to add a .task to begin at the root TDA app level
    
    // 
    
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
//                .popoverTip(tip).tipViewStyle(CustomTip())
            Button("Shortlist"){
                
            }
            .buttonStyle(.borderedProminent)
            .padding(.leading, 300)
            .popoverTip(tip).tipViewStyle(CustomTip())
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
    
//    var actions: [Action] {
//        [
//            .init(
//                id: "cta",
//                perform: { self.invalidate(reason: .tipClosed) },
//                {
//                    Text("Got it")
//                        
//                })
//        ]
//    }
}

//VStack(alignment: .center, spacing: 12) {
//    Text(title)
//        .font(Constants.titleFont)
//        .foregroundStyle(Constants.messageColor)
//    Text(message)
//        .font(Constants.messageFont)
//        .multilineTextAlignment(.center)
//        .foregroundColor(Constants.messageColor)
//        .frame(maxWidth: .infinity, alignment: .top)
//        .fixedSize(horizontal: false, vertical: true)
//    
//    Button(buttonText) {
//        userDefaults.setInteraction(forKey: key)
//        //TODO: Currently, this is the only thing preventing users from seeing it again once it displays to them. If they navigate back and return, coachmarks will persist. I need to handle this scenario.
//    }
//    .buttonStyle(primaryButtonStyle)
//}
//.padding(.horizontal, 16)
//.padding(.vertical, 12)
////            .frame(width: 350, alignment: .top)
//.background(.white)
//.cornerRadius(12)

struct CustomTip: TipViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 12) {
            configuration.title
                .font(CoachMarkView.Constants.titleFont)
                .foregroundStyle(CoachMarkView.Constants.messageColor)
            
            configuration.message
                .font(CoachMarkView.Constants.messageFont)
                .foregroundStyle(CoachMarkView.Constants.messageColor)
            
            Button("Got it") {
                configuration.tip.invalidate(reason: .tipClosed)
            }
            .buttonStyle(PrimaryButton(
                backgroundColor: .blue,
                foregroundColor: Color(.white),
                font: Font.custom("Ambit-Bold", size: 18)
            ))
        }
        .padding()
        .background(.white)
    }
}

#Preview {
    TipKitTestView()
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}
