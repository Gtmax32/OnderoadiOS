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
	
	public var description: String {
		return "CarInfo:\nPassenger Number: \(passengerNumber)\nSurfboard Number: \(surfboardNumber)\nSupport type: \(surfboardType)\n"
	}
	
	//MARK: Initialization
	
	init(passengers: Int, surfboards: Int, type: String) {
		self.passengerNumber = passengers
		self.surfboardNumber = surfboards
		self.surfboardType = type
	}
	
	func toServer() -> [String: Any]{
		let carFormatted = ["passengerNumber":self.passengerNumber,
		                    "surfboardNumber":self.surfboardNumber,
		                    "surfboardType":self.surfboardType] as [String : Any]
		
		return carFormatted
	}
	
}
