//
//  ReportCampaign.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/02/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

struct ReportCampaign: Codable {
    var campaignId: String?
    var created: String
    var id: Int
    var message: String
    var name: String
    var phone: String
    var anonymous: Bool?
    var groupId: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        campaignId = try container.decode(String.self, forKey: .campaignId)
        created = try container.decode(String.self, forKey: .created)
        id = try container.decode(Int.self, forKey: .id)
        message = try container.decode(String.self, forKey: .message)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        if let cmpd = try? container.decode(String.self, forKey: .campaignId) {
            campaignId = cmpd
        }
        if let annyms = try? container.decode(Bool.self, forKey: .anonymous) {
            anonymous = annyms
        }
        if let grpd = try? container.decode(String.self, forKey: .groupId) {
            groupId = grpd
        }
    }
    
}
