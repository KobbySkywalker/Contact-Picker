//
//  CampaignObject.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class CampaignObject: NSObject {
         
    @objc dynamic var campaignName: String = ""
    @objc dynamic var campaignId: String = ""
    @objc dynamic var groupId: String = ""
    @objc dynamic var voteId: String = ""
    
    
    convenience init(campaignName_: String, campaignId_: String, groupId_: String, voteId_: String) {
        self.init()
        
        self.campaignName = campaignName_
        self.campaignId = campaignId_
        self.groupId = groupId_
        self.voteId = voteId_
        
    }
}
