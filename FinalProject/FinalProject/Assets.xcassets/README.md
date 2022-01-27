# Assignment 4

## General Instructions

You have been provided with a shell of a SwiftUI application in the Assignment4/SwiftUIGameOfLife directory of the Assignments repository. You are responsible for making this application properly configure and manage the SimulationView. For this assignment we will be working completely on the overall look and feel of the application in the context of the Simulation tab.

Once again, you will make things work by a process of progressive disclosure, i.e. each working element will enable some part of the next element to work. So, in most instances, you will need to work the problems in order so that you can go on to the next element.

We will grade first by verifying the function of the application so all features need to operate reasonably.

Your code must have no errors or warnings. It should also make use of the Composable Architecture framework we have discussed in class in conjunction with the SwiftUI elements we have discussed in class this week.

Please leave the comments noting where your code should go in place as we will be using these in grading. Also, please be sure to put your code in the standard location in your repository.

A movie has been uploaded to the Materials directory showing an acceptable version of the app in operation. Use this as reference.

**_Additional Grading Information_**

The grader may, in his or her sole and unappealable discretion, SUBTRACT up to 25 points for tasteless, garish, ugly, unfashionable, disfigured or otherwise aesthetically challenged UI. As in a professional development shop, you are responsible for making this assignment look as if you cared.  NB, as in a professional dev shop, you don't have to _actually_ care, but you _do_ have to make it look as if you care.

Similarly, the grader may in his or her sole and unappealable discretion ADD up to 25 points for UI which:
    a) looks distinguishably nice on an iPad in both orientations or 
    b) which is so hilariously bad as to display conscious thought about how to illustrate and communicate UI anti-patterns to the grader.

In summary, don't just answer the problems, go through the app after doing so and tweak as necessary to give your app a desirable look and feel.

### Problem 1: Application Icon

Equip the application with an app icon using the techniques demonstrated in class. You will need to:

1. Select a 1024x1024 image to use as the icon
2. Use appicon.co to create an app icon package and move it to your xcasset bundle
3. Modify the splash screen to make sure to give proper attribution for any images that you use.

NB. Failure to provide attribution will result in a failing grade for the assignment.

### Problem 2: Color Palette

Equip the application with a color palette using the techniques demonstrated in class. You will need to provide the following named colors:

1. accent
2. alive
3. born
4. died
5. empty
6. gridBackground
7. gridLine

All colors must be provided in both light and dark modes and must _enhance_ visibility of the app. Don't make an ugly set of choices. In addition to strictly meeting the requirements this question will be graded subjectively and color choices which make the app hard to read will result in points being taken off.

### Problem 3: ContentView.swift

In the space marked, ensure that the Tab bar uses your accent color as the highlight color for the Tab items.

### Problem 4: ContentView.swift

As shown in class, use the SF Symbol app to select appropriate icons for the tab bar items. In the locations marked, replace the thumbs up icons with icons of your choosing. Again, these should make some degree of sense as judged subjectively by the grader or points will be deducted.

### Problem 5: InstrumentationView.swift

In the `control1` function, in the location shown, replace the EmptyView with two Text objects separated by a Spacer. Text 1 should have the following characteristics:

1. contain "Size _number of rows in the grid_"
2. use the number of rows obtained from the viewStore
3. use the system font in a size and weight of your choosing
4. have a width of your choosing
5. have a color of the accent color of the app

Text 2 should have the following characteristics:

1. contain the word Depth
2. have the same look and feel as the other Text.

NB. You need to be consistent in the look and feel for all problems below.

### Problem 6: InstrumentationView.swift

In the `control2` function, in the location shown, replace the EmptyView with a Slider and a Text object separated by a Spacer. The Slider should have the following characteristics:

1. obtain the value from a viewStore binding with `get` of the number of rows in the grid and set of the `setGridSize` action.
2. slide over values in the range 5 to 40
3. have a step size of 1
4. use void for the onEditingChanged
5. have a minimum value label of 5 whose font is consistent with the overall look
6. have a maximum value label of 40 whose font is consistent as well

Text should have the following characteristics:

1. contents should come from the cycleLength method in the InstrumentationView
2. look should be consistent with rest of the app
3. the frame should be a fixed size horizontally
4. text (if any) should be aligned trailing
5. should have a background color of white

### Problem 7: InstrumentationView.swift

In the control3 function, in the location shown, replace the EmptyView with a 2 Text objects separated by a Spacer. Text 1 should have the following characteristics:

1. contain "Refresh Period: _timer interval_"
2. use the timer interval obtained from the viewStore
3. look should be consistent with rest of the app
4. have a width of your choosing

Text 2 should have the following characteristics:

1. contain the word Simulation
2. be in the same font as Text 1
3. have a foreground color of red if the simulation timer is running

### Problem 8: InstrumentationView.swift

In the control4 function, in the location shown, replace the EmptyView with a Slider and a Toggle object separated by a Spacer. The Slider should have the following characteristics:

1. obtain the value from a viewStore binding with `get` of the timerInterval and set of the `setTimerInterval` action.
2. slide over values in the range 0.0 to 1.0
3. have a step size of 0.1
4. use void for the onEditingChanged
5. have a minimum value label of 0.0 whose font is consistent with the overall look
6. have a maximum value label of 1.0 whose font is consistent as well

Toggle should have the following characteristics:

1. set isOn with a binding from the viewStore of `get`: isRunningTimer, `set` .toggleTimer
2. be consistent with the look and feel of the rest of the app

### Problem 9: AppDelegate.swift

Insure that the Toggle created in Problem 8 uses your accent color for thumb tint rather than the system default.

### Problem 10: InstrumentationView.swift

In the buttons function replace the EmptyView with 3 ThemedButtons:

1. text: Step, action: .stepGrid
2. text: Empty, action: .resetGridToEmpty
3. text: Random, action: .resetGridToRandom

### Problem 11: ThemedButton.swift

In the location shown:

1. Make the foreground text of the button white
2. Make the background color of the button `accent`
3. Give the button a rectangular overlay, stroked white with a width of 2.0
4. Give the button a shadow of radius 2.0

### Problem 12: GridView.swift

In the location shown, guard for cellWidth > 5.0 simply return if it is not.

### Problem 13: GridView.swift

In the location shown, replace the code which draws an X over the grid with code which draws the horizontal and vertical lines of the grid getting the cell and grid characteristics from the view store and the geometry from the geometry proxy.

### Problem 14: GridView.swift

In the location stroke the lines with color gridLine and lineWidth specified by the configuration.

### Problem 15: GridView.swift

In the location shown, replace the EmptyView with code which, if the cell is alive, born or died, draws the a Cell of the grid using the provided Cell type. If the Cell is empty draw nothing.

### Problem 16: GridView.swift

In the location shown, supply a background color of gridBackground and a gesture handler of `touchHandler(for:)` to the lines view.

### Problem 17: GridView.swift

In the location shown, set the touchedCell variable to the appropriate value using the `convert` function of the GridView.

### Problem 18: GridView.swift

In the location shown send the appropriately configured .toggle action to the viewstore to cause the touchedCell to toggle its state.

### Problem 19: GridView.swift

In the location shown verify that the touch has occurred within the bounds of the grid. If it is outside those bounds, return .none

### Problem 20: SimulationView.swift

In the location shown provide an analogous stack to the verticalContent, making sure that the app presents well when in landscape orientation.
