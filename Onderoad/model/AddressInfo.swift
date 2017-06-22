//
//  AddressInfo.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 18/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class AddressInfo {
	
	//MARK: Properties
	var streetInfo: String
	var provinceInfo: String
	var longitudeInfo: Double
	var latitudeInfo: Double
	
	public var description: String {
		return "AddressInfo:\nStreetInfo: \(streetInfo)\nProvinceInfo: \(provinceInfo)\nLongitudeInfo: \(longitudeInfo)\nLatitudeInfo: \(latitudeInfo)\n"
	}
	
	//MARK: Initialization
	
	init(street: String, province: String, longitude: Double, latitude: Double){
		self.streetInfo = street
		self.provinceInfo = province
		self.longitudeInfo = longitude
		self.latitudeInfo = latitude
	}
	
}
