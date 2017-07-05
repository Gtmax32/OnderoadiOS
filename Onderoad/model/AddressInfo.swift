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
	
	init(dict: [String: Any]){
		self.streetInfo = dict["streetInfo"] as! String
		self.provinceInfo = dict["provinceInfo"] as! String
		self.longitudeInfo = dict["longitudeInfo"] as! Double
		self.latitudeInfo = dict["latitudeInfo"] as! Double
	}
	
	func toServer() -> [String: Any]{
		let addressFormatted = ["streetInfo" : self.streetInfo,
		                     "provinceInfo": self.provinceInfo,
		                     "longitudeInfo": self.longitudeInfo,
		                     "latitudeInfo": self.latitudeInfo] as [String : Any]
		
		return addressFormatted
	}
	
}
