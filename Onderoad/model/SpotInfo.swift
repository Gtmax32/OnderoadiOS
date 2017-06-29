//
//  SpotInfo.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import GoogleMaps

class SpotInfo: NSObject, GMUClusterItem{
	


	//MARK: Properties
	var regionSpot: String
	var provinceSpot: String
	var citySpot: String
	var nameSpot: String
	//var latitudeSpot: Double
	//var longitudeSpot: Double
	var position: CLLocationCoordinate2D
	var ratingSpot: Int
	var descritionSpot: String
	var tableSpot: SpotInfoTable
	
	override public var description: String {
		return "SpotInfo:\nRegion Spot: \(regionSpot)\nProvince Spot: \(provinceSpot)\nCity Spot: \(citySpot)\nName Spot: \(nameSpot)\nLocation Spot: \(position)\nRating Spot: \(ratingSpot)\nDescription Spot: \(descritionSpot)\nTable Spot: \(tableSpot.description)\n"
	}
	
	init(region: String, province: String, city: String, name: String, position: CLLocationCoordinate2D, rating: Int, description: String, table: SpotInfoTable) {
		
		self.regionSpot = region
		self.provinceSpot = province
		self.citySpot = city
		self.nameSpot = name
		self.position = position
		self.ratingSpot = rating
		self.descritionSpot = description
		self.tableSpot = table
	}
}
