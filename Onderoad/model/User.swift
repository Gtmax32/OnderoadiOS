//
//  User.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class User: NSObject {
	
	//MARK: Properties
	var idUser: String
	var nameUser: String
	var emailUser: String
	var notificationIdUser: String
	
	override public var description: String {
		return "User:\nId User: \(idUser)\nName User: \(nameUser)\nEmail User: \(emailUser)\nNotification Id User: \(notificationIdUser)\n"
	}
	
	init(id: String, name: String, email: String, notificationId: String) {
		self.idUser = id
		self.nameUser = name
		self.emailUser = email
		self.notificationIdUser = notificationId
	}
	
	init(dict: [String: String]){
		self.idUser = dict["idUser"]!
		self.nameUser = dict["nameUser"]!
		self.emailUser = dict["emailUser"]!
		self.notificationIdUser = dict["notificationIdUser"]!
	}
	
	func toServer() -> [String: Any]{
		let userFormatted = ["idUser" : self.idUser,
		                     "nameUser": self.nameUser,
		                     "emailUser": self.emailUser,
		                     "notificationIdUser": self.notificationIdUser] as [String: Any]
		
		return userFormatted
	}
}
