//
//  Chats.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class Message: NSObject {
    var groupId: String
    var key: String
    var message: String
    var timestamp: Int
    var userId: String
    
    required init(groupId_: String, key_: String, message_: String, timestamp_: Int, userId_: String) {
        
        self.groupId = groupId_
        self.key = key_
        self.message = message_
        self.timestamp = timestamp_
        self.userId = userId_
    }
}
