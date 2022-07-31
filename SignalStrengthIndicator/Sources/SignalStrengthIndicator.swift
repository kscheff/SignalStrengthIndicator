//
//  SignalStrengthIndicator.swift
//  SignalStrengthIndicator
//
//  Created by Maxim on 1/22/18.
//  Copyright © 2018 maximbilan. All rights reserved.
//

import UIKit

// MARK: - Level

public enum Level: Int, CaseIterable {
  case noSignal
  case veryLow
  case low
  case good
  case veryGood
  case excellent
}

@IBDesignable
public class SignalStrengthIndicator: UIView {
  
  // MARK: - Class property
  
  private var signalStrengthLayer: SignalStrengthLayer!
	
  
//  private lazy var _level = {Level(rawValue: indicator) ?? .excellent}()
  @IBInspectable
  private var _level: Int = 0
  
  private var firstRun = true
  
 // @IBInspectable
  public var level: Level {
		get {
      return Level(rawValue: _level) ?? .noSignal
		}
		set {
      if (newValue.rawValue != _level) || firstRun {
        firstRun = false
        search = newValue == .noSignal && waveNoSignal ? true : false
        _level = newValue.rawValue
        signalStrengthLayer.level = newValue
        setNeedsDisplay()
      }
		}
	}
  
  private var _search = false
  
  public var search: Bool {
    get {
      return _search
    }
    set {
      _search = newValue
      signalStrengthLayer.search = newValue
      setNeedsDisplay()
    }
  }
	
	// MARK: - Customization
	
  /// top inset space
  @IBInspectable
  var topInset: CGFloat = 3 {
    didSet {
      signalStrengthLayer.edgeInsets.top = topInset
    }
  }
  
  /// left inset space
  @IBInspectable
  var leftInset: CGFloat = 3 {
    didSet {
      signalStrengthLayer.edgeInsets.left = leftInset
    }
  }

  /// bottom inset space
  @IBInspectable
  var bottomInset: CGFloat = 3 {
    didSet {
      signalStrengthLayer.edgeInsets.bottom = bottomInset
    }
  }

  /// right inset space
  @IBInspectable
  var rightInset: CGFloat = 3 {
    didSet {
      signalStrengthLayer.edgeInsets.right = rightInset
    }
  }

//  public var edgeInsets: UIEdgeInsets!// = UIEdgeInsets(top: topInset, left: 3, bottom: 3, right: 3)

  /// spacing between the indicator bars
  @IBInspectable
  public var spacing: CGFloat = 3 {
    didSet {
      signalStrengthLayer.spacing = spacing
    }
  }
  
  /// roundess of the indicators bars range 0..100 %
  @IBInspectable
  public var roundness: CGFloat = 50 {
    didSet {
      signalStrengthLayer.roundness = roundness
    }
  }
  
  /// start  wave animation when no signal is set
  @IBInspectable
  public var waveNoSignal: Bool = true
  
  /// color of the indicator bar
  @IBInspectable
  public var barColor: UIColor = UIColor.systemGray {
    didSet {
      signalStrengthLayer.barColor = barColor
    }
  }
  
  //@IBInspectable
  public var animationDuration: Float = 0.2 {
    didSet {
      signalStrengthLayer.animationDuration
    }
  }
	
	// MARK: - Constants
	
  private let indicatorsCount: Int = Level.allCases.count - 1
  
  //MARK: - Init methods
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }

  required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    
    setup()
  }
	
  
  private func setupLayerProperties() {
    signalStrengthLayer.startBars = 0
    signalStrengthLayer.myBackgroundColor = backgroundColor
    signalStrengthLayer.barColor = barColor
    signalStrengthLayer.animationDuration = animationDuration
    signalStrengthLayer.edgeInsets =  UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    signalStrengthLayer.spacing = spacing
    signalStrengthLayer.roundness = roundness
    signalStrengthLayer.indicatorsCount = indicatorsCount
    //signalStrengthLayer.level = level
    //signalStrengthLayer.search = search
    level = level
    search = search
    signalStrengthLayer.frame = self.bounds
  }
  
	// MARK: - Drawing
	
  override public func draw(_ rect: CGRect) {
    //print("draw indicator")
    super.draw(rect)
    setupLayerProperties()
  }
  
//	override public func draw(_ rect: CGRect) {
//		guard let ctx = UIGraphicsGetCurrentContext() else {
//			return
//		}
//
//		ctx.saveGState()
//
//		let levelValue = level.rawValue
//
//		let barsCount = CGFloat(indicatorsCount)
//		let barWidth = (rect.width - edgeInsets.right - edgeInsets.left - ((barsCount - 1) * spacing)) / barsCount
//		let barHeight = rect.height - edgeInsets.top - edgeInsets.bottom
//
//		for index in 0...indicatorsCount - 1 {
//			let i = CGFloat(index)
//			let width = barWidth
//			let height = barHeight - (((barHeight * 0.8) / barsCount) * (barsCount - i))
//			let x: CGFloat = edgeInsets.left + i * barWidth + i * spacing
//			let y: CGFloat = barHeight - height
//			let cornerRadius: CGFloat = barWidth * 0.25
//			let barRect = CGRect(x: x, y: y, width: width, height: height)
//			let clipPath: CGPath = UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius).cgPath
//
//			ctx.addPath(clipPath)
//			ctx.setFillColor(color.cgColor)
//			ctx.setStrokeColor(color.cgColor)
//
//			if index + 1 > levelValue {
//				ctx.strokePath()
//			}
//			else {
//				ctx.fillPath()
//			}
//		}
//
//		ctx.restoreGState()
//	}
  
  //MARK: - Setup method
  private func setup() {
    createIndicatorView()
    setupAccessibility()
  }
  
  private func setupAccessibility() {
    self.isAccessibilityElement = true
  }
  
  private func createIndicatorView() {
    signalStrengthLayer = SignalStrengthLayer(layer: layer)
    setupLayerProperties()
    layer.addSublayer(signalStrengthLayer)
    self.backgroundColor = UIColor.clear
  }
	
}
