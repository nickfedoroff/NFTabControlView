# NFTabControlView
An iOS tab control that just works.

## Learn About It
`NFTabControlView` is very similar to `UISegmentedControl` only with a delegate-base interface and a nice animated tab indicator.

![alt tag](https://nickfedoroff.com/images/tabdemo.gif)

## Install It

### Cocoapods
Coming soon.

### Manual Installation
Download and drag `NFTabControlView.swift` and `NFTabControlView.xib` into your Swift 3 project.

## Use It
1. Create an instance of `NFTabControlView` either in a storyboard or using the `init:frame` initializer. `let tabControl = NFTabControlView(frame: frame)`
2. Assign a delegate and implement required methods.

**REQUIRED METHODS**

The index of the tab the user has tapped (the "do something" method):
```swift
    func tabControlView(controlView: NFTabControlView, didSelectTabAt index: Int) {
        print(index)
    }
```

Tab titles. Not technically required, but hopefully you have some more creative tab titles in mind.  The tabs are created in the order of the strings in the array you provide:

```swift
    tabControl.set(tabs: [“One”, “Two”, “Three”])
```

That’s it! Everything else is optional and controls aspects of the control’s appearance.


**OPTIONAL METHODS**

Text and indicator color:
```swift
    tabControl.set(color: UIColor.blue)
```

Indicator style. Options are `.dot` and `.tabWidth`. Default is a rectangle 1/2 width of the tabs.
```swift
    tabControl.setIndicator(style: .dot)
```

Font for un-selected tabs (default is 13pt regular system font):
```swift
    tabControl.setNormal(font: UIFont.systemFont(ofSize: 15))
```

Font for selected tab (default is 13pt bold system font):
```swift
    tabControl.setSelected(font: UIFont.boldSystemFont(ofSize: 17))
```
