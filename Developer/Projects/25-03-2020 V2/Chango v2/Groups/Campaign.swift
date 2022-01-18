//
//  Campaign.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 01/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class Campaign: NSObject {
    
    @objc dynamic var campaignName: String = ""
    @objc dynamic var campaignId: String = ""
    
    convenience init(campaignName_: String, campaignId_: String) {
        self.init()
        
        self.campaignName = campaignName_
        self.campaignId = campaignId_
    }
}
