//
//  ZStacksAndScrollView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/05/2024.
//

import Foundation
import SwiftUI

//struct SearchCard: View {
//    
//    @EnvironmentObject var coachMarksUserDefaults: CoachMarksUserDefaults
//    
//    @State var buttonTapped: Bool = false
////    @CoachMark(key: "TestCoachMark", threshold: 0) var showCoachMarkUserDefaults
//    
//    @Binding var showCoach: Bool
//    
//    init(showCoach: Binding<Bool> = .constant(false)) {
//        _showCoach = showCoach
//    }
//    
////    @Binding var showCoach: Bool // I can then use this as a generic bool, gaining access to what a Bool does. When I have it connected in the ExampleView, it can then have the actual data.
//    var applyCoachMarkRegular: Bool = false
//    
//    var body: some View {
//        VStack {
//            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
//                ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
//                    Image(systemName: "person")
//                        .resizable()
//                        .frame(width: 200, height: 200)
//
//                }
//                Button {
//                    buttonTapped.toggle()
////                    $showCoachMarkUserDefaults.resetCoachMarks()
//                } label: {
//                    Image(systemName: buttonTapped ? "heart.fill" : "heart")
//                        .resizable()
//                }
//                .frame(width: 50, height: 50)
////                .popover(isPresented: $showCoach, content: {
////                    CoachMarkFactory.shortlistCoachMark()
////                        .presentationCompactAdaptation(.popover)
////                        .presentationBackground(.white)
////                        .onTapGesture {
////                            coachMarksUserDefaults.setInteraction(forKey: "TestCoachMark")
////                        }
////                })
//            }
//            
//            Text("Eiffel Tower")
//        }
//        .padding()
//        .border(.red)
//
//    }
//    
//    private func didDismiss() {
//        self.buttonTapped.toggle()
//    }
//}
//
//struct ExampleView: View {
//    
//    @EnvironmentObject var coachMarksUserDefaults: CoachMarksUserDefaults
//    @CoachMark(key: "TestCoachMark", threshold: 0) var showCoachMark
//    
//    var body: some View {
//        ScrollView {
//            Button(action: {
//                $showCoachMark.resetCoachMarks()
//            }, label: {
//                Text("Reset CoachMarks")
//            })
//            .buttonStyle(.borderedProminent)
//            .foregroundStyle(.white)
//            
//            Text("Should Show: \(showCoachMark.description)")
//                .foregroundStyle(.red)
//            
//            SearchCard()
//            SearchCard(showCoach: .constant(showCoachMark))
//                .environmentObject(coachMarksUserDefaults)
//            SearchCard()
//            SearchCard()
//            SearchCard()
//            SearchCard()
//            SearchCard()
//            SearchCard()
//            SearchCard()
//            SearchCard()
//            SearchCard()
//            
//            /* TODO: Explore two things with breakpoints:
//            1. What was being passed when the bool value was not being initialised here?
//            2. What is currently being passed now? This should give me insight as to how to use my own UserDefaults value instead of the regular bool value.
//             */
//        }
//        
////            .popover(
////                isPresented: .constant(showCoachMark),
////                attachmentAnchor: .point(.center),
////                content: {
////                CoachMarkFactory.shortlistCoachMark(userDefaults: $showCoachMark, key: "TestCoachMark")
////                    .presentationCompactAdaptation(.none)
////                    .presentationBackground(.white)
////            })
//    }
//    
//}

#Preview {
    ExampleView()
}

struct CoachMarkModifier: ViewModifier {
    //TODO: Remove CoachMarkFactory way of doing things. Instead, values should be initialised from a ViewModel, or within a view, to avoid FirebaseWrapper type scenario. This currently violates the open/close principle for SOLID as I have to modify the base class of Factory to add extra features. Explore other SOLID principles too, how I've separated stuff out.
    let coachMarkType: CoachMarkFactory.CoachMarkType
    var coachMarkWrapper: CoachMark?
    private var shouldShowCoachMark: Bool {
        coachMarkWrapper?.wrappedValue ?? false
    }
    // Use a binding so that I can get rid of .constant (so that it is dynamic during visit)
    
//    let key: String
    
    func body(content: Content) -> some View {
        
        // Note: We're protecting the code here; if we don't have a coach mark, we will never show an empty coachmark or view. Another option would have been to inject an empty coach mark into the factory. But if somebody changes the code in the future, we have the risk of it appearing. This way, we can prevent that happening.
        
        if let coachMark = coachMarkWrapper {
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
    func coachMark(coachMarkType: CoachMarkFactory.CoachMarkType, coachMarkWrapper: CoachMark?) -> some View {
        modifier(CoachMarkModifier(coachMarkType: coachMarkType, coachMarkWrapper: coachMarkWrapper))
    }
}

struct SearchCard: View {
    
    @State var buttonTapped: Bool = false // Ignore this
    
    var coachMark: CoachMark?
    
//    @Binding var showCoach: Bool
    
    init(coachMark: CoachMark? = nil) {
//        _showCoach = showCoach
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
                           coachMarkWrapper: coachMark)
                
//                .popover(isPresented: $showCoach, content: {
//                    CoachMarkFactory.shortlistCoachMark(userDefaults: $showCoachMark, key: "TestCoachMark")
//                        .presentationCompactAdaptation(.popover)
//                        .presentationBackground(.white)
//                })
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
