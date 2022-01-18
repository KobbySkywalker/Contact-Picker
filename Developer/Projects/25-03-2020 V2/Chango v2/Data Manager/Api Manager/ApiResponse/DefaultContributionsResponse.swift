//
//  DefaultContributionsResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct DefaultCampaignResponse: Codable {
    
    var contributions: [contribution]
    var groupId: String?
    var total: String?
    var campaignId: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        campaignId = try container.decode(String.self, forKey: .campaignId)
        contributions = try container.decode([contribution].self, forKey: .contributions)
//        groupId = try container.decode(String.self, forKey: .groupId)
//        total = try container.decode(String.self, forKey: .total)
        
        
        if let cmpgnd = try? container.decode(String.self, forKey: .campaignId) {
            campaignId = cmpgnd
        }

        if let grpd = try? container.decode(String.self, forKey: .groupId) {
            groupId = grpd
        }
        
        if let ttl = try? container.decode(String.self, forKey: .total) {
            total = ttl
        }
    }
}



