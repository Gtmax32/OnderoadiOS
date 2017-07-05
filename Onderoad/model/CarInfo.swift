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
	
	var passengersNumber: Int
	var surfboardNumber: Int
	var surfboardType: String
	
	public var description: String {
		return "CarInfo:\nPassenger Number: \(passengersNumber)\nSurfboard Number: \(surfboardNumber)\nSupport type: \(surfboardType)\n"
	}
	
	//MARK: Initialization
	
	init(passengers: Int, surfboards: Int, type: String) {
		self.passengersNumber = passengers
		self.surfboardNumber = surfboards
		self.surfboardType = type
	}
	
	init(dict: [String: Any]){
		self.passengersNumber = dict["passengersNumber"] as! Int
		self.surfboardNumber = dict["surfboardNumber"] as! Int
		self.surfboardType = dict["surfboardType"] as! String
	}
	
	func toServer() -> [String: Any]{
		let carFormatted = ["passengersNumber":self.passengersNumber,
		                    "surfboardNumber":self.surfboardNumber,
		                    "surfboardType":self.surfboardType] as [String : Any]
		
		return carFormatted
	}
	
}
