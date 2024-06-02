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
    var coachMarkStorage: CoachMark?
    let title: String
    let message: String
    let buttonText: String
    private var shouldShowCoachMark: Bool {
        coachMarkStorage?.wrappedValue ?? false
    }
    
    func body(content: Content) -> some View {
        // Note: We're protecting the code here; if we don't have a coach mark, we will never show an empty coachmark or view. Another option would have been to inject an empty coach mark into the factory. But if somebody changes the code in the future, we have the risk of it appearing. This way, we can prevent that happening.
        if let coachMark = coachMarkStorage {
            content
                .popover(isPresented: .constant(shouldShowCoachMark), content: {
                    CoachMarkView(title: title, message: message, buttonText: buttonText, storage: coachMark)
                        .presentationCompactAdaptation(.popover)
                        .presentationBackground(.white)
                        .interactiveDismissDisabled() // This prevents any motion so may not be ideal
                })
        } else {
            content
        }
    }
}

extension View {
    func coachMark(coachMarkStorage: CoachMark?, title: String, message: String, buttonText: String) -> some View {
        modifier(CoachMarkModifier(coachMarkStorage: coachMarkStorage, title: title, message: message, buttonText: buttonText))
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
                .coachMark(coachMarkStorage: coachMark, 
                           title: Constants.shortlistTitle,
                           message: Constants.shortlistMessage,
                           buttonText: Constants.buttonText)
            }
            
            Text("Eiffel Tower")
        }
        .padding()
        .border(.red)
    }
    
    struct Constants {
        static let shortlistTitle = "Add to your shortlist"
        static let shortlistMessage = "You can save and compare your favourite holidays by adding them to your shortlist"
        static let buttonText = "Got it"
    }
}

struct ExampleView: View {
    
    @CoachMark(key: "TestCoachMark", threshold: 3) var showCoachMark
    
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
        .onAppear(perform: {
            $showCoachMark.incrementViewCount(for: _showCoachMark)
            print("View: \($showCoachMark.viewCounts)")
            print("Interaction: \($showCoachMark.interactionFlags)")
        })
    }
}

#Preview {
    ExampleView()
}
