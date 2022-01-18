//
//  CastVote.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct CastVote: Codable {
    var created: String
    var id: Int
    var memberId: MemberIdResponse
    var modified: String
    var status: String
    var voteId: VoteId
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        created = try container.decode(String.self, forKey: .created)
        id = try container.decode(Int.self, forKey: .id)
        memberId = try container.decode(MemberIdResponse.self, forKey: .memberId)
        modified = try container.decode(String.self, forKey: .modified)
        status = try container.decode(String.self, forKey: .status)
        voteId = try container.decode(VoteId.self, forKey: .voteId)
        
    }

}
