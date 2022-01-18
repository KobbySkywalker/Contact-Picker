//
//  UserObject.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 07/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class UserObject: Codable {
    var authProviderId: String = ""
    var email: String = ""
    var memberId: String = ""
    var msisdn: String = ""
    var name: String = ""
    
    required init(authProviderId_: String, email_: String, memberId_: String, msisdn_: String, name_: String) {
        
        self.authProviderId = authProviderId_
        self.email = email_
        self.memberId = memberId_
        self.msisdn = msisdn_
        self.name = name_
    }
}

