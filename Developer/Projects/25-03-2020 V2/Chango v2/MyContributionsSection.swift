//
//  MyContributionsSection.swift
//  Chango v2
//
//  Created by Hosny Savage on 27/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class MyContributionsSection: NSObject {
    
    @objc dynamic var groupName: String = ""
    @objc dynamic var totalAmount: Double = 0.0
    @objc dynamic var date: String = ""
    @objc dynamic var groupIconPath: String = ""
    @objc dynamic var groupId: String = ""
    var contributions: [Content] = []
    
    convenience init(groupName_: String, totalAmount_: Double, date_: String, groupIconPath_: String, groupId_: String, contributions_: [Content]) {
        self.init()
        
        self.groupName = groupName_
        self.totalAmount = totalAmount_
        self.date = date_
        self.groupIconPath = groupIconPath_
        self.groupId = groupId_
        self.contributions = contributions_
    }
}
