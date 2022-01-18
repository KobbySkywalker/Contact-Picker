//
//  BallotSummaryRTDB.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class BallotSummaryRTDB: Codable {
    var groupId: String
    var minVoteCount: Int
    var voteId: String
    var votesCompleted: Int
    var votesRemaining: Int
    
    required init(groupId_: String, minVoteCount_: Int, voteId_: String, votesCompleted_: Int, votesRemaining_: Int) {
        
        self.groupId = groupId_
        self.minVoteCount = minVoteCount_
        self.voteId = voteId_
        self.votesCompleted = votesCompleted_
        self.votesRemaining = votesRemaining_
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        groupId = try container.decode(String.self, forKey: .groupId)
        minVoteCount = try container.decode(Int.self, forKey: .minVoteCount)
        voteId = try container.decode(String.self, forKey: .voteId)
        votesCompleted = try container.decode(Int.self, forKey: .votesCompleted)
        self.votesRemaining = try container.decode(Int.self, forKey: .votesRemaining)
        
    }
    
}
