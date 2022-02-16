//
//  GetGroupCampaignsResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class GetGroupCampaignsResponse: Codable {
    var campaignId: String?
    var groupId: MemberGroupIdResponse
    var campaignName: String
    var campaignType: String
    var start: String?
    var end: String?
    var target: Double?
    var status: String?
    var campaignRef: String?
    var campaignFlag: String?
    var amountReceived: Double?
    var created: String
    var modified: String?
    var description: String?
    var alias: String?
    var defaultCampaignIconPath: String?
    
    
    required init(campaignId_: String, groupId_: MemberGroupIdResponse, campaignName_: String, campaignType_: String, start_: String, end_: String, target_: Double, status_: String, campaignRef_: String, campaignFlag_: String, amountReceived_: Double, created_: String, modified_: String, description_: String, alias_: String, defaultCampaignIconPath_: String) {
        
        self.campaignId = campaignId_
        self.groupId = groupId_
        self.campaignName = campaignName_
        self.campaignType = campaignType_
        self.start = start_
        self.end = end_
        self.target = target_
        self.status = status_
        self.campaignRef = campaignRef_
        self.campaignFlag = campaignFlag_
        self.amountReceived = amountReceived_
        self.created = created_
        self.modified = modified_
        self.description = description_
        self.alias = alias_
        self.defaultCampaignIconPath = defaultCampaignIconPath_
    }
    
   required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        campaignId = try container.decode(String.self, forKey: .campaignId)
    
//    if let cmpd = try? container.decode(String.self, forKey: .campaignId) {
//        campaignId = cmpd
//    }
    
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        campaignName = try container.decode(String.self, forKey: .campaignName)
        campaignType = try container.decode(String.self, forKey: .campaignType)
        created = try container.decode(String.self, forKey: .created)
//        description = try container.decode(String.self, forKey: .description)
    
        if let desc = try? container.decode(String.self, forKey: .description) {
        description = desc
        }
    
        if let strt = try? container.decode(String.self, forKey: .start) {
            start = strt
        }
        if let nd = try? container.decode(String.self, forKey: .end) {
            end = nd
        }
        if let trgt = try? container.decode(Double.self, forKey: .target) {
            target = trgt
        }
        if let stts = try? container.decode(String.self, forKey: .status) {
            status = stts
        }
        if let cmpgnrf = try? container.decode(String.self, forKey: .campaignRef) {
            campaignRef = cmpgnrf
        }
        if let cmpgnflg = try? container.decode(String.self, forKey: .campaignFlag) {
        campaignFlag = cmpgnflg
        }
        if let amntRcvd = try? container.decode(Double.self, forKey: .amountReceived) {
            amountReceived = amntRcvd
        }
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
    
    if let ali = try? container.decode(String.self, forKey: .alias) {
        alias = ali
    }
    
    if let dftltIcnPth = try? container.decode(String.self, forKey: .defaultCampaignIconPath) {
        defaultCampaignIconPath = dftltIcnPth
    }

    }
}
