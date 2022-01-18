//
//  GroupCreationResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

public struct GroupCreationResponse: Codable {
    var countryId: CountryId?
    var created: String
    var groupIconPath: String?
    var groupId: String
    var groupName: String
    var groupType: String
    var loanFlag: Int
    var modified: String?
    var status: String
    var tnc: String?
    var description: String?
    var defaultCampaignId: String
    
    
    private enum CodingKeys: String, CodingKey {
        case countryId
        case created
        case groupIconPath
        case groupId
        case groupName
        case groupType
        case loanFlag
        case modified
        case status
        case tnc
        case description
        case defaultCampaignId
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
//        countryId = try container.decode(CountryId.self, forKey: .countryId)
        if let ctryd = try? container.decode(CountryId.self, forKey: .countryId) {
            countryId = ctryd
        }
        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(String.self, forKey: .groupId)
        groupName = try container.decode(String.self, forKey: .groupName)
        groupType = try container.decode(String.self, forKey: .groupType)
        loanFlag = try container.decode(Int.self, forKey: .loanFlag)
        status = try container.decode(String.self, forKey: .status)
        
        if let gip = try? container.decode(String.self, forKey: .groupIconPath) {
            groupIconPath = gip
        }
        
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
        if let terms = try? container.decode(String.self, forKey: .tnc) {
            tnc = terms
        }
        
        if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        }
        
        defaultCampaignId = try container.decode(String.self, forKey: .defaultCampaignId)
        
    }

}

