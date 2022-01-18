//
//  CreateVoteResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 28/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct CreateVoteResponse: Codable{
    var ballotId: BallotIdResponse
    var created: String
    var groupId: MemberGroupIdResponse
    var minvotes: Int
    var modified: String?
    var rejectMemberId: String
    var score: Int
    var status: String
    var voteId: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        ballotId = try container.decode(BallotIdResponse.self, forKey: .ballotId)
        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        minvotes = try container.decode(Int.self, forKey: .minvotes)
        rejectMemberId = try container.decode(String.self, forKey: .rejectMemberId)
        score = try container.decode(Int.self, forKey: .score)
        status = try container.decode(String.self, forKey: .status)
        voteId = try container.decode(String.self, forKey: .voteId)
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
    }
}
