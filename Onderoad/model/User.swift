//
//  User.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class User {
	
	//MARK: Properties
	var idUser: String
	var nameUser: String
	var emailUser: String
	var notificationIdUser: String
	
	init(id: String, name: String, email: String, notificationId: String) {
		self.idUser = id
		self.nameUser = name
		self.emailUser = email
		self.notificationIdUser = notificationId
	}
}
