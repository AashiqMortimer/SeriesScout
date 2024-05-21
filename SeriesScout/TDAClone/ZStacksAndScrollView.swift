//
//  ZStacksAndScrollView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/05/2024.
//

import Foundation
import SwiftUI

struct SearchCard: View {
    
    @State var buttonTapped: Bool = false
    @CoachMark(key: "TestCoachMark", threshold: 0) var showCoachMarkUserDefaults
    var applyCoachMarkRegular: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 200, height: 200)

                }
                Button {
                    buttonTapped.toggle()
                    $showCoachMarkUserDefaults.resetCoachMarks()
                } label: {
                    Image(systemName: buttonTapped ? "heart.fill" : "heart")
                        .resizable()
                }
                .frame(width: 50, height: 50)
//                .fullScreenCover(isPresented: .constant(buttonTapped), onDismiss: didDismiss, content: {
//                    Text("Test")
//                        .onTapGesture {
//                            buttonTapped.toggle()
//                        }
//                })
                .popover(isPresented: .constant(showCoachMarkUserDefaults == true && applyCoachMarkRegular == true), content: {
                    CoachMarkFactory.shortlistCoachMark(userDefaults: $showCoachMarkUserDefaults, key: "TestCoachMark")
                        .presentationCompactAdaptation(.popover)
                        .presentationBackground(.white)
                })
            }
            
            Text("Eiffel Tower")
        }
        .padding()
        .border(.red)

    }
    
    private func didDismiss() {
        self.buttonTapped.toggle()
    }
}

struct ExampleView: View {
    
    @CoachMark(key: "TestCoachMark", threshold: 0) var showCoachMark
    
    var body: some View {
        ScrollView {
            SearchCard(applyCoachMarkRegular: true)
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            
            /* TODO: Explore two things with breakpoints:
            1. What was being passed when the bool value was not being initialised here?
            2. What is currently being passed now? This should give me insight as to how to use my own UserDefaults value instead of the regular bool value.
             */
        }
        
//            .popover(
//                isPresented: .constant(showCoachMark),
//                attachmentAnchor: .point(.center),
//                content: {
//                CoachMarkFactory.shortlistCoachMark(userDefaults: $showCoachMark, key: "TestCoachMark")
//                    .presentationCompactAdaptation(.none)
//                    .presentationBackground(.white)
//            })
    }
    
}

#Preview {
    ExampleView()
}

