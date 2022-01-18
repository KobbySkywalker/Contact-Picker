//
//  CreateCampaignResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 28/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct CreateCampaignResponse: Codable {
    var amountReceived: String
    var campaignId: String?
    var campaignName: String
    var campaignRef: String
    var campaignType: String
    var created: String
    var end: String
    var groupId: MemberGroupIdResponse
    var modified: String?
    var start: String
    var status: String
    var target: String
    
    private enum CodingKeys: String, CodingKey {
        case amountReceived
        case campaignId
        case campaignName
        case campaignRef
        case campaignType
        case created
        case end
        case groupId
        case modified
        case start
        case status
        case target
    }
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amountReceived = try container.decode(String.self, forKey: .amountReceived)
//        campaignId = try container.decode(String.self, forKey: .campaignId)
        campaignName = try container.decode(String.self, forKey: .campaignName)
        campaignRef = try container.decode(String.self, forKey: .campaignRef)
        campaignType = try container.decode(String.self, forKey: .campaignType)
        created = try container.decode(String.self, forKey: .created)
        end = try container.decode(String.self, forKey: .end)
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        start = try container.decode(String.self, forKey: .start)
        status = try container.decode(String.self, forKey: .status)
        target = try container.decode(String.self, forKey: .target)
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
        if let cmpgnd = try? container.decode(String.self, forKey: .campaignId) {
            campaignId = cmpgnd
        }
        
    }
}
