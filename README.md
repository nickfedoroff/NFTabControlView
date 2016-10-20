# NFTabControlView
An iOS tab control that just works.

## Learn About It
`NFTabControlView` is very similar to `UISegmentedControl` only with a delegate-base interface and a nice animated tab indicator.

## Install It

### Cocoapods
Coming soon.

### Manual Installation
Download and drag the files into your Swift 3 project.

## Use It
1. Create an instance of `NFTabControlView` either in a storyboard or using the `init:frame` initializer.
2. Assign a delegate and implement required methods.

**Required METHODS**

Text and indicator color:
```swift
    func tabControlView(colorFor controlView: NFTabControlView) -> UIColor {
        return .blue
    }
```
The index of the tab the user has tapped (the "do something" method):
```swift
    func tabControlView(controlView: NFTabControlView, didSelectTabAt index: Int) {
        print(index)
    }
```
Tab titles. The tabs are created in the order of the strings in the array you provide:
```swift
    func tabControlView(titlesForTabsIn controlView: NFTabControlView) -> [String] {
        return ["Nick", "Jenny", "Max", "Mo"]
    }
```
**OPTIONAL METHODS**

Indicator style. Options are `.dot` and `.tabWidth`. Default is a rectangle 1/2 width of the tabs.
```swift
    func tabControlView(indicatorStyleFor controlView: NFTabControlView) -> NFTabControlViewIndicatorStyle? {
        return .tabWidth
    }
```

Font for un-selected tabs (default is 13pt regular system font):
```swift
    func tabControlView(fontFor controlView: NFTabControlView) -> UIFont? {
        return UIFont.monospacedDigitSystemFont(ofSize: 15, weight: UIFontWeightRegular)
    }
```

Font for selected tab (default is 13pt bold system font):
```swift
    func tabControlView(fontForselectedTabIn controlView: NFTabControlView) -> UIFont? {
        return UIFont.monospacedDigitSystemFont(ofSize: 15, weight: UIFontWeightBold)
    }
```
