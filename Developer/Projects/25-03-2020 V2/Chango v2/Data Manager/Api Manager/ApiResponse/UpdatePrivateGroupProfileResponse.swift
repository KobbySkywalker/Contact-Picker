//
//  UpdatePrivateGroupProfileResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 28/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

public struct UpdatePrivateGroupProfileResponse: Codable {
    var countryId: CountryId
    var approve: String?
    var groupId: String
    var groupName: String
    var groupType: String
    var groupIconPath: String?
    var tnc: String?
    var status: String
    var created: String
    var creatorId: String?
    var defaultCampaignId: String?
    var loanFlag: Int
    var creatorName: String
    var modified: String?
    var description: String?
    
    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        created = try container.decode(String.self, forKey: .created)
//        groupId = try container.decode(String.self, forKey: .groupId)
//        groupName = try container.decode(String.self, forKey: .groupName)
//        groupType = try container.decode(String.self, forKey: .groupType)
//        status = try container.decode(String.self, forKey: .status)
//        countryId = try container.decode(CountryId.self, forKey: .countryId)
//        
//        
//        
//        if let mod = try? container.decode(String.self, forKey: .modified) {
//            modified = mod
//        }
//        
//        if let gip = try? container.decode(String.self, forKey: .groupIconPath) {
//            groupIconPath = gip
//        }
//        
//        if let desc = try? container.decode(String.self, forKey: .description) {
//            description = desc
//        }
//        
//        if let terms = try? container.decode(String.self, forKey: .tnc) {
//            tnc = terms
//        }
//        
//    }
    
}
