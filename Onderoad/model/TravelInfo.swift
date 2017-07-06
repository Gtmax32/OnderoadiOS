//
//  TravelInfo.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TravelInfo {
	
	//MARK: Properties
	
	var addressDeparture: AddressInfo
	var dateTimeDeparture: Int64
	var spotDestination: SpotInfo
	var priceTravel: Int
	var carTravel: CarInfo
	var isOutbound: Bool
	var noteTravel: String
	var ownerTravel: User
	var passengersTravel = [User]()
	
	public var description: String {
		return "TravelInfo:\n\(addressDeparture.description)\nDataTime in Millis: \(dateTimeDeparture)\n\(spotDestination.description)\nPrice Travel: \(priceTravel)\n\(carTravel.description)\nIsOutbound: \(isOutbound)\nNote Travel: \(noteTravel)\n\(ownerTravel.description)\nPassenger List: \(passengersTravel.description)"
	}
	
	//MARK: Initialization
	
	init(address: AddressInfo, dataTime: Int64, destination: SpotInfo, price: Int, car: CarInfo, outbounded: Bool, note: String, owner: User, passengersList: [User]) {
		self.addressDeparture = address
		self.dateTimeDeparture = dataTime
		self.spotDestination = destination
		self.priceTravel = price
		self.carTravel = car
		self.isOutbound = outbounded
		self.noteTravel = note
		self.ownerTravel = owner
		self.passengersTravel = passengersList
	}
	
	init?(travelDict: [String: Any]){		
		//print("In TravelInfo: \(travelDict)")
		
		guard let address = travelDict["addressDeparture"] as? [String: Any] else{
			print("Error to reading address from travelDict")
			return nil
		}
		
		self.addressDeparture = AddressInfo.init(dict: address)
		
		guard let dateTime = travelDict["dateTimeDeparture"] as? Int64 else{
			print("Error to reading dateTime from travelDict")
			return nil
		}
		self.dateTimeDeparture = dateTime
		
		guard let destination = travelDict["spotDestination"] as? [String: Any] else{
			print("Error to reading destination from travelDict")
			return nil
		}
		
		self.spotDestination = SpotInfo.init(dict: destination)
		
		guard let price = travelDict["priceTravel"] as? Int else{
			print("Error to reading price from travelDict")
			return nil
		}
		
		self.priceTravel = price
		
		guard let car = travelDict["carTravel"] as? [String: Any] else {
			print("Error to reading car from travelDict")
			return nil
		}
		self.carTravel = CarInfo.init(dict: car)
		
		guard let outbound = travelDict["outbound"] as? Bool else{
			print("Error to reading outbound from travelDict")
			return nil
		}
		
		self.isOutbound = outbound
		
		guard let note = travelDict["noteTravel"] as? String else{
			print("Error to reading note from travelDict")
			return nil
		}
		
		self.noteTravel = note
		
		guard let owner = travelDict["ownerTravel"] as? [String: String] else {
			print("Error to reading owner from travelDict")
			return nil
		}
		self.ownerTravel = User.init(dict: owner)
		
		if let list = travelDict["passengersTravel"]{
			print("There are passengers!")
			
			for elem in list as! NSArray{
				//print(elem)
				let user = User.init(dict: elem as! [String: String])
				
				self.passengersTravel.append(user)
			}
		} else{
			print("There aren't passenger...")
		}
	}
	
	public func fromMillisToString() -> String{
		let date = Date(timeIntervalSince1970: (Double(self.dateTimeDeparture) / 1000.0))
		
		let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		
		let correctDate: Date = gregorian.date(byAdding: .hour, value: -2, to: date)!
		
		//print("TimeMillis: \(self.dateTimeDeparture) Date from millis: \(date) Date with calendar: \(correctDate)")
		
		let formatter = DateFormatter()
		
		formatter.dateStyle = DateFormatter.Style.long
		
		formatter.timeStyle = DateFormatter.Style.short
		
		formatter.timeZone = TimeZone.current
		
		formatter.locale = Locale.current
		
		let stringDate = formatter.string(from: correctDate)
		
		//print(stringDate)
		
		return stringDate
	}
	
	func listToTravel() -> [String:Any] {
		var passengersDict = [String:Any]()
		if self.passengersTravel.count > 0 {
			var index = 0
			for passenger in passengersTravel {
				passengersDict.updateValue(passenger.toServer(), forKey: String(index))
				index += 1
			}
		}
		else {
			passengersDict = [:]
		}
		
		return passengersDict
	}
	
	func toServer() -> [String: Any]{
		let travelFormatted = ["addressDeparture": self.addressDeparture.toServer(),
		                     "dateTimeDeparture": self.dateTimeDeparture,
		                     "spotDestination": self.spotDestination.toServer(),
		                     "priceTravel": self.priceTravel,
		                     "carTravel": self.carTravel.toServer(),
		                     "outbound" : self.isOutbound,
		                     "noteTravel": self.noteTravel,
		                     "ownerTravel": self.ownerTravel.toServer(),
		                     "passengersTravel": listToTravel()] as [String: Any]
		
		return travelFormatted
	}
	
	
}
