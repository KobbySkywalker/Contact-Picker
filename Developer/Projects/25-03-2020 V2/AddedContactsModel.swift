//
//  AddedContactsModel.swift
//  Chango v2
//
//  Created by Hosny Savage on 14/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

class AddedContactsModel: NSObject {
    
    @objc dynamic var name: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var image: String = ""
    
    convenience init(name_: String, phoneNumber_: String, image_: String) {
        self.init()
        
        self.name = name_
        self.phoneNumber = phoneNumber_
        self.image = image_
        
    }
}
