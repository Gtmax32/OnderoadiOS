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
	var position: CLLocationCoordinate2D
	var ratingSpot: Int
	var descriptionSpot: String
	var tableSpot: SpotInfoTable
	
	override public var description: String {
		return "SpotInfo:\nRegion Spot: \(regionSpot)\nProvince Spot: \(provinceSpot)\nCity Spot: \(citySpot)\nName Spot: \(nameSpot)\nLocation Spot: \(position)\nRating Spot: \(ratingSpot)\nDescription Spot: \(descriptionSpot)\nTable Spot: \(tableSpot.description)\n"
	}
	
	init(region: String, province: String, city: String, name: String, position: CLLocationCoordinate2D, rating: Int, description: String, table: SpotInfoTable) {
		
		self.regionSpot = region
		self.provinceSpot = province
		self.citySpot = city
		self.nameSpot = name
		self.position = position
		self.ratingSpot = rating
		self.descriptionSpot = description
		self.tableSpot = table
	}
	
	init(dict: [String: Any]){
		self.regionSpot = dict["regionSpot"] as! String
		self.provinceSpot = dict["provinceSpot"] as! String
		self.citySpot = dict["citySpot"] as! String
		self.nameSpot = dict["title"] as! String
		
		let latitude = dict["latitudeSpot"] as! Double,
			longitude = dict["longitudeSpot"] as! Double
		
		self.position = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
		
		self.ratingSpot = dict["ratingSpot"] as! Int
		self.descriptionSpot = dict["snippet"] as! String
		self.tableSpot = SpotInfoTable.init(dict: dict["tableSpot"] as! [String : String])
	}
	
	func toServer() -> [String: Any]{
		let spotFormatted = ["regionSpot": self.regionSpot,
		                          "provinceSpot": self.provinceSpot,
		                          "citySpot": self.citySpot,
		                          "title": self.nameSpot,
		                          "latitudeSpot": self.position.latitude,
		                          "longitudeSpot": self.position.longitude,
		                          "ratingSpot" : self.ratingSpot,
		                          "snippet": self.descriptionSpot,
		                          "tableSpot": self.tableSpot.toServer()] as [String: Any]
		
		return spotFormatted
	}
	
}
