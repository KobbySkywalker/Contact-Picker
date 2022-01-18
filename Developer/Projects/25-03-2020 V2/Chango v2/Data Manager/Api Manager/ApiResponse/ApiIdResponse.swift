//
//  ApiId.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 21/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation


struct IdResponse {
    var country: Country
    var networkCode: String
}

struct ApiIdResponse: InitializableWithData, InitializableWithJson {
    
    var country: ApiCountry
    var networkCode: String
    

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
        guard
            let networkCode = json["networkCode"] as? String else{
                
                print("Register Response Parsing Error")
                throw NSError.createParseError()
        }
        
        if let jsonCountry = json["country"] as? [String: Any] {
            self.country = try ApiCountry(json: jsonCountry)
            self.networkCode = networkCode

        }else {
            throw
                NSError.createParseError()
        }

        
    }
}

extension ApiIdResponse {
    var idResponse: IdResponse {
        
        return IdResponse(country: country.country, networkCode: networkCode)
    }
}



