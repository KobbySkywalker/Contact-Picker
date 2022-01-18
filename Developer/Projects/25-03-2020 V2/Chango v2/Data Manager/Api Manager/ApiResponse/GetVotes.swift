//
//  GetVotes.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 16/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation


struct GetVotes: Codable {
    var ballotId: BallotIdResponse
    var created: String?
    var groupId: MemberGroupIdResponse
    var minVotes: Int?
    var modified: String?
    var rejectMemberId: String?
    var score: Int?
    var status: String?
    var voteId: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        ballotId = try container.decode(BallotIdResponse.self, forKey: .ballotId)
        if let crtd = try? container.decode(String.self, forKey: .created) {
            created = crtd
        }
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        if let mnVts = try? container.decode(Int.self, forKey: .minVotes) {
            minVotes = mnVts
        }
        if let mdfd = try? container.decode(String.self, forKey: .modified) {
            modified = mdfd
        }
        if let rjctMmbrId = try? container.decode(String.self, forKey: .rejectMemberId) {
            rejectMemberId = rjctMmbrId
        }
        if let scr = try? container.decode(Int.self, forKey: .score) {
            score = scr
        }
        if let stts = try? container.decode(String.self, forKey: .status) {
            status = stts
        }
        if let vtId = try? container.decode(String.self, forKey: .voteId) {
            voteId = vtId
        }
        
    
    }
}
