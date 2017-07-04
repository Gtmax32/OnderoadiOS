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
	var dataTimeDeparture: Int64
	var spotDestination: SpotInfo
	var priceTravel: Int
	var carTravel: CarInfo
	var isOutbound: Bool
	var noteTravel: String
	var ownerTravel: User
	var passengersTravel: [User]?
	
	public var description: String {
		return "TravelInfo:\n\(addressDeparture.description)\nDataTime in Millis: \(dataTimeDeparture)\n\(spotDestination.description)\nPrice Travel: \(priceTravel)\n\(carTravel.description)\nIsOutbound: \(isOutbound)\nNote Travel: \(noteTravel)\n\(ownerTravel.description)\nPassenger List: \(String(describing: passengersTravel ?? nil))"
	}
	
	//MARK: Initialization
	
	init(address: AddressInfo, dataTime: Int64, destination: SpotInfo, price: Int, car: CarInfo, outbounded: Bool, note: String, owner: User, passengersList: [User]?) {
		self.addressDeparture = address
		self.dataTimeDeparture = dataTime
		self.spotDestination = destination
		self.priceTravel = price
		self.carTravel = car
		self.isOutbound = outbounded
		self.noteTravel = note
		self.ownerTravel = owner
		self.passengersTravel = nil
	}
	
	public func fromMillisToString() -> String{
		let date = Date(timeIntervalSince1970: (Double(self.dataTimeDeparture) / 1000.0))
		
		let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		
		let correctDate: Date = gregorian.date(byAdding: .hour, value: -2, to: date)!
		
		print("TimeMillis: \(self.dataTimeDeparture) Date from millis: \(date) Date with calendar: \(correctDate)")
		
		let formatter = DateFormatter()
		
		formatter.dateStyle = DateFormatter.Style.long
		
		formatter.timeStyle = DateFormatter.Style.short
		
		formatter.timeZone = TimeZone.current
		
		formatter.locale = Locale.current
		
		let stringDate = formatter.string(from: correctDate)
		
		print(stringDate)
		
		return stringDate
	}
	
	func toServer() -> [String: Any]{
		let travelFormatted = ["addressDeparture": self.addressDeparture.toServer(),
		                     "dataTimeDeparture": self.dataTimeDeparture,
		                     "spotDestination": self.spotDestination.toServer(),
		                     "priceTravel": self.priceTravel,
		                     "carTravel": self.carTravel.toServer(),
		                     "isOutbound" : self.isOutbound,
		                     "noteTravel": self.noteTravel,
		                     "ownerTravel": self.ownerTravel.toServer()] as [String: Any]
		
		return travelFormatted
	}
}
