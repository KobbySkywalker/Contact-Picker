//
//  BankModel.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 18/03/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

struct BankModel {
    
    var bankName: String = ""
    var bankCode: String = ""
    var bankImage: String = ""

    init(bankName_: String, bankCode_: String, bankImage_: String) {
        
        bankName = bankName_
        bankCode = bankCode_
        bankImage = bankImage_

    }
}

struct NetworkModel {
    var networkId: Int = 0
    var networkName: String = ""
    var networkCode: String = ""
    var networkImage: String = ""
    
    init(networkId_: Int, networkName_: String, networkCode_: String, networkImage_: String) {
        networkId = networkId_
        networkName = networkName_
        networkCode = networkCode_
        networkImage = networkImage_
    }
}


struct DrawerModel {
    var id: Int = 0
    var itemName: String = ""
    var itemImage: String = ""
    
    init(id_: Int, itemName_: String, itemImage_: String) {
        id = id_
        itemName = itemName_
        itemImage = itemImage_
    }
}


struct FAQsModel {
    var id: Int = 0
    var itemName: String = ""
    var itemDescription: String = ""
    
    init(id_: Int, itemName_: String, itemDescription_: String) {
        id = id_
        itemName = itemName_
        itemDescription = itemDescription_
    }
}
