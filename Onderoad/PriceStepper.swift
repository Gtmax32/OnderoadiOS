//
//  PriceStepper.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 23/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

@IBDesignable class PriceStepper: UIView {
	
	//MARK: Stepper Components
	let minusButton = UIButton()
	let priceLabel = UILabel()
	let plusButton = UIButton()
	
	@IBInspectable public var value: Int = 0 {
		didSet {
			priceLabel.text = String(value)
		}
	}
	
	@IBInspectable public var minValue = 0
	@IBInspectable public var maxValue = 50
	@IBInspectable public var incrementValue = 5
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	//MARK: Initialization Methods
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupStepper()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupStepper()
	}
	
	func setupStepper(){
		let bundle = Bundle(for: type(of: self))
		let minusImage = UIImage(named: "minusButton.png", in: bundle, compatibleWith: self.traitCollection)
		let minusFiledImage = UIImage(named: "minusButtonFilled.png", in: bundle, compatibleWith: self.traitCollection)
		let plusImage = UIImage(named: "plusButton.png", in: bundle, compatibleWith: self.traitCollection)
		let plusFilledImage = UIImage(named: "plusButtonFilled.png", in: bundle, compatibleWith: self.traitCollection)
		
		minusButton.setImage(minusImage, for: UIControlState.normal)
		minusButton.setImage(minusFiledImage, for: UIControlState.selected)
		minusButton.setImage(minusFiledImage, for: UIControlState.highlighted)
		
		minusButton.addTarget(self, action: #selector(PriceStepper.minusButtonTouchDown), for: .touchDown)
		
		addSubview(minusButton)
		
		priceLabel.text = "0"
		priceLabel.textAlignment = .center
		addSubview(priceLabel)
		
		plusButton.setImage(plusImage, for: UIControlState.normal)
		plusButton.setImage(plusFilledImage, for: UIControlState.selected)
		plusButton.setImage(plusFilledImage, for: UIControlState.highlighted)
		
		plusButton.addTarget(self, action: #selector(PriceStepper.plusButtonTouchDown), for: .touchDown)
		
		addSubview(plusButton)
	}
	
	override func layoutSubviews() {
		let labelWidthWeight: CGFloat = 0.5
		
		let buttonWidth = bounds.size.width * ((1 - labelWidthWeight) / 2)
		let labelWidth = bounds.size.width * labelWidthWeight
		
		minusButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: bounds.size.height)
		
		priceLabel.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: bounds.size.height)
		
		plusButton.frame = CGRect(x: labelWidth + buttonWidth, y: 0, width: buttonWidth, height: bounds.size.height)
	}
	
	//MARK: Button Action Methods
	
	func minusButtonTouchDown(sender: UIButton){
		if (value > minValue){
			value -= incrementValue
		}
		else{
			value = minValue
		}
	}
	
	func plusButtonTouchDown(sender: UIButton){
		if (value == maxValue){
			value = maxValue
		}
		else{
			value += incrementValue
		}
	}

}
