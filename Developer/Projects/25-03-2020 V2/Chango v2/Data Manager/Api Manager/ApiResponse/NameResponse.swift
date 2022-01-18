//
//  NetworkCodeResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 22/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

struct NameResponse {
    var idResponse: IdResponse
    var name: String
}

struct ApiNameResponse: InitializableWithData, InitializableWithJson {
    
    var idResponse: ApiIdResponse
    var name: String
    
    
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
            let name = json["name"] as? String else{
                
                print("Register Response Parsing Error")
                throw NSError.createParseError()
        }
        
        if let jsonId = json["id"] as? [String: Any] {
            self.idResponse = try ApiIdResponse(json: jsonId)
            self.name = name
            
        }else {
            throw
                NSError.createParseError()
        }
        
        
    }
}


extension ApiNameResponse {
    var nameResponse: NameResponse {
        
        return NameResponse(idResponse: idResponse.idResponse, name: name)
    }
}
