//
//  ViewController.swift
//  SignalStrengthIndicator
//
//  Created by Maxim on 1/22/18.
//  Copyright © 2018 maximbilan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: - Outlets
	
	@IBOutlet weak var signalStrength: SignalStrengthIndicator!
	
	// MARK: - Level
	
	fileprivate var level: Int!

	// MARK: - Controller Loading
	
	override func viewDidLoad() {
		super.viewDidLoad()
    level = signalStrength.level.rawValue
		signalStrength.barColor = UIColor.gray
	}
  
  override func viewDidAppear(_ animated: Bool) {
    //signalStrength.level = .excellent
  }
	
	// MARK: - Actions
	
	@IBAction func upPressed(_ sender: UIButton) {
		let value = self.level + 1
		if let level = Level(rawValue: value) {
			signalStrength.level = level
			 self.level = value
    } else {
      signalStrength.search = true
    }
	}
	
	@IBAction func downPressed(_ sender: UIButton) {
		let value = self.level - 1
		if let level = Level(rawValue: value) {
			signalStrength.level = level
			self.level = value
    } else {
      signalStrength.search = true
    }
	}
	
}
