#  Refinement Notes

## CoachMarkView:

**TODO Items:** 

- [ ] Works for different screen sizes, scroll view
- [ ] Try different test view configurations to initialise it with.
- [ ] Currently, *userDefaults.setInteraction(forKey: key)* is the only thing preventing users from seeing it again once it displays to them. If they navigate back and return, coachmarks will persist. I need to handle this scenario.

**Mentorship Notes**
Iovanna: General idea behind SwiftUI development is defining rules of how you want things to display, and not setting strict framing sizes.

~~let pointerPlacement: PointerView.PointerPlacement~~
Recommend against doing this: Have a preferred location: Left, Right, Top or Bottom. It needs to be dynamic so that it changes according to where the view is. (I assume, if the view is lower down the screen, coach should point down; if it is higher, it should point up...)


## CoachMarkModifier: 

**Mentorsihp Notes**
Separate the modifier for the pop up vs the content within. The modifier can just handle the pop up and sizing. I can then pass a View into them.

For the dimmer effect: Have an anchorView property in the modifier. Pass in an element which would be the view that I am modifying. Instead of applying this viewModifier to the Shortlist Button, I will be applying it to the overall VStack for the TestView body. That way, this view modifier will be able to modify the background property for the entire screen. The AnchorView will be the Shortlist button which I will handle in the below code.

GeometryReader: Frame gives you measurements in super view coordinate system. Bounds does the opposite: Coordinates based on its own coordinate system. 0,0 -> MaxY, MaxX. Worth learning more, play around with the difference in Playgrounds.


## CoachMarksUserDefaults / CoachMark:


- [x] Rename CoachMarkWrapper to @CoachMark
- [ ] Instead of projectedValue as CoachMarksUserDefaults, have an object that manages the CoachMarksUserDefaults itself:

Struct within CoachMarkWrapper, struct CoachMarkValue
This will have the methods: setInteraction and incrementViewCount
Idea behind this is that it will have access to the keyBase so we wouldnt have to pass that each time in the view.
projectedValue can point to CoachMarkValue


## James Latest Notes:

- [x] Rename anything with 'wrapper' in it. Happy with modifier
- [x] Get rid of factory and instantiate view directly
- [ ] Update unit and snapshot tests

Potentially use the feature flag that Diogo presents on Monday's iOS Chapter meeting.

## Prior Attempt At Implementation:

struct SearchCard: View {
    
    @EnvironmentObject var coachMarksUserDefaults: CoachMarksUserDefaults
    
    @State var buttonTapped: Bool = false
//    @CoachMark(key: "TestCoachMark", threshold: 0) var showCoachMarkUserDefaults
    
    @Binding var showCoach: Bool
    
    init(showCoach: Binding<Bool> = .constant(false)) {
        _showCoach = showCoach
    }
    
//    @Binding var showCoach: Bool // I can then use this as a generic bool, gaining access to what a Bool does. When I have it connected in the ExampleView, it can then have the actual data.
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
                .popover(isPresented: $showCoach, content: {
                    CoachMarkFactory.shortlistCoachMark()
                        .presentationCompactAdaptation(.popover)
                        .presentationBackground(.white)
                        .onTapGesture {
                            coachMarksUserDefaults.setInteraction(forKey: "TestCoachMark")
                        }
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
    
    @EnvironmentObject var coachMarksUserDefaults: CoachMarksUserDefaults
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
            SearchCard(showCoach: .constant(showCoachMark))
                .environmentObject(coachMarksUserDefaults)
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
            SearchCard()
        }
    }
}

# Coach Marks:

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
    let coachedFeature: CGRect

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let screenMidY = proxy.frame(in: .global).midY
                    let buttonMidY = coachedFeature.midY
                    let isButtonInTopHalf = buttonMidY < screenMidY

                    let pointerHeight: CGFloat = 33
                    let coachMarkHeight = coachMarkWrapper.projectedValue.coachMarkHeight ?? 175
                    let totalHeight = pointerHeight + coachMarkHeight + spacing

                    let yPosition = isButtonInTopHalf ?
                        buttonMidY + totalHeight :
                        buttonMidY - totalHeight

                    let rotation = isButtonInTopHalf ? Angle(degrees: 0) : Angle(degrees: 180)

                    let coachMark = CoachMarkFactory.createCoachMark(
                        type: coachMarkType,
                        userDefaults: coachMarkWrapper.projectedValue,
                        key: coachMarkWrapper.keyBase
                    )

                    let screenCenterX = proxy.frame(in: .global).midX

                    ZStack {
                        coachMark
                            .position(
                                x: screenCenterX,
                                y: isButtonInTopHalf ?
                                yPosition - (pointerHeight / 2) :
                                    yPosition + (pointerHeight / 2)
                            )

                        Triangle()
                            .frame(width: 35, height: pointerHeight)
                            .position(x: screenCenterX, y: yPosition)
                            .rotationEffect(rotation, anchor: .top)
                            .foregroundStyle(.white)
                    }
                }
                .onPreferenceChange(CoachMarkHeightKey.self) { newHeight in
                    coachMarkWrapper.projectedValue.coachMarkHeight = newHeight
                }
                .zIndex(1)
            }
    }
}

extension View {
    func coachMark(coachMarkWrapper: CoachMark, spacing: CGFloat, type: CoachMarkFactory.CoachMarkType, coachedFeature: CGRect) -> some View {
        modifier(CoachMarkModifier(coachMarkWrapper: coachMarkWrapper, spacing: spacing, coachMarkType: type, coachedFeature: coachedFeature))
    }
}
