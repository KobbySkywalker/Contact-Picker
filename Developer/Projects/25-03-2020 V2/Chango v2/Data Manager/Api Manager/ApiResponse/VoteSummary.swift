//
//  VoteSummary.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 03/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct VoteSummary: Codable {
//    var ballotSummary: [BallotSummary]?
    var ballot: String
    var minAdminVoteCount: Int
    var minLoanerVoteCount: Int
    var minMemberVoteCount: Int
    var minVoteCount: Int
    var votesCompleted: Int
    var votesRemaining: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        ballot = try container.decode(String.self, forKey: .ballot)
        minAdminVoteCount = try container.decode(Int.self, forKey: .minAdminVoteCount)
        minLoanerVoteCount = try container.decode(Int.self, forKey: .minLoanerVoteCount)
        minMemberVoteCount = try container.decode(Int.self, forKey: .minMemberVoteCount)
        minVoteCount = try container.decode(Int.self, forKey: .minVoteCount)
        votesCompleted = try container.decode(Int.self, forKey: .votesCompleted)
        votesRemaining = try container.decode(Int.self, forKey: .votesRemaining)
        
    }
    

}
