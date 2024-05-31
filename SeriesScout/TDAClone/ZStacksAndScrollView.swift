//
//  ZStacksAndScrollView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/05/2024.
//

import Foundation
import SwiftUI

struct CoachMarkModifier: ViewModifier {
    //TODO: Remove CoachMarkFactory way of doing things. Instead, values should be initialised from a ViewModel, or within a view, to avoid FirebaseWrapper type scenario. This currently violates the open/close principle for SOLID as I have to modify the base class of Factory to add extra features. Explore other SOLID principles too, how I've separated stuff out.
    let coachMarkType: CoachMarkFactory.CoachMarkType
    var coachMarkStorage: CoachMark?
    private var shouldShowCoachMark: Bool {
        coachMarkStorage?.wrappedValue ?? false
    }
    
    func body(content: Content) -> some View {
        
        // Note: We're protecting the code here; if we don't have a coach mark, we will never show an empty coachmark or view. Another option would have been to inject an empty coach mark into the factory. But if somebody changes the code in the future, we have the risk of it appearing. This way, we can prevent that happening.
        
        if let coachMark = coachMarkStorage {
            content
                .popover(isPresented: .constant(shouldShowCoachMark), content: {
                    CoachMarkFactory.createCoachMark(type: coachMarkType, userDefaults: coachMark.projectedValue, key: coachMark.keyBase)
                        .presentationCompactAdaptation(.popover)
                        .presentationBackground(.white)
                })
        } else {
            content
        }
    }
}

extension View {
    func coachMark(coachMarkType: CoachMarkFactory.CoachMarkType, coachMarkStorage: CoachMark?) -> some View {
        modifier(CoachMarkModifier(coachMarkType: coachMarkType, coachMarkStorage: coachMarkStorage))
    }
}

struct SearchCard: View {
    
    @State var buttonTapped: Bool = false // Ignore this
    
    var coachMark: CoachMark?
    
    init(coachMark: CoachMark? = nil) {
        self.coachMark = coachMark
    }
    
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
                } label: {
                    Image(systemName: buttonTapped ? "heart.fill" : "heart")
                        .resizable()
                }
                .frame(width: 50, height: 50)
                .coachMark(coachMarkType: .shortlist,
                           coachMarkStorage: coachMark)
            }
            
            Text("Eiffel Tower")
        }
        .padding()
        .border(.red)
    }
}

struct ExampleView: View {
    
    @CoachMark(key: "TestCoachMark", threshold: 0) var showCoachMark
    
    var body: some View {
        ScrollView {
            Button(action: {
                $showCoachMark.resetCoachMarks()
            }, label: {
                Text("Reset CoachMarks")
            })
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            
            Text("Should Show: \(showCoachMark.description)")
                .foregroundStyle(.red)
            
            SearchCard()
            SearchCard(coachMark: _showCoachMark)
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            
            // When moving to TDA, check the index for ForEach and use that.
        }
    }
}

#Preview {
    ExampleView()
}
