//
//  MemberApiRequest.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation
import UIKit

//ADD MEMBER REQUEST
struct addMemberRequest: ApiRequest {
    let parameter: AddMemberParameter
    
    var urlRequest: URLRequest {
        
        let string = BASE_URL+"addGroupMembers?groupId=\(parameter.groupId)&msisdenList=\(parameter.msisdnList)"
        let urlString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url: URL! = URL(string: urlString!)
        print(url)
        
        var request = URLRequest(url: url)
        do {
            let parameters : [String: Any] = [

                "groupId": parameter.groupId,
                "msisdnList": parameter.msisdnList
            ]
            print(parameters)
            let jsonData1 = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("\(api_token!)", forHTTPHeaderField: "idToken")
            request.httpMethod = "POST"
            request.httpBody = jsonData1
            print(jsonData1)
            print("headers: \((String(describing: request.allHTTPHeaderFields)))")
        }catch{
            print(error)
        }
        return request
    }
}
    
    
    
    //GET MEMBER REQUEST
    struct getMembersApiRequest: ApiRequest {
        let parameter: GetMembersParameter
        
        var urlRequest: URLRequest {
            
            let url: URL! = URL(string: BASE_URL+"groupMembers?groupId=\(parameter.groupId)")
            print(url)
            print("\(String(describing: api_token))")

            var request = URLRequest(url: url)
            do {
                let parameters : [String: Any] = [
                    "groupId": parameter.groupId
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




