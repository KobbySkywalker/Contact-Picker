//
//  memberGroupIdResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 25/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation


class MemberGroupIdResponse: Codable {
    var countryId: CountryId
    var created: String
    var defaultCampaignId: String
    var description: String?
    var groupIconPath: String?
    var groupId: String
    var groupName: String
    var groupType: String
    var modified: String?
    var status: String
    var tnc: String?
    
    
    required init(countryId_: CountryId, created_: String, defaultCampaignId_: String, description_: String, groupIconPath_: String, groupId_: String, groupName_: String, groupType_: String, modified_: String, status_: String, tnc_: String) {
        
        self.countryId = countryId_
        self.created = created_
        self.defaultCampaignId = defaultCampaignId_
        self.description = description_
        self.groupIconPath = groupIconPath_
        self.groupId = groupId_
        self.groupName = groupName_
        self.groupType = groupType_
        self.modified = modified_
        self.status = status_
        self.tnc = created_
    }
    
   required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        created = try container.decode(String.self, forKey: .created)
        defaultCampaignId = try container.decode(String.self, forKey: .defaultCampaignId)
        groupId = try container.decode(String.self, forKey: .groupId)
        countryId = try container.decode(CountryId.self, forKey: .countryId)
        groupName = try container.decode(String.self, forKey: .groupName)
        groupType = try container.decode(String.self, forKey: .groupType)
        status = try container.decode(String.self, forKey: .status)
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
        if let groupIcon = try? container.decode(String.self, forKey: .groupIconPath) {
            groupIconPath = groupIcon
        }
        
        if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        }
        
        if let terms = try? container.decode(String.self, forKey: .tnc) {
            tnc = terms
        }

    }
}
