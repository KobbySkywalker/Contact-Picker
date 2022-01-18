//
//  JoinGroupResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

public struct JoinGroupResponse: Codable {
    var groupId: String?
    var groupName: String
    var groupType: String?
    var groupIconPath: String?
    var countryId: CountryId?
    var tnc: String?
    var description: String?
    var status: String?
    var created: String?  
    var modified: String?
    
//    private enum CodingKeys: String, CodingKey {
//        case created
//        case groupId
//        case groupName
//        case groupType
//        case groupIconPath
//        case countryId
//        case modified
//        case status
//        case tnc
//        case description
//    }

    
   public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        groupId = try container.decode(String.self, forKey: .groupId)
        groupName = try container.decode(String.self, forKey: .groupName)
//        description = try container.decode(String.self, forKey: .description)
//        status = try container.decode(String.self, forKey: .status)
//        countryId = try container.decode(CountryId.self, forKey: .countryId)
//        created = try container.decode(String.self, forKey: .created)

    
//        if let grp = try? container.decode(String.self, forKey: .groupId) {
//        groupId = grp
//        }
    
//        if let gn = try? container.decode(String.self, forKey: .groupName) {
//        groupName = gn
//        }
    
        if let gt = try? container.decode(String.self, forKey: .groupType) {
        groupType = gt
        }
    
        if let stat = try? container.decode(String.self, forKey: .status) {
        status = stat
        }
    
        if let country = try? container.decode(CountryId.self, forKey: .countryId) {
        countryId = country
        }
    
        if let cre = try? container.decode(String.self, forKey: .created) {
        created = cre
        }
    
    
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
        if let gip = try? container.decode(String.self, forKey: .groupIconPath) {
            groupIconPath = gip
        }
        
        if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        }
    
        if let terms = try? container.decode(String.self, forKey: .tnc) {
            tnc = terms
        }
    
        
    }
    
}

public struct JoinPrivateGroupResponse: Codable {
    var groups: Groups?
    var responseCode: String?
    var responseMessage: String?
}

public struct Groups: Codable {
    var approve: String?
    var countryId: CountryId?
    var created: String?
    var creatorId: String?
    var creatorName: String?
    var defaultCampaignId: String?
    var description: String?
    var groupIconPath: String?
    var groupId: String?
    var groupName: String?
    var groupType: String?
    var loanFlag: Int
    var modified: String?
    var status: String?
    var tnc: String?
}

