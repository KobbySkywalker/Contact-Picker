//
//  Invites.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation
import RealmSwift

class RealmGroup: Object {
    
    @objc dynamic var countryId: String = ""
    @objc dynamic var groupName: String = ""
    @objc dynamic var groupId: String = ""
    @objc dynamic var groupType: String = ""
    @objc dynamic var groupIconPath: String = ""
    @objc dynamic var created: String = ""
    @objc dynamic var modified: String = ""
    @objc dynamic var tnc: String = ""
    @objc dynamic var status: String = ""
    
    
    convenience init(countryId_: String, groupName_: String, groupId_: String, groupType_: String, groupIconPath_: String, created_: String, modified_: String, tnc_: String, status_: String) {
        self.init()
        
        self.countryId = countryId_
        self.groupName = groupName_
        self.groupId = groupId_
        self.groupType = groupType_
        self.groupIconPath = groupIconPath_
        self.created = created_
        self.modified = modified_
        self.tnc = tnc_
        self.status = status_
    }
    
    override static func primaryKey() -> String? {
        return "groupId"
    }

    
}
