//
//  UserActivity.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct UserActivity: Codable {
    var action: String
    var activityId: Int
    var context: String
    var created: String
    var groupIconPath: String?
    var groupId: String?
    var authProviderId: String
    var message: String
    var anonymous: Bool
    var userAgent: String?
    var ipAddress: String?
    var memberName: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        action = try container.decode(String.self, forKey: .action)
        activityId = try container.decode(Int.self, forKey: .activityId)
        context = try container.decode(String.self, forKey: .context)
        created = try container.decode(String.self, forKey: .created)
        if let grpd = try? container.decode(String.self, forKey: .groupId) {
            groupId = grpd
        }
        if let grpcn = try? container.decode(String.self, forKey: .groupIconPath) {
            groupIconPath = grpcn
        }
        authProviderId = try container.decode(String.self, forKey: .authProviderId)
        message = try container.decode(String.self, forKey: .message)
        anonymous = try container.decode(Bool.self, forKey: .anonymous)
        if let memName = try? container.decode(String.self, forKey: .memberName) {
            memberName = memName
        }
        if let uAgent = try? container.decode(String.self, forKey: .userAgent) {
            userAgent = uAgent
        }
        if let ipAdd = try? container.decode(String.self, forKey: .ipAddress) {
            ipAddress = ipAdd
        }
    }
}
