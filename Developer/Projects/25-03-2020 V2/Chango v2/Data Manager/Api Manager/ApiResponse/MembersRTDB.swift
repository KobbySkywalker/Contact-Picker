//
//  MembersRTDB.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class MembersRTDB: Codable {
    var email: String
    var memberId: String
    var msisdn: String
    var name: String
    
    required init(email_: String, memberId_: String, msisdn_: String, name_: String) {
        
        self.email = email_
        self.memberId = memberId_
        self.msisdn = msisdn_
        self.name = name_
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        memberId = try container.decode(String.self, forKey: .memberId)
        msisdn = try container.decode(String.self, forKey: .msisdn)
        name = try container.decode(String.self, forKey: .name)
        
    }
    
}
