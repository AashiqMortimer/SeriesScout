//
//  EnvironmentObject.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 29/05/2024.
//

import Foundation
import SwiftUI

//protocol SearchCardActionDelegate {
//    func didTapButton(for card: SearchCard2)
//}
//
//// Custom environment key for the delegate
//private struct CoachMarksDelegateKey: EnvironmentKey {
//    static let defaultValue: SearchCardActionDelegate? = nil
//}
//
//extension EnvironmentValues {
//    var coachMarksDelegate: SearchCardActionDelegate? {
//        get { self[CoachMarksDelegateKey.self] }
//        set { self[CoachMarksDelegateKey.self] = newValue }
//    }
//}
//
//
//struct SearchCard2: View {
//    
//    @EnvironmentObject var coachMarksDefaults: CoachMarksUserDefaults
//    @Environment(\.coachMarksDelegate) var delegate: SearchCardActionDelegate?
//    @CoachMark(key: "TestCoach", threshold: 0) var showCoachMark
//    
//    @State var buttonTapped: Bool = false
////    @CoachMark(key: "TestCoachMark", threshold: 0) var showCoachMark
//    
//    @Binding var showCoach: Bool
//    
//    init(showCoach: Binding<Bool> = .constant(false)) {
//        _showCoach = showCoach
//    }
//    
//    var applyCoachMarkRegular: Bool = false
//    
//    var body: some View {
//        VStack {
//            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
//                ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
//                    Image(systemName: "person")
//                        .resizable()
//                        .frame(width: 200, height: 200)
//                }
//                Button {
//                    buttonTapped.toggle()
////                    $showCoachMarkUserDefaults.resetCoachMarks()
//                } label: {
//                    Image(systemName: buttonTapped ? "heart.fill" : "heart")
//                        .resizable()
//                }
//                .frame(width: 50, height: 50)
//                .popover(isPresented: $showCoach, content: {
//                    CoachMarkFactory.shortlistCoachMark()
//                        .presentationCompactAdaptation(.popover)
//                        .presentationBackground(.white)
//                        .onTapGesture {
//                            $showCoachMark.setInteraction(forKey: "TestCoach")
//                            delegate?.didTapButton(for: self)
//                        }
//                })
//            }
//            
//            Text("Eiffel Tower")
//        }
//        .padding()
//        .border(.red)
//
//    }
//}
//
//struct ExampleView2: View, SearchCardActionDelegate {
//    func didTapButton(for card: SearchCard2) {
//        coachMarksDefaults.setInteraction(forKey: "TestCoach")
//    }
//    
//    
////    @EnvironmentObject var coachMarksUserDefaults: CoachMarksUserDefaults
//    @StateObject var coachMarksDefaults = CoachMarksUserDefaults()
////    @CoachMark(key: "TestCoach", threshold: 0) var showCoachMark
//    
//    var body: some View {
//        ScrollView {
////            Button(action: {
////                $showCoachMark.resetCoachMarks()
////            }, label: {
////                Text("Reset CoachMarks")
////            })
////            .buttonStyle(.borderedProminent)
////            .foregroundStyle(.white)
////            
////            Text("Should Show: \(showCoachMark.description)")
////                .foregroundStyle(.red)
//            
//            SearchCard()
//            SearchCard()
//                .environmentObject(coachMarksDefaults)
//                .environment(\.coachMarksDelegate, self)
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
//        }
//    }
//    
//}
//
//#Preview {
//    ExampleView2()
//}
