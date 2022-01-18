//
//  RevokeAdmin.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 01/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct RevokeAdminResponse: Codable {
    var created: String
    var groupId: MemberGroupIdResponse
    var id: String
    var memberId: MemberIdResponse
    var modified: String?
    var role: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        id = try container.decode(String.self, forKey: .id)
        role = try container.decode(String.self, forKey: .role)
        memberId = try container.decode(MemberIdResponse.self, forKey: .memberId)
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
    }
}
