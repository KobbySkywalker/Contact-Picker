//
//  GroupApiRequests.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation
import UIKit
import FirebaseInstanceID



//GET PRIVATE GROUPS
struct getPrivateGroupsRequest: ApiRequest {
    
var urlRequest: URLRequest {
    
    let url: URL! = URL(string: BASE_URL+"privateGroups")
    print(url)

    
    var request = URLRequest(url: url)
    
    request.setValue("application/json", forHTTPHeaderField: "Content-type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("\(api_token!)", forHTTPHeaderField: "idToken")
    request.httpMethod = "GET"
    let instanceID = InstanceID.instanceID().token()
    print(instanceID)
    return request
}
}


//PUBLIC GROUPS
struct publicGroupsRequest: ApiRequest {
let parameter: PublicGroupsParameter

var urlRequest: URLRequest {
    
    let url: URL! = URL(string: BASE_URL+"publicGroups?idToken=\(parameter.idToken)")
    print(url)
    
    var request = URLRequest(url: url)
    do {
        let parameters : [String: Any] = [
            "idToken": parameter.idToken
        ]
        let jsonData1 = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(api_token!)", forHTTPHeaderField: "idToken")
        request.httpMethod = "GET"
        request.httpBody = jsonData1
        print(jsonData1)
        print("headers: \((String(describing: request.allHTTPHeaderFields)))")
    }catch{
        print(error)
    }
    return request
    }
}



//CREATE GROUP
struct createGroupRequest: ApiRequest {
    let parameter: CreateGroupParameter
    
    var urlRequest: URLRequest {
        
        let string = BASE_URL+"createPrivateGroup?countryId=\(parameter.countryId)&groupIconPath=\(parameter.groupIconPath)&groupName=\(parameter.groupName)&description=\(parameter.description)"
        let urlString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url: URL! = URL(string: urlString!)
        print(url)
//        let url: URL! = URL(string: BASE_URL+"createPrivateGroup?countryId=\(parameter.countryId)&groupIconPath=\(parameter.groupIconPath)&groupName=\(parameter.groupName)")
        var request = URLRequest(url: url)
        do {
            let parameters : [String: Any] = [
                "countryId": parameter.countryId,
                "groupIconPath": parameter.groupIconPath,
                "groupName": parameter.groupName,
                "description": parameter.description,
                "ballotDetail": [
                    [
                    "ballotId": parameter.ballotDetail[0].ballotId,
                    "minVote": parameter.ballotDetail[0].minVote
                    ],
                    [
                    "ballotId": parameter.ballotDetail[1].ballotId,
                    "minVote": parameter.ballotDetail[1].minVote
                        ]
                ]
            ]
            let jsonData1 = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("\(api_token!)", forHTTPHeaderField: "idToken")
//            request.setValue("\(InstanceID.instanceID().token())", forHTTPHeaderField: "regToken")
            request.httpMethod = "POST"
            request.httpBody = jsonData1
            print(jsonData1)
            print(InstanceID.instanceID().token())
            print("headers: \((String(describing: request.allHTTPHeaderFields)))")
        }catch{
            print(error)
        }
        return request
    }
}


//JOIN GROUP

struct joinGroupRequest: ApiRequest {
    let parameter: JoinGroupParameter
    
    var urlRequest: URLRequest {
        
        let url: URL! = URL(string: BASE_URL+"joinGroup?groupId=\(parameter.groupId)")
        print(url)
        var request = URLRequest(url: url)
        do {
            let parameters : [String: Any] = [
                "groupId": parameter.groupId
            ]
            let jsonData1 = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("\(api_token!)", forHTTPHeaderField: "idToken")
            request.httpMethod = "POST"
            request.httpBody = jsonData1
            print(jsonData1)
        }catch{
            print(error)
        }
        return request
    }
}

