//
//  GroupInviteResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 06/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class GroupInviteResponse: Codable {
    var countryId: CountryId
    var groupId: String = ""
    var groupName: String = ""
    var groupType: String = ""
    var groupIconPath: String? = ""
    var tnc: String? = ""
    var status: String = ""
    var created: String = ""
    var modified: String? = ""
    var description: String? = ""
    var messageBody: String? = ""
    var timestamp: String? = ""
    
    required init(countryId_: CountryId, groupId_: String, groupName_: String, groupType_: String, groupIconPath_: String, tnc_: String, status_: String, created_: String, modified_: String, description_: String, messageBody_: String, timestamp_: String) {
        
        self.countryId = countryId_
        self.groupId = groupId_
        self.groupName = groupName_
        self.groupType = groupType_
        self.groupIconPath = groupIconPath_
        self.tnc = tnc_
        self.status = status_
        self.created = created_
        self.modified = modified_
        self.description = description_
        self.messageBody = messageBody_
        self.timestamp = timestamp_
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(String.self, forKey: .groupId)
        groupName = try container.decode(String.self, forKey: .groupName)
        groupType = try container.decode(String.self, forKey: .groupType)
        status = try container.decode(String.self, forKey: .status)
        countryId = try container.decode(CountryId.self, forKey: .countryId)
        messageBody = try container.decode(String.self, forKey: .messageBody)
        
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
        
        if let tmstmp = try? container.decode(String.self, forKey: .timestamp) {
            timestamp = tmstmp
        }
        
    }
    
}
