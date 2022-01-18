//
//  CreatedVotesResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 09/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct CreatedVotesResponse: Codable {
    var groupSize: Int
    var votes: [CreatedVotes]

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        groupSize = try container.decode(Int.self, forKey: .groupSize)
        votes = try container.decode([CreatedVotes].self, forKey: .votes)

        
    }
}
