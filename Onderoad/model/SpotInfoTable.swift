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
	
	//MARK: Initialization
	
	init(wave: String, wind: String, swell: String, seabed: String) {
		self.waveSpot = wave
		self.windSpot = wind
		self.swellSpot = swell
		self.seabedSpot = seabed
	}
}
