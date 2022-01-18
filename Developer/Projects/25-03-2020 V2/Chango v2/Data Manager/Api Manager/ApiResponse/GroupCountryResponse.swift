//
//  GroupCountryResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

struct GroupCountryResponse {
    var countryId: String
    var countryName: String
    var created: String
    var currency: String
    var modified: String
}

struct ApiGroupCountryResponse: InitializableWithData, InitializableWithJson {
    
    var countryId: String
    var countryName: String
    var created: String
    var currency: String
    var modified: String
    
    
    
    init(data: Data?) throws {
        guard let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let json = jsonObject as? [String: Any] else {
                throw NSError.createParseError()
        }
        
        try self.init(json: json)
        
    }
    
    
    init(json: [String: Any]) throws {
        print(json)
        var modified = ""
        if let mod = json["modified"] as? String{
            modified = mod
        }
        guard
            let countryId: String = json["countryId"] as? String,
            let countryName: String = json["countryName"] as? String,
            let created: String = json["created"] as? String,
            let currency: String = json["currency"] as? String
            else {
                
                print("Group Country Response Parsing Error")
                throw NSError.createParseError()
        }
        
        self.countryId = countryId
        self.countryName = countryName
        self.created = created
        self.currency = currency
        self.modified = modified
        
    }
}


extension ApiGroupCountryResponse {
    var country: GroupCountryResponse {
        
        return GroupCountryResponse(countryId: countryId, countryName: countryName, created: created, currency: currency, modified: modified)
    }
}
