//
//  SpotInfoTable.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class SpotInfoTable{
	
	//MARK: Properties
	
	var waveSpot: String
	var windSpot: String
	var swellSpot: String
	var seabedSpot: String
	
	public var description: String {
		return "SpotInfoTable:\nWave Spot: \(waveSpot)\nWind Spot: \(windSpot)\nSwell Spot: \(swellSpot)\nSeabed Spot: \(seabedSpot)\n"
	}
	
	//MARK: Initialization
	
	init(wave: String, wind: String, swell: String, seabed: String) {
		self.waveSpot = wave
		self.windSpot = wind
		self.swellSpot = swell
		self.seabedSpot = seabed
	}
	
	func toServer() -> [String: Any]{
		let spotTableFormatted = ["waveSpot": self.waveSpot,
		                          "windSpot": self.windSpot,
		                          "swellSpot": self.swellSpot,
		                          "seabedSpot": self.seabedSpot] as [String: Any]
	
		return spotTableFormatted
	}
}
