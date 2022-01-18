//
//  NetworkCodeResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 21/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation


struct MemberCountryResponse {
    var countryId: String
    var countryName: String
    var created: String
    var currency: String
    var modified: String
}

struct ApiMemberCountryResponse: InitializableWithData, InitializableWithJson {
    
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
    
    init(json: [String : Any]) throws {
        print(json)
        var modified = ""
        if let mod = json["modified"] as? String{
            modified = mod
        }
        guard
            var countryId: String = json["countryId"] as? String,
            var countryName: String = json["countryName"] as? String,
            var created: String = json["created"] as? String,
            var currency: String = json["currency"] as? String
            else {
                
                print("Member Country Response Parsing Error")
                throw NSError.createParseError()
        }
        
        self.countryId = countryId
        self.countryName = countryName
        self.created = created
        self.currency = currency
        self.modified = modified
        
    }
    
}

extension ApiMemberCountryResponse {
    var memberCountryResponse: MemberCountryResponse {
        
        
        return MemberCountryResponse(countryId: countryId, countryName: countryName, created: created, currency: currency, modified: modified)
    }
}
