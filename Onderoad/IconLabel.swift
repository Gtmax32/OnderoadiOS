//
//  IconLabel.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 18/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

@IBDesignable class IconLabel: UIStackView {

	//MARK: Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupIconLabel()
	}
	
	required init(coder: NSCoder){
		super.init(coder: coder)
		
		setupIconLabel()
	}
	
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	//MARK: Private Methods
	
	private func setupIconLabel(){
		let label = UILabel()
		
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		
		/*/Create Attachment
		let imageAttachment =  NSTextAttachment()
		imageAttachment.image = UIImage(named:"euroIcon")
		
		//Set bound to reposition
		let imageOffsetY:CGFloat = 5.0;
		imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
		
		//Create string with attachment
		let attachmentString = NSAttributedString(attachment: imageAttachment)
		
		//Initialize mutable string
		let completeText = NSMutableAttributedString(string: "")
		
		//Add image to mutable string
		completeText.append(attachmentString)
		
		//Add your text to mutable string
		let  textAfterIcon = NSMutableAttributedString(string: "Price")
		completeText.append(textAfterIcon)
		label.textAlignment = .center;
		label.attributedText = completeText;*/
		
		addArrangedSubview(label)
	}

}
