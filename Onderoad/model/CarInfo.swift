//
//  CarInfo.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class CarInfo{
	
	//MARK: Properties
	
	var passengerNumber: Int
	var surfboardNumber: Int
	var surfboardType: String
	
	//MARK: Initialization
	
	init(passengers: Int, surfboards: Int, type: String) {
		self.passengerNumber = passengers
		self.surfboardNumber = surfboards
		self.surfboardType = type
	}
	
}
