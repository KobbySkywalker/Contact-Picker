//
//  memberGroupIdResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 25/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation


struct MemberGroupIdResponse {
    var countryId: CountryId
    var created: String
    var description: String
    var groupIconPath: String
    var groupId: String
    var groupName: String
    var groupType: String
    var modified: String
    var status: String
    var tnc: String
}

struct ApimemberGroupResponseGroupsResponse: InitializableWithData, InitializableWithJson {
    
    var country: ApiCountryId
    var groupId: String
    var groupName: String
    var groupType: String
    var groupIconPath: String
    var tnc: String
    var status: String
    var created: String
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
        print("got here")
        print(json)
        var tnc = ""
        if let tncc = json["tnc"] as? String{
            tnc = tncc
        }
        guard
            let groupId = json["groupId"] as? String,
            let groupName = json["groupName"] as? String,
            let groupType = json["groupType"] as? String,
            let groupIconPath = json["groupIconPath"] as? String,
            let status = json["status"] as? String,
            let created = json["created"] as? String,
            let modified = json["modified"] as? String else{
                
                print("Private Group Response Parsing Error")
                throw NSError.createParseError()
        }
        
        if let jsonPrivateGroup = json["countryId"] as? [String: Any] {
            self.country = try ApiCountryId(json: jsonPrivateGroup)
            self.groupId = groupId
            self.groupName = groupName
            self.groupType = groupType
            self.groupIconPath = groupIconPath
            self.tnc = tnc
            self.status = status
            self.created = created
            self.modified = modified
            
        }else {
            throw
                NSError.createParseError()
        }
    }
}

extension ApiPrivateGroupsResponse {
    var privateGroupResponse: PrivateGroupsResponse {
        
        return PrivateGroupsResponse(country: country.country, groupId: groupId, groupName: groupName, groupType: groupType, groupIconPath: groupIconPath, tnc: tnc, status: status, created: created, modified: modified)
    }
}

