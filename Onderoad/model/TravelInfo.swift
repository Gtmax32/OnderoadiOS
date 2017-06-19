//
//  TravelInfo.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class TravelInfo {
	
	//MARK: Properties
	
	var addressDeparture: AddressInfo
	var dataTimeDeparture: Int
	var spotDestination: SpotInfo
	var priceTravel: Int
	var carTravel: CarInfo
	var isOutbound: Bool
	var noteTravel: String
	var ownerTravel: User
	var passengersTravel = [User]()
	
	init(address: AddressInfo, dataTime: Int, destination: SpotInfo, price: Int, car: CarInfo, outbounded: Bool, note: String, owner: User, passengersList: [User]) {
		self.addressDeparture = address
		self.dataTimeDeparture = dataTime
		self.spotDestination = destination
		self.priceTravel = price
		self.carTravel = car
		self.isOutbound = outbounded
		self.noteTravel = note
		self.ownerTravel = owner
		self.passengersTravel = passengersList
	}
}