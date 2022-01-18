//
//  PrivateGroupResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

class GroupResponse: Codable {
    var countryId: CountryId
    var groupId: String = ""
    var groupName: String = ""
    var groupType: String = ""
    var loanFlag: Int = 0
    var groupIconPath: String? = ""
    var tnc: String? = ""
    var status: String = ""
    var created: String = ""
    var defaultCampaignId: String? = ""
    var modified: String? = ""
    var description: String? = ""
    var approve: String? = ""
    var creatorId: String? = ""
    var creatorName: String? = ""
    var isUsingGroupLimits: String? = ""
    var campaignCount: Int? = 0
    var groupMemberCount: Int? = 0
    
    required init(countryId_: CountryId, groupId_: String, groupName_: String, groupType_: String, loanFlag_: Int, groupIconPath_: String, tnc_: String, status_: String, created_: String, defaultCampaignId_: String, modified_: String, description_: String, approve_: String, creatorId_: String, creatorName_: String, isUsingGroupLimits_: String, campaignCount_: Int, groupMemberCount_: Int) {
    
        self.countryId = countryId_
        self.groupId = groupId_
        self.groupName = groupName_
        self.groupType = groupType_
        self.loanFlag = loanFlag_
        self.groupIconPath = groupIconPath_
        self.tnc = tnc_
        self.status = status_
        self.created = created_
        self.defaultCampaignId = defaultCampaignId_
        self.modified = modified_
        self.description = description_
        self.approve = approve_
        self.creatorId = creatorId_
        self.creatorName = creatorName_
        self.isUsingGroupLimits = isUsingGroupLimits_
        self.campaignCount = campaignCount_
        self.groupMemberCount = groupMemberCount_
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(String.self, forKey: .groupId)
        groupName = try container.decode(String.self, forKey: .groupName)
        groupType = try container.decode(String.self, forKey: .groupType)
        loanFlag = try container.decode(Int.self, forKey: .loanFlag)
        status = try container.decode(String.self, forKey: .status)
        countryId = try container.decode(CountryId.self, forKey: .countryId)

        if let defaultcmpgnId = try? container.decode(String.self, forKey: .defaultCampaignId) {
            defaultCampaignId = defaultcmpgnId
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
        
        if let pprv = try? container.decode(String.self, forKey: .approve) {
            approve = pprv
        }
        
        if let crtrId = try? container.decode(String.self, forKey: .creatorId) {
            creatorId = crtrId
        }
        
        if let crtrNm = try? container.decode(String.self, forKey: .creatorName) {
            creatorName = crtrNm
        }
        
        if let isUsngGrpLmts = try? container.decode(String.self, forKey: .isUsingGroupLimits) {
            isUsingGroupLimits = isUsngGrpLmts
        }
        
        if let cmpgnCnt = try? container.decode(Int.self, forKey: .campaignCount) {
            campaignCount = cmpgnCnt
        }
        
        if let grpMmbrCnt = try? container.decode(Int.self, forKey: .groupMemberCount) {
            groupMemberCount = grpMmbrCnt
        }
        
    }

}

