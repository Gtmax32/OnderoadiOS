//
//  HomeTravelDetailTableCell.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 05/07/17.
//  Copyright © 2017 Giuseppe Fabio Trentadue. All rights reserved.
//

import UIKit

class HomeTravelDetailTableCell: UITableViewCell {

	@IBOutlet weak var travelDetailDateTimeLabel: UILabel!
	
	@IBOutlet weak var travelDetailPriceLabel: UILabel!
	
	@IBOutlet weak var travelDetailDepartureLabel: UILabel!
	
	@IBOutlet weak var travelDetailDestinationLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
