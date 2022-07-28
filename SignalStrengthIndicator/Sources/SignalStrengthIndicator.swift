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


public class SignalStrengthIndicator: UIView {
  
  // MARK: - Class property
  
  private var signalStrengthLayer: SignalStrengthLayer!
	

  private var _level = Level.noSignal
	
	public var level: Level {
		get {
			return _level
		}
		set(newValue) {
      search = false
			_level = newValue
      signalStrengthLayer.level = newValue
			setNeedsDisplay()
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
	
	public var edgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
	public var spacing: CGFloat = 3
  public var barColor = UIColor.systemGray
  public var animationDuration: Float = 0.2
	
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
    signalStrengthLayer.color = barColor
    signalStrengthLayer.animationDuration = animationDuration
    signalStrengthLayer.edgeInsets = edgeInsets
    signalStrengthLayer.spacing = spacing
    signalStrengthLayer.indicatorsCount = indicatorsCount
    signalStrengthLayer.level = level
    signalStrengthLayer.search = search
    signalStrengthLayer.frame = self.bounds
  }
  
	// MARK: - Drawing
	
  override public func draw(_ rect: CGRect) {
    print("draw indicator")
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
