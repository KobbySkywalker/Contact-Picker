//
//  RegisterResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 20/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

struct RegisterResponse: Codable {
    var email: String
    var firstName: String
    var lastName: String
    var msisdn: String
    var authProviderId: String
    var memberId: String
}



