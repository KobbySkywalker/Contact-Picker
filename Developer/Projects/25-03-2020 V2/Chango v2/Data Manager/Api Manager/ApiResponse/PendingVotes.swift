//
//  PendingVotes.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class PendingVotes: Codable {
    var amount: String
    var campaignId: String
    var campaignName: String
    var campaignBalance: String
    var groupId: String
    var memberId: String
    var nameOfMemberActionIsAbout: String
    var authProviderId: String
    var network: String
    var voteId: String
    var voteType: String
    var cashoutDestination: String
    var cashoutDestinationCode: String
    var cashoutDestinationNumber: String
    var reason: String
    var voteCount: String
    var role: String
    var membersRTDB: MembersRTDB
//    var ballotSummary: BallotSummaryRTDB
    
    required init(amount_: String, campaignId_: String, campaignName_: String, campaignBalance_: String, groupId_: String, memberId_: String, nameOfMemberActionIsAbout_: String, authProviderId_:String, network_: String, voteId_: String, voteType_: String, cashoutDestination_: String, cashoutDestinationCode_: String, cashoutDestinationNumber_: String, reason_: String, voteCount_: String, role_: String, membersRTDB_: MembersRTDB/*, ballotSummary_: BallotSummaryRTDB*/) {
        
        self.amount = amount_
        self.campaignId = campaignId_
        self.campaignName = campaignName_
        self.campaignBalance = campaignBalance_
        self.groupId = groupId_
        self.memberId = memberId_
        self.nameOfMemberActionIsAbout = nameOfMemberActionIsAbout_
        self.authProviderId = authProviderId_
        self.network = network_
        self.voteId = voteId_
        self.voteType = voteType_
        self.cashoutDestination = cashoutDestination_
        self.cashoutDestinationCode = cashoutDestinationCode_
        self.cashoutDestinationNumber = cashoutDestinationNumber_
        self.reason = reason_
        self.voteCount = voteCount_
        self.role = role_
        self.membersRTDB = membersRTDB_
//        self.ballotSummary = ballotSummary_
    }
}
