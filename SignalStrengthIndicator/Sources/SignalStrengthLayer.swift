//
//  SignalStrengthLayer.swift
//  SignalStrengthIndicator
//  Created by Kai Scheffer on 27.07.22.
//  Copyright © 2022 maximbilan. All rights reserved.
//
//  based on:
//  GaugeLayer.swift
//  Created by Luca D'Incà on 18/10/15.
//  Copyright © 2015 BELKA S.R.L. All rights reserved.


import Foundation

import UIKit

class SignalStrengthLayer: CALayer {
  
  //Layer propery
  var startBars: Float!
  var myBackgroundColor: UIColor!
  var animationDuration: Float!
  var edgeInsets: UIEdgeInsets!
  var spacing: CGFloat!
  var roundness: CGFloat!
  var color: UIColor!
  var indicatorsCount: Int!
  var level: Level! {
    didSet {
      actionRun(.level)
      animatedLevel = CGFloat(level.rawValue)
      search = false
    }
  }
  var search: Bool! {
    didSet {
      actionRun(.ramp)
      actionRun(.wave)
      if search {
        //level = .noSignal
        animatedRamp = 0
        animatedWave = CGFloat(indicatorsCount + 6)
      } else {
        animatedRamp = 1
        actionStop(.wave)
        animatedWave = 0
      }
    }
  }

  //Animated property
  @NSManaged var animatedLevel: CGFloat
  @NSManaged var animatedRamp: Float
  @NSManaged var animatedWave: CGFloat
  
  enum AnimatedKeys : String {
    case level = "animatedLevel"
    case ramp = "animatedRamp"
    case wave = "animatedWave"
  }
  
  ///
  // Class methods
  ///
  
  //MARK: - Init methods
  override init(layer: Any) {
    super.init(layer: layer)
    if let previous = layer as? SignalStrengthLayer {
      animatedLevel = previous.animatedLevel
      animatedRamp = previous.animatedRamp
      myBackgroundColor = previous.myBackgroundColor
      color = previous.color
      edgeInsets = previous.edgeInsets
      spacing = previous.spacing
      roundness = previous.roundness
      indicatorsCount = previous.indicatorsCount
      startBars = previous.startBars
      level = previous.level
      search = previous.search
    }
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  //MARK: -
  
  func actionRun(_ key: AnimatedKeys) {
    action(forKey: key.rawValue)?.run(forKey: key.rawValue, object: self, arguments: nil)
  }
  
  func actionStop(_ key: AnimatedKeys) {
    removeAnimation(forKey: key.rawValue)
  }
  
  override func action(forKey event: String) -> CAAction? {
    //print("event: \(event)")
    if let key = AnimatedKeys(rawValue: event) {
      switch key {
      case .level:
        return createStrengthAnimation(key: event)
      case .ramp:
        return createSearchAnimation(key: event)
      case .wave:
        return createWaveAnimation(key: event)
      }
    }
    return super.action(forKey: event)
  }
  
  override class func needsDisplay(forKey key: String) -> Bool {
    if AnimatedKeys(rawValue: key) != nil {
      return true
    }
    return super.needsDisplay(forKey: key)
  }
  
  //MARK: - Setup methods
  private func setup() {
    self.contentsScale = UIScreen.main.scale
  }
  
  //MARK: - Animation methods
  private func createStrengthAnimation(key: String) -> CABasicAnimation {
    //print("create animation \(key)")
    self.removeAnimation(forKey: key)
    let animation = CABasicAnimation(keyPath: key)
    animation.fromValue = self.presentation()?.value(forKey: key)
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    animation.duration = CFTimeInterval(animationDuration)
    return animation
  }

  private func createSearchAnimation(key: String) -> CABasicAnimation {
    //print("create animation \(key)")
    self.removeAnimation(forKey: key)
    let animation = CABasicAnimation(keyPath: key)
    animation.fromValue = self.presentation()?.value(forKey: key) as? Float ?? 1
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    animation.duration = CFTimeInterval(animationDuration)
    return animation
  }
  
  private func createWaveAnimation(key: String) -> CABasicAnimation {
    //print ("create animation \(key)")
    removeAnimation(forKey: key)
    let animation = CABasicAnimation(keyPath: key)
    animation.fromValue = presentation()?.value(forKey: key) as? Float ?? 0
    animation.timeOffset = CFTimeInterval(animationDuration)
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.duration = CFTimeInterval(animationDuration) * CFTimeInterval(indicatorsCount) * 2
    animation.repeatCount = .infinity
    return animation
  }

  //MARK: - Draw methods
  
  
  override func draw(in ctx: CGContext) {
    print("draw search layer \(animatedLevel) \(animatedRamp) \(animatedWave)")
    ctx.saveGState()
    
    let rect = frame
    
    let barsCount = CGFloat(indicatorsCount)
    let barWidth = (rect.width - edgeInsets.right - edgeInsets.left - ((barsCount - 1) * spacing)) / barsCount
    let barHeight = (rect.height - edgeInsets.top - edgeInsets.bottom)
    
    let fullBars = Int(modf(animatedLevel).0)
    let partialBar = modf(animatedLevel).1
    
    let minHeight = barHeight - (((barHeight * 0.8) / barsCount) * barsCount - 1)
    let cornerRadius: CGFloat = min(barWidth, minHeight) * roundness/200
        
    func animateHeight(_ height: CGFloat, index: Int) -> CGFloat {
      if animatedWave == 0 || animatedRamp > 0 {
        return (height - minHeight) * CGFloat(self.animatedRamp) + minHeight
      } else {
        let i = CGFloat(index)
        let distance = animatedWave - i - 3
        let phase: CGFloat
        switch distance {
        case 0..<1:
          phase = distance/3
            break
        case 1..<2:
          phase = (distance - 1) / 3 + 1 / 3
          break
        case 2..<3:
          phase = (distance - 2) / 3 + 2 / 3
          break
        default:
          phase = 0
        }
        return minHeight +  minHeight * sin(phase * CGFloat.pi)
      }
    }

    for index in 0...indicatorsCount - 1 {
      let i = CGFloat(index)
      let width = barWidth
      let height = animateHeight(barHeight - (((barHeight * 0.8) / barsCount) * (barsCount - i)), index: index)
      let x: CGFloat = edgeInsets.left + i * barWidth + i * spacing
      let y: CGFloat = barHeight - height
      let barRect = CGRect(x: x, y: y, width: width, height: height)
      let clipPath: CGPath = UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius).cgPath
      
      ctx.resetClip()
      ctx.addPath(clipPath)
      ctx.setFillColor(color.cgColor)
      ctx.setStrokeColor(color.cgColor)
      
      switch index {
      case 0..<fullBars :
        ctx.fillPath()
        ctx.addPath(clipPath)
        ctx.strokePath()
        break
      case fullBars:
        ctx.strokePath()
        let fillRect = CGRect(
          x: barRect.minX,
          y: barRect.minY + barRect.height * (1 - partialBar),
          width: barRect.width,
          height: barRect.height * partialBar
        )
        ctx.clip(to: fillRect)
        ctx.addPath(clipPath)
        ctx.fillPath()
        break
      default:
        ctx.strokePath()
      }
    }
    
    ctx.restoreGState()
  }
  
  
}
