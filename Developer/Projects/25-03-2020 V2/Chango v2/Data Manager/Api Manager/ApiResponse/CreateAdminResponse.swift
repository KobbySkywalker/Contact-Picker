//
//  createAdminResponse.swift
//  Chango v2
//
//  Created by Hosny Savage on 27/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct CreateAdminResponse: Codable {
    var created: String?
    var groupId: MemberGroupIdResponse?
    var id: String?
    var memberId: MemberIdResponse?
    var modified: String?
    var role: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case created
        case groupId
        case id
        case memberId
        case modified
        case role
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        created = try container.decode(String.self, forKey: .created)
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        id = try container.decode(String.self, forKey: .id)
        role = try container.decode(String.self, forKey: .role)
        memberId = try container.decode(MemberIdResponse.self, forKey: .memberId)
        
//        if let grpd = try? container.decode(MemberGroupIdResponse.self, forKey: .groupId) {
//            groupId = grpd
//        }
//        
//        if let idd = try? container.decode(String.self, forKey: .id) {
//            id = idd
//        }
//        
//        if let rl = try? container.decode(String.self, forKey: .role) {
//            role = rl
//        }
//        
//        if let mmbrd = try? container.decode(MemberIdResponse.self, forKey: .memberId) {
//            memberId = mmbrd
//        }
        
        if let crtd = try? container.decode(String.self, forKey: .created) {
            created = crtd
        }
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
    }
}
