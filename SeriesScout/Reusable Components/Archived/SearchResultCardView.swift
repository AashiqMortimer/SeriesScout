//
//  SearchResultCardView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/05/2024.
//

import Foundation
import SwiftUI

//struct SearchResultCardView: View {
//    
//    @CoachMark(key: Constants.coachMarkKey, threshold: 2) var showShortlistCoachMark
//    
//    var body: some View {
//        VStack {
//            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
//                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
//                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
//                        Image(systemName: "person")
//                            .scaledToFill()
//                            .frame(maxHeight: Constants.imageSize.height)
//                            .clipped()
//                    }
//                }
//                
//                shortlistButton
//                    .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist, coachedFeature: .zero)
//                    .onTapGesture {
//                        $showShortlistCoachMark.setInteraction(forKey: Constants.coachMarkKey)
//                    }
//            }
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Text("Excursion")
//                        .foregroundColor(Constants.darkBlue)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                
////                ratingOverviewView
//                
//                locationView
//                
//                dottedLine
//                
//            }
//            .buttonStyle(primaryButtonStyle)
//            .padding(.horizontal, Constants.sideSpace)
//            .padding(.bottom, 8.0)
//        }
//        .modifier(CardsBorderModifier(radius: Constants.cornerRadius, bgColor: .white))
//        .onFirstAppear {
//            $showShortlistCoachMark.incrementViewCount(forKey: Constants.coachMarkKey)
//            print("Coach Mark - View Count is: \($showShortlistCoachMark.viewCount(forKey: Constants.coachMarkKey))")
//            print("Coach Mark - Interaction Flag: \($showShortlistCoachMark.interactionFlags)")
//            print("Coach Mark - Should Show: \(showShortlistCoachMark)")
//        }
//    }
//    
//    let primaryButtonStyle = PrimaryButton(
//        backgroundColor: .blue,
//        foregroundColor: Color(.white),
//        font: Font.custom("Ambit-Bold", size: 18)
//    )
//    
//    var ratingOverviewView: some View {
//        HStack {
//            ResultsRatingOverviewView()
//            Spacer()
//        }
//    }
//    
//    var locationView: some View {
//        VStack {
//            HStack {
//                IconTextView(iconName: ImageResource.brand, text: "France", foregroundColor: Constants.darkBlue)
//                
//                Spacer()
//                
//            }
//        }
//    }
//    
//    
//    var shortlistButton: some View {
//        Button {
//        } label: {
//            Image(systemName: "heart")
//                .foregroundColor(.blue)
//        }
//        //        .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
//        .buttonStyle(PlainButtonStyle())
//        .frame(width: Constants.shortlistButtonSize.width, height: Constants.shortlistButtonSize.height)
//        .padding(.top, Constants.sideSpace)
//        .padding(.trailing, Constants.sideSpace)
//    }
//    
//    private var dottedLine: some View {
//        HLine()
//            .stroke(
//                Color(.gray),
//                style: StrokeStyle(
//                    lineWidth: 1,
//                    dash: [7]
//                )
//            )
//            .frame(height: 1)
//            .padding(.top, 4.0)
//            .padding(.bottom, 0.0)
//    }
//    
//    var priceView: some View {
//        Text("£10")
//            .lineLimit(1)
//    }
//    
//    private enum Constants {
//        static var padding: CGFloat { 16.0 }
//        static var sideSpace: CGFloat { 12.0 }
//        static var imageSize: CGSize { CGSize(width: 347.0, height: 180.0) }
//        static var badgeSize: CGSize { CGSize(width: 55.0, height: 55.0) }
//        static var ngdaytoursBadgeSize: CGSize { CGSize(width: 130.0, height: 40) }
//        static var shortlistButtonSize: CGSize { CGSize(width: 24.0, height: 24.0) }
//        static var iconSize: CGSize { CGSize(width: 13.0, height: 13.0) }
//        static var cornerRadius: CGFloat { 12.0 }
//        static var leading: CGFloat { 29.0 }
//        static var tagsVerticalPadding: CGFloat { 2.0 }
//        static var tagsHorizontalPadding: CGFloat { 4.0 }
//        static var tagsHeight: CGFloat { 26.0 }
//        static var darkBlue: Color { Color(.blue) }
//        static var transferIncluded: String { return "excursions_transfer_included" }
//        static var greenAndFair: String { return "green_and_fair_experience_tag" }
//        static var coachMarkKey: String { return "EAT-Shortlist"}
//        
//        enum Accessibility {
//            static var identifier: String { "excursion_results" }
//            static var tuiCollection: String { "tui_collection" }
//            static var natGeo: String { "nat_geo" }
//            static var location: String { "location" }
//            static var rating: String { "rating" }
//            static var tag: String { "tag" }
//            static var shortlist: String { "shortlist" }
//            static var selected: String { "selected" }
//            static var unselected: String { "unselected" }
//            static var calendar: String { "calendar" }
//            static var durationValidity: String { "durationValidity" }
//        }
//    }
//}
//
//// MARK: Utilities
//
//struct CardsBorderModifier: ViewModifier {
//    
//    var radius: CGFloat = 2.0
//    var bgColor: Color = Color.clear
//    
//    func body(content: Content) -> some View {
//        return content
//            .cornerRadius(radius)
//            .background(RoundedRectangle(cornerRadius: radius).fill(bgColor))
//            .overlay(RoundedRectangle(cornerRadius: radius)
//                .stroke(Color(.gray), lineWidth: 1.0))
//    }
//}
//
//extension View {
//    
//    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
//        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
//    }
//}
//
//struct CornerRadiusStyle: ViewModifier {
//    let radius: CGFloat
//    let corners: UIRectCorner
//    
//    struct CornerRadiusShape: Shape {
//        
//        var radius = CGFloat.infinity
//        var corners = UIRectCorner.allCorners
//        
//        func path(in rect: CGRect) -> Path {
//            let path = UIBezierPath(roundedRect: rect,
//                                    byRoundingCorners: corners,
//                                    cornerRadii: CGSize(width: radius, height: radius))
//            return Path(path.cgPath)
//        }
//    }
//    
//    func body(content: Content) -> some View {
//        content
//            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
//    }
//}
//
//struct OnFirstAppear: ViewModifier {
//    // MARK: - Properties
//    
//    let onAppear: () -> Void
//    
//    @State private var hasAppeared = false
//    
//    // MARK: - Body
//    
//    func body(content: Content) -> some View {
//        content.onAppear {
//            guard !hasAppeared else { return }
//            hasAppeared.toggle()
//            onAppear()
//        }
//    }
//}
//
//// MARK: - Modifier
//
//extension View {
//    /// Modifier that allows code to run only on the first appearance of the View
//    ///
//    /// - HOW TO USE: .onFirstAppear { ` code to execute `}
//    ///
//    public func onFirstAppear(_ action: @escaping () -> Void) -> some View {
//        modifier(OnFirstAppear(onAppear: action))
//    }
//}
//
//struct IconTextView: View {
//    
//    let iconName: ImageResource
//    let renderingMode: Image.TemplateRenderingMode?
//    let text: String
//    let textLineLimit: Int
//    let textFont: Font
//    let foregroundColor: Color?
//    let iconSize: CGSize
//    let angle: Double
//    
//    init(
//        iconName: ImageResource,
//        renderingMode: Image.TemplateRenderingMode? = .template,
//        text: String,
//        textLineLimit: Int = 0,
//        textFont: Font = .body,
//        foregroundColor: Color = Color(.gray),
//        iconSize: CGSize = CGSize(width: 16.0, height: 16.0),
//        angle: Double = 0
//    ) {
//        self.iconName = iconName
//        self.renderingMode = renderingMode
//        self.text = text
//        self.textLineLimit = textLineLimit
//        self.textFont = textFont
//        self.foregroundColor = foregroundColor
//        self.iconSize = iconSize
//        self.angle = angle
//    }
//    
//    var body: some View {
//        HStack {
//            Image(iconName)
//                .renderingMode(renderingMode)
//                .resizable()
//                .scaledToFit()
//                .frame(width: iconSize.width, height: iconSize.height)
//                .foregroundColor(foregroundColor)
//                .rotationEffect(.degrees(angle))
//            Text(text)
//                .font(textFont)
//                .foregroundColor(Color.gray)
//                .lineLimit(textLineLimit)
//        }
//        
//    }
//}
//
//struct HLine: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: rect.width, y: 0))
//        return path
//    }
//}
//
//#Preview {
//    SearchResultCardView()
//}
