//
//  File.swift
//  GENPAY
//
//  Created by Hosny Ben Savage on 04/12/2018.
//  Copyright © 2018 ITC. All rights reserved.
//

import Foundation

//Parameters
struct AddMemberParameter {
    var groupId: String
    var msisdnList: [String]
}


//MembersApiManger
func addMembers(parameter: AddMemberParameter, completionHandler: @escaping (Results<AddMemberResponse>) -> Void) {
    apiClient.execute(request: request) { (result: Result<ApiAddMemberResponse>>) in
        switch result {
        case let .success(response):
            print("success")
            let addMemberResult = response.entity.addMemberResponse
            completionHandler(.success(addMemberResult))
        case let .failure(error):
            print("failure")
            completionHandler(.failure(error))
        }
    }
}


//Add Member Response

public struct AddMemberResponse {
    var response: String
}

struct ApiAddMemberResponse {
    var response: String
    
    init(data: Data?) throws {
        guard let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let json = jsonObject as? [String: Any] else {
                throw NSError.createParseError()
        }
        try self.init(json: json)
        
    }
    

    
}

extension ApiAddMemberResponse {
    var addMemberResponse: AddMemberResponse {
        
        return AddMemberResponse(response: response)
    }
}


protocol MemberDataProtocol {
    func addMembers(completionHandler: @escaping (_ members: Result<AddMemberResponse>) -> Void)
}



//ADD MEMBER REQUEST
struct addMembersToGroup: ApiRequest {
    let parameter: AddMemberParameter
    
    var urlRequest: URLRequest {
        
        let string = BASE_URL+"addGroupMembers?groupId=\(parameter.groupId)&msisdenList=\(parameter.msisdnList)"
        let urlString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url: URL! = URL(string: urlString!)
        print(url)

        var request = URLRequest(url: url)
        do {
            let parameters : [String: Any] = [
                "groupId": parameter.groupId
                "msisdnList": parameter.msisdnList
            ]
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
