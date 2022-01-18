//
//  Members.swift
//  GENPAY
//
//  Created by Hosny Ben Savage on 04/12/2018.
//  Copyright © 2018 ITC. All rights reserved.
//

import Foundation

//Parameters
struct GetMembersParameter {
    var groupId: String
}

//GetMembersApiManager
func getMembers(parameter: GetMembersParameter, completionHandler: @escaping (Results<GetMembersResponse>) -> Void) {
    apiClient.execute(request: request) { (result: Result<ApiGetMemberResponse>>) in
        switch result {
        case let .success(response):
            print("success")
            let getMemberResult = response.entity.getMemberResponse
            completionHandler(.success(getMemberResult))
        case let .failure(error):
            print("failure")
            completionHandler(.failure(error))
        }
        
    }
}


//Get Member Response

public struct GetMemberResponse {
    var created: String
    var email: String
    var firstName: String
    var language: String
    var lastName: String
    var memberIconPath: String
    var memberId: String
    var modified: String
    var msisdn: String
    var networkCode: String
    var registrationToken: String
}

struct ApiGetMemberResponse {
    var created: String
    var email: String
    var firstName: String
    var language: String
    var lastName: String
    var memberIconPath: String
    var memberId: String
    var modified: String
    var msisdn: String
    var networkCode: String
    var registrationToken: String
    
    
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
        var modifieid = ""
        if let mod = json["modified"] as? String{
            modifieid = mod
        }
        guard
        let created = json["created"] as? String,
        let email = json["email"] as? String,
        let firstName = json["firstName"] as? String,
        let language = json["language"] as? String,
        let lastName = json["lastName"] as? String,
        let memberIconPath = json["memberIconPath"] as? String,
        let memberId = json["memberId"] as? String,
        let msisdn = json["msisdn"] as? String,
        let networkCode = json["networkCode"] as? String,
            let registrationToken = json["registrationToken"] as? String {
                
                print("Get Members Response Parsing Error")
                throw NSError.createParseError()
        }
        
        self.created = created
        self.email = email
        self.firstName = firstName
        self.language = language
        self.lastName = lastName
        self.memberIconPath = memberIconPath
        self.memberId = memberId
        self.msisdn = msisdn
        self.networkCode = networkCode
    }
}

extension ApiGetMemberResponse {
    var getMemberResponse: GetMemberResponse {
        
        return GetMemberResponse(created: created, email: email, firstName: firstName, language: language, lastName: lastName, memberIconPath: memberIconPath, memberId: memberId, modified: modified, msisdn: msisdn, networkCode: networkCode, registrationToken: registrationToken)
    }
}



//GET MEMBER REQUEST
struct  getMemberRequest: ApiRequest {
    let parameter: GetMembersParameter
    
    var urlRequest: URLRequest {
        
        let url: URL! = URL(BASE_URL+"groupMembers?groupId=\(parameter.groupId)")
        print(url)
        
        var request = URLRequest(url: url)
        do {
            let parameters : [String: Any] = [
                "groupId": parameter.groupId
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
