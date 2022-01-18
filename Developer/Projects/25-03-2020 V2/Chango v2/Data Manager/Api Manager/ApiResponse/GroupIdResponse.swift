//
//  GroupIdResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

struct GroupId  {

var groupIconPath: String
var groupId: String
var groupName: String
var groupType: String
var description: String
var tnc: String

}

struct ApiGroupId: InitializableWithData, InitializableWithJson {

var groupIconPath: String
var groupId: String
var groupName: String
var groupType: String
var description: String
var tnc: String
    
    
    init(data: Data?) throws {
        guard let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let json = jsonObject as? [String: Any] else {
                throw NSError.createParseError()
        }
        
        try self.init(json: json)
        
    }
    
    
    init(json: [String : Any]) throws {
        print("show json: \(json)")
//        var tnc = ""
//        if let tncc = json["tnc"] as? String{
//            tnc = tncc
//        }

        var groupIconPath = "<null>"
        if let groupIcon = json["groupIconPath"] as? String{
            groupIconPath = groupIcon
        }
        guard
            let groupId = json["groupId"] as? String,
            let groupName = json["groupName"] as? String,
            let groupType = json["groupType"] as? String,
            let description = json["description"] as? String,
            let tnc = json["tnc"] as? String else{
                
                print("Group Id Parsing Error")
                throw NSError.createParseError()
        }
                    self.groupIconPath = groupIconPath
                    self.groupId = groupId
                    self.groupName = groupName
                    self.groupType = groupType
                    self.description = description
                    self.tnc = tnc
        
    }
}

extension ApiGroupId {
    var apiGroup: GroupId {
        
        return GroupId(groupIconPath: groupIconPath, groupId: groupId, groupName: groupName, groupType: groupType, description: description, tnc: tnc)
    }
}
