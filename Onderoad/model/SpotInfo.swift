//
//  SpotInfo.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class SpotInfo{

	//MARK: Properties
	var regionSpot: String
	var provinceSpot: String
	var citySpot: String
	var nameSpot: String
	var latitudeSpot: Double
	var longitudeSpot: Double
	var ratingSpot: Int
	var descritionSpot: String
	var tableSpot: SpotInfoTable
	
	public var description: String {
		return "SpotInfo:\nRegion Spot: \(regionSpot)\nProvince Spot: \(provinceSpot)\nCity Spot: \(citySpot)\nName Spot: \(nameSpot)\nLatitude Spot: \(latitudeSpot)\nLongitude Spot: \(longitudeSpot)\nRating Spot: \(ratingSpot)\nDescription Spot: \(descritionSpot)\nTable Spot: \(tableSpot.description)\n"
	}
	
	init(region: String, province: String, city: String, name: String, latitude: Double, longitude: Double, rating: Int, description: String, table: SpotInfoTable) {
		
		self.regionSpot = region
		self.provinceSpot = province
		self.citySpot = city
		self.nameSpot = name
		self.latitudeSpot = latitude
		self.longitudeSpot = longitude
		self.ratingSpot = rating
		self.descritionSpot = description
		self.tableSpot = table
	}
}
