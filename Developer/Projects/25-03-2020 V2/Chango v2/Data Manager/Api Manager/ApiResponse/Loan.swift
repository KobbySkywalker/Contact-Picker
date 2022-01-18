//
//  Loan.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 01/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

import Foundation

class Loan: Codable {
    var grants: Grants
    var membersRTDB: MembersRTDB

    
    required init(grants_: Grants, membersRTDB_: MembersRTDB) {
        
        self.grants = grants_
        self.membersRTDB = membersRTDB_
    }
}
