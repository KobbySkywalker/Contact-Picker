//
//  MemberIdResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation


struct MemberId: Codable {
    var created: String
    var email: String
    var firstName: String
    var language: String?
    var lastName: String
    var memberIconPath: String?
    var memberId: String?
    var modified: String?
    var msisdn: String
    var networkCode: String
    var registrationToken: String
    
    
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        created = try container.decode(String.self, forKey: .created)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
//        memberId = try container.decode(String.self, forKey: .memberId)
//        language = try container.decode(String.self, forKey: .language)
        lastName = try container.decode(String.self, forKey: .lastName)
        msisdn = try container.decode(String.self, forKey: .msisdn)
        networkCode = try container.decode(String.self, forKey: .networkCode)
        registrationToken = try container.decode(String.self, forKey: .registrationToken)

        
        if let lng = try? container.decode(String.self, forKey: .language) {
            language = lng
        }
        
        if let mmbrd = try? container.decode(String.self, forKey: .memberId) {
            memberId = mmbrd
        }
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
        
        if let mip = try? container.decode(String.self, forKey: .memberIconPath) {
            memberIconPath = mip
        }
    }
}

