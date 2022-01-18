//
//  ContributeResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation


struct ContributeResponse: Codable {
//    var invoiceId: String?
//    var groupId: MemberGroupIdResponse?
//    var campaignId: GetGroupCampaignsResponse?
//    var memberId: MemberId?
//    var currency: String?
//    var amount: Double?
//    var created: String?
//    var modified: String?
    
    var responseCode: String?
    var responseMessage: String?
    
//    private enum CodingKeys: String, CodingKey {
//        case invoiceId
//        case groupId
//        case campaignId
//        case memberId
//        case currency
//        case amount
//        case created
//        case modified
//    }
//
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        if let invcd = try? container.decode(String.self, forKey: .invoiceId) {
//            invoiceId = invcd
//        }
//
//        if let grpd = try? container.decode(MemberGroupIdResponse.self, forKey: .groupId) {
//            groupId = grpd
//        }
//
//        if let cmpgnd = try? container.decode(GetGroupCampaignsResponse.self, forKey: .campaignId) {
//            campaignId = cmpgnd
//        }
//
//        if let mmbrd = try? container.decode(MemberId.self, forKey: .memberId) {
//            memberId = mmbrd
//        }
//
//        if let crrncy = try? container.decode(String.self, forKey: .currency) {
//            currency = crrncy
//        }
//
//        if let amnt = try? container.decode(Double.self, forKey: .amount) {
//            amount = amnt
//        }
//
//        if let crtd = try? container.decode(String.self, forKey: .created) {
//            created = crtd
//        }
//
//        if let mdfd = try? container.decode(String.self, forKey: .modified) {
//            modified = mdfd
//        }
////        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
////        campaignId = try container.decode(GetGroupCampaignsResponse.self, forKey: .campaignId)
////        memberId = try container.decode(MemberId.self, forKey: .memberId)
////        currency = try container.decode(String.self, forKey: .currency)
////        amount = try container.decode(Double.self, forKey: .amount)
////        created = try container.decode(String.self, forKey: .created)
////        modified = try container.decode(String.self, forKey: .modified)
//
//    }
}
