//
//  UpdateMemberResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 30/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct UpdateMemberResponse: Codable {
    var created: String
    var authProviderId: String
    var email: String
    var firstName: String
    var language: String?
    var lastName: String
    var memberIconPath: String
    var memberId: String
    var modified: String?
    var msisdn: String
    var networkCode: String
    var countryId: String?
//    var registrationToken: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        authProviderId = try container.decode(String.self, forKey: .authProviderId)
        created = try container.decode(String.self, forKey: .created)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        memberIconPath = try container.decode(String.self, forKey: .memberIconPath)
        memberId = try container.decode(String.self, forKey: .memberId)
        msisdn = try container.decode(String.self, forKey: .msisdn)
        networkCode = try container.decode(String.self, forKey: .networkCode)
        if let ctryId = try? container.decode(String.self, forKey: .countryId) {
            modified = ctryId
        }//        registrationToken = try container.decode(String.self, forKey: .registrationToken)
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        if let lan = try? container.decode(String.self, forKey: .language) {
            language = lan
        }
    }
}
