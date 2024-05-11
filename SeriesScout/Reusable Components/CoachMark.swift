//
//  CoachMark.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import Foundation
import SwiftUI

struct CoachMarkView: View {
    
    let title: String
    let message: String
    let buttonText: String
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
    var coachMarkWrapper: CoachMark
    let spacing: CGFloat
    let coachMarkType: CoachMarkFactory.CoachMarkType

    func body(content: Content) -> some View {
        content
            .overlay {
                if coachMarkWrapper.wrappedValue {
                    GeometryReader { proxy in
                        let pointerHeight: CGFloat = 33
                        let pointerWidth: CGFloat = 35
                        
                        // Issue: I can't seem to read where the screen midpoint is without using UIScreen. GeometryReader in this context only provides me with the CoachMark X, Y coordinates.
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
                            
//                            content.view.window?.windowScene?.screen.bounds.height
//                            UIHostingController(rootView: "coachMark").rootView
                            
                            // Can change the x coordinate to UIScreen.main.bounds.width but it's not precise enough
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
//                .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
                
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
    
    struct Constants {
        static let key = "EAT-Shortlist-Test"
    }
}

#Preview {
    TestView2()
}
