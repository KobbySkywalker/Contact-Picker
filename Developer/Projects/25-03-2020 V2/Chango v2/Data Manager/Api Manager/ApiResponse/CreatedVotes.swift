//
//  CreatedVotes.swift
//  Alamofire
//
//  Created by Hosny Ben Savage on 12/03/2019.
//

import Foundation

struct CreatedVotes: Codable {
//    var groupSize: Int
    var ballotId: BallotIdResponse
    var created: String
    var groupId: MemberGroupIdResponse
    var minVotes: Double
    var modified: String
    var rejectMemberId: String?
    var score: Int
    var status: String?
    var voteId: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        groupSize = try container.decode(Int.self, forKey: .groupSize)
        ballotId = try container.decode(BallotIdResponse.self, forKey: .ballotId)
        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        minVotes = try container.decode(Double.self, forKey: .minVotes)
        modified = try container.decode(String.self, forKey: .modified)
        if let reject = try? container.decode(String.self, forKey: .rejectMemberId) {
            rejectMemberId = reject
        }
        score = try container.decode(Int.self, forKey: .score)
        voteId = try container.decode(String.self, forKey: .voteId)
        if let stat = try? container.decode(String.self, forKey: .status) {
            status = stat
        }

    }
}
