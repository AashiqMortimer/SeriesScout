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
        VStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(Constants.titleFont)
                .foregroundStyle(Constants.messageColor)
                .frame(maxWidth: .infinity)
            Text(message)
                .font(Constants.messageFont)
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.messageColor)
                .lineLimit(2)
                .frame(maxWidth: 295)
            
            Button(buttonText) {
                userDefaults.setInteraction(forKey: key)
                //TODO: Currently, this is the only thing preventing users from seeing it again once it displays to them. If they navigate back and return, coachmarks will persist. I need to handle this scenario.
            }
            .buttonStyle(primaryButtonStyle)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .fixedSize(horizontal: true, vertical: true)
        .background(.white)
        .cornerRadius(12)
        .background(GeometryReader { proxy in
            Color.clear.preference(key: CoachMarkHeightKey.self, value: proxy.size.height)
        })
        //Iovanna: General idea behind SwiftUI development is defining rules of how you want things to display, and not setting strict framing sizes.
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

struct CoachMarkHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CoachMarkModifier: ViewModifier {
    //TODO: Separate the modifier for the pop up vs the content within.
    // The modifier can just handle the pop up and sizing. I can then pass a View into them. 
    
    var coachMarkWrapper: CoachMark
    let spacing: CGFloat
    let coachMarkType: CoachMarkFactory.CoachMarkType
    
    //TODO: For the dimmer effect: Have an anchorView property in the modifier. Pass in an element which would be the view that I am modifying. Instead of applying this viewModifier to the Shortlist Button, I will be applying it to the overall VStack for the TestView body. That way, this view modifier will be able to modify the background property for the entire screen. The AnchorView will be the Shortlist button which I will handle in the below code.

    func body(content: Content) -> some View {
        content
            .overlay {
                if coachMarkWrapper.wrappedValue /* && coachMarkWrapper.projectedValue.coachMarkHeight != 0*/ {
                    GeometryReader { proxy in
                        let pointerHeight: CGFloat = 33
                        let pointerWidth: CGFloat = 35
                        // GeometryReader: Frame gives you measurements in super view coordinate system. Bounds does the opposite: Coordinates based on its own coordinate system. 0,0 -> MaxY, MaxX. Worth learning more, play around with the difference in Playgrounds.
                        
                        let screenMidY = UIScreen.main.bounds.height / 2 // Better off not using UIScreen measurements. Need to decide where the button is based on its coordinates.
                        let globalMidY = proxy.frame(in: .global).midY
                        
                        let yPosition = globalMidY < screenMidY ? 
                        proxy.frame(in: .local).midY + pointerHeight + spacing :
                        proxy.frame(in: .local).midY - pointerHeight + spacing + proxy.frame(in: .local).height
                        
                        let rotation = globalMidY < screenMidY ? Angle(degrees: 0) : Angle(degrees: 180)
                        
                        let coachMark = CoachMarkFactory.createCoachMark(
                            type: coachMarkType,
                            userDefaults: coachMarkWrapper.projectedValue,
                            key: coachMarkWrapper.keyBase
                        )
                        
                        // These do not work: I will try my own solution in Playground.
                        // Need to decide what to calculate based on button's coordinates: what can SwiftUI calculate for you.
                        
                        let screenCenterX = UIScreen.main.bounds.width / 2
                        let buttonCenterX = proxy.frame(in: .global).midX
                        let differenceX = screenCenterX - buttonCenterX
                        let coachMarkXPosition = UIDevice.currentDeviceIsPhone() ? screenCenterX : buttonCenterX + differenceX

                        // Adjust the x-axis position based on the device type and target view offset
                        
                        ZStack {
                            let coachMarkHeight = coachMarkWrapper.projectedValue.coachMarkHeight ?? 175
                            
                            
                            coachMark
                                .position(
                                    x: proxy.frame(in: .local).midX,
                                    y: globalMidY < screenMidY ?
                                    yPosition + (pointerHeight / 2) + (coachMarkHeight / 2) :
                                        yPosition - (pointerHeight / 2) - (coachMarkHeight / 2) - (pointerHeight * 2)
                                )
                            
                            Triangle()
                                .frame(width: pointerWidth, height: pointerHeight)
                                .position(x: proxy.frame(in: .local).midX,
                                          y: yPosition)
                                .rotationEffect(rotation, anchor: .top)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .onPreferenceChange(CoachMarkHeightKey.self) { newHeight in
                coachMarkWrapper.projectedValue.coachMarkHeight = newHeight
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
                
                Text("Test313313131313133131")
//                    .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
                
                
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
//                    .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
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
