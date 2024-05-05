//
//  CoachMark.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import Foundation
import SwiftUI

struct CoachMarkView: View {
    
    // Requirements to take into consideration: Different screen sizes, scroll view
    // TODO: Try different test view configurations to initialise it with.
    
    let title: String
    let message: String
    let buttonText: String
//    let pointerPlacement: PointerView.PointerPlacement // Recommend against doing this: Have a preferred location: Left, Right, Top or Bottom. It needs to be dynamic so that it changes according to where the view is. (I assume, if the view is lower down the screen, coach should point down; if it is higher, it should point up...)
    let userDefaults: CoachMarksUserDefaults
    let key: String
    
    var body: some View {
//        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center, spacing: 12) {
                Text(title)
                    .font(Constants.titleFont)
                    .foregroundStyle(Constants.messageColor)
                Text(message)
                    .font(Constants.messageFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.messageColor)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(buttonText) {
                    userDefaults.setInteraction(forKey: key)
                    //TODO: Currently, this is the only thing preventing users from seeing it again once it displays to them. If they navigate back and return, coachmarks will persist. I need to handle this scenario.
                }
                .buttonStyle(primaryButtonStyle)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
//            .frame(width: 350, alignment: .top)
            .background(.white)
            .cornerRadius(12)
            
            //Iovanna: General idea behind SwiftUI development is defining rules of how you want things to display, and not setting strict framing sizes.
            
//            PointerView(width: 24, height: 33, alignment: .trailing, pointerPlacement: pointerPlacement)
            //TODO: Look at Binoy's implementation of sorting in Excursions. 
//        }
    }
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
    
    struct Constants {
        static let titleFont = Font.custom("AmbitBold", size: 17)
        static let messageFont = Font.custom("TUITypeLight-Regular", size: 17)
        static let messageColor = Color(red: 0.11, green: 0.07, blue: 0.36)
    }
}

struct CoachMarkModifier: ViewModifier {
    //TODO: Separate the modifier for the pop up vs the content within.
    // The modifier can just handle the pop up and sizing. I can then pass a View into them. 
    
    var coachMarkWrapper: CoachMark
    let spacing: CGFloat
    let coachMarkType: CoachMarkFactory.CoachMarkType
//    let anchorView: View
    //TODO: For the dimmer effect: Have an anchorView property in the modifier. Pass in an element which would be the view that I am modifying. Instead of applying this viewModifier to the Shortlist Button, I will be applying it to the overall VStack for the TestView body. That way, this view modifier will be able to modify the background property for the entire screen. The AnchorView will be the Shortlist button which I will handle in the below code. 

    func body(content: Content) -> some View {
        content
            .overlay { // Appearing behind views, why??
                if coachMarkWrapper.wrappedValue {
                    GeometryReader { proxy in
                        let pointerHeight: CGFloat = 33
                        let pointerWidth: CGFloat = 35
                        
                        let screenMidY = UIScreen.main.bounds.height / 2
                        let globalMidY = proxy.frame(in: .global).midY
                        
                        let yPosition = proxy.frame(in: .local).midY + pointerHeight + spacing
                        let rotation = globalMidY < screenMidY ? Angle(degrees: 0) : Angle(degrees: 180)
                        
                        let coachMark = CoachMarkFactory.createCoachMark(
                            type: coachMarkType,
                            userDefaults: coachMarkWrapper.projectedValue,
                            key: coachMarkWrapper.keyBase
                        )
                        ZStack {
                            coachMark
                                .padding(.top, proxy.frame(in: .local).maxY + spacing + 23)
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            Triangle()
                                .frame(width: pointerWidth, height: pointerHeight)
                                .position(x: proxy.frame(in: .local).midX,
                                          y: yPosition)
                                .rotationEffect(rotation)
                                .foregroundStyle(.white)
                        }
                        
                        //TODO: Initialise Pointer here and place it in the center of the view it is modifying
                    }
                }
            }
            .zIndex(1)
    }
}

extension View {
    func coachMark(coachMarkWrapper: CoachMark, spacing: CGFloat, type: CoachMarkFactory.CoachMarkType) -> some View {
        modifier(CoachMarkModifier(coachMarkWrapper: coachMarkWrapper, spacing: spacing, coachMarkType: type))
    }
}

struct CoachMarkFactory {
    enum CoachMarkType {
        case shortlist
    }
    
    static func createCoachMark(type: CoachMarkType, userDefaults: CoachMarksUserDefaults, key: String) -> CoachMarkView {
        switch type {
        case .shortlist:
            return shortlistCoachMark(userDefaults: userDefaults, key: key)
        }
    }
    
    static func shortlistCoachMark(userDefaults: CoachMarksUserDefaults, key: String) -> CoachMarkView {
        CoachMarkView(title: Constants.shortlistTitle,
                      message: Constants.shortlistMessage,
                      buttonText: Constants.buttonText,
                      userDefaults: userDefaults,
                      key: key)
    }
    
    struct Constants {
        static let shortlistTitle = "Add to your shortlist"
        static let shortlistMessage = "You can save and compare your favourite holidays by adding them to your shortlist"
        static let buttonText = "Got it"
    }
}

struct TestView2: View {
    @CoachMark(key: Constants.key, threshold: 0) var showShortlistCoachMark
    //TODO: Can I combine the wrapper initialisation with the modifier
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Button("Top Screen Button"){
                    $showShortlistCoachMark.setInteraction(forKey: Constants.key)
                }
                .buttonStyle(.borderedProminent)
                .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
                
                Text("Test")
                
                
                Text("This is a test space")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(.red)
                    .padding(.bottom, 10)
                    
                Text("Visits \($showShortlistCoachMark.viewCounts[Constants.key + "_viewCount"] ?? 0)")
                    .foregroundStyle(.white)
                    .frame(width: 250, height: 30)
                    .background(.green)
                Text("Interacted: \($showShortlistCoachMark.interactionFlags[Constants.key + "_interactionFlag"]?.description ?? false.description)")
                    .foregroundStyle(.white)
                    .frame(width: 250, height: 30)
                    .background(.yellow)
                HStack(spacing: 200) {
                    Text("Nothing")
                        .hidden()
                    Button("Shortlist"){
                        $showShortlistCoachMark.setInteraction(forKey: Constants.key)
                    }
                    .buttonStyle(.borderedProminent)
        //            .padding(.leading, 300)
                    .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
                }
            }
            .frame(height: 600)
            
            VStack(spacing: 20) {
                Text("Nothing")
                    .hidden()
                Button("Reset UserDefaults") {
                    $showShortlistCoachMark.resetCoachMarks()
                }
                .buttonStyle(.borderedProminent)
//                .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onAppear(perform: {
            $showShortlistCoachMark.incrementViewCount(forKey: Constants.key)
        })
    }
    
    var button1: some View {
        Button("Button 1") {}
            .buttonStyle(.borderedProminent)
    }
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
    
    struct Constants {
        static let key = "EAT-Shortlist-Test"
    }
}

#Preview {
    TestView2()
}
