## Signal Strength Indicator

[![Version](https://img.shields.io/cocoapods/v/SignalStrengthIndicator.svg?style=flat)](http://cocoadocs.org/docsets/SignalStrengthIndicator)
[![License](https://img.shields.io/cocoapods/l/SignalStrengthIndicator.svg?style=flat)](http://cocoadocs.org/docsets/SignalStrengthIndicator)
[![Platform](https://img.shields.io/cocoapods/p/SignalStrengthIndicator.svg?style=flat)](http://cocoadocs.org/docsets/SignalStrengthIndicator)
[![CocoaPods](https://img.shields.io/cocoapods/dt/SignalStrengthIndicator.svg)](https://cocoapods.org/pods/SignalStrengthIndicator)
[![CocoaPods](https://img.shields.io/cocoapods/dm/SignalStrengthIndicator.svg)](https://cocoapods.org/pods/SignalStrengthIndicator)

## Preview

new with animation layer:<br>
<img src="https://github.com/kscheff/SignalStrengthIndicator/blob/master/animated_test.gif" alt="preview text" width="100" height="60">

<img src="https://raw.github.com/maximbilan/SignalStrengthIndicator/master/test.gif" alt="preview text" width="100" height="60">

## Description

It's just a UI component, shows an indicator of the connectivity, like a standard iOS cellular indicator. The control has simple customization: color, edges, spacing.

## Installation

<b>CocoaPods:</b>
<pre>
pod 'SignalStrengthIndicator'
</pre>

<b>Manual:</b>
<pre>
Copy <i>SignalStrengthIndicator.swift</i> to your project.
</pre>

## Usage

There is an example in the repository. The example shows how to add the control via <i>storyboard</i> (Interface Builder). Also, I can easily add via code.
  
<pre>
let indicator = SignalStrengthIndicator()

// Set up frame

view.addSubview(indicator)
</pre>

For controling the level of the indicator you need to use the following property:

<pre>
indicator.level = .good
</pre>

There is 6 cases of indication:

<pre>
enum Level: Int {
  case noSignal
  case veryLow
  case low
  case good
  case veryGood
  case excellent
}
</pre>

## Customization

Color:
<pre>
indicator.color = UIColor.gray
</pre>

Spacing between bars:
<pre>
indicator.spacing = 5
</pre>

Margins:
<pre>
indicator.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
</pre>

## License

<i>SignalStrengthIndicator</i> is available under the MIT license. See the LICENSE file for more info.
