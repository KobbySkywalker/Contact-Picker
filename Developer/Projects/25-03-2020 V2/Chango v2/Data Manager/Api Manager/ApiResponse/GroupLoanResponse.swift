//
//  GroupLoanResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 02/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct GroupLoanResponse: Codable {
    var amount: Double
    var campaignId: GetGroupCampaignsResponse?
    var created: String
    var groupId: MemberGroupIdResponse
    var loanId: String
    var memberId: Member
    var reason: String?
    var status: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try container.decode(Double.self, forKey: .amount)
        if let campId = try? container.decode(GetGroupCampaignsResponse.self, forKey: .campaignId) {
            campaignId = campId
        }
        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        loanId = try container.decode(String.self, forKey: .loanId)
        memberId = try container.decode(Member.self, forKey: .memberId)
        if let rsn = try? container.decode(String.self, forKey: .reason) {
            reason = rsn
        }
        status = try container.decode(String.self, forKey: .status)
    }
}
