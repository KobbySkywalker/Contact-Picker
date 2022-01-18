//
//  Content.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct Content: Codable {
    var id: String
    var groupId: MemberGroupIdResponse
    var memberId: MemberIdResponse
    var currency: String
    var amount: Double
    var displayAmount: String?
    var created: String
    var modified: String?
    var anonymous: Bool?
    var campaignId: GetGroupCampaignsResponse
}
