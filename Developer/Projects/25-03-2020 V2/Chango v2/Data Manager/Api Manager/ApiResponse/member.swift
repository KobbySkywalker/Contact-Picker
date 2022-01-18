//
//  member.swift
//  Chango v2
//
//  Created by Hosny Savage on 15/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct Member: Codable {
    var authProviderId: String
    var created: String
    var email: String
    var firstName: String
    var language: String?
    var lastName: String
    var memberIconPath: String?
    var memberId: String
    var modified: String
    var msisdn: String
    var networkCode: String
//    var registrationToken: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        authProviderId = try container.decode(String.self, forKey: .authProviderId)
        created = try container.decode(String.self, forKey: .created)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        memberId = try container.decode(String.self, forKey: .memberId)
        modified = try container.decode(String.self, forKey: .modified)
        msisdn = try container.decode(String.self, forKey: .msisdn)
        networkCode = try container.decode(String.self, forKey: .networkCode)
//        registrationToken = try container.decode(String.self, forKey: .registrationToken)
        
        if let lng = try? container.decode(String.self, forKey: .language) {
            language = lng
        }
        
        if let mip = try? container.decode(String.self, forKey: .memberIconPath) {
            memberIconPath = mip
        }

    }
}


struct GroupIdInfo: Codable {
    var groupIconPath: String?
    var groupId: String
    var groupName: String
    var description: String
    var tnc: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        groupId = try container.decode(String.self, forKey: .groupId)
        groupName = try container.decode(String.self, forKey: .groupName)
        description = try container.decode(String.self, forKey: .description)
        tnc = try container.decode(String.self, forKey: .tnc)

        if let gip = try? container.decode(String.self, forKey: .groupIconPath) {
            groupIconPath = gip
        }

    }
}
