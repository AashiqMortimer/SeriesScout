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

- [ ] Rename anything with 'wrapper' in it. Happy with modifier
- [ ] Get rid of factory and instantiate view directly

Potentially use the feature flag that Diogo presents on Monday's iOS Chapter meeting.

