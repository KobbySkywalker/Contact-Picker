//
//  BallotIdResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 28/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct BallotIdResponse: Codable {
    var ballot: String
    var ballotId: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        ballot = try container.decode(String.self, forKey: .ballot)
        ballotId = try container.decode(String.self, forKey: .ballotId)

    }
}
