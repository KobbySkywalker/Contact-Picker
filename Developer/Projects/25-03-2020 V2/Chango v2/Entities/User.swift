//
//  Device.swift
//  RideAlong
//
//  Created by Hosny Ben Savage on 19/01/2019.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

struct User: Codable {
	var name: String = ""
	var email: String = ""
	var phone: String = ""
	var token: String = ""
	
	private enum CodingKeys: String, CodingKey {
		case name
		case email
		case phone = "phone_number"
		case token
	}
}

//*************************************** USER RESPONSE **************************************//


struct UserResponse: Codable {
	let status_code: String
	let message: String
	let user: User
	
	private enum CodingKeys: String, CodingKey {
		case status_code
		case message
		case user
	}
}
