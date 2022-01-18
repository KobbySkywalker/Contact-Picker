//
//  AuthApiRequests.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 20/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation
import UIKit

//let BASE_URL = "http://156.0.234.85:8082/api/"
let BASE_URL = "http://ec2-34-251-218-203.eu-west-1.compute.amazonaws.com:8082/api/"
let api_token = UserDefaults.standard.string(forKey: "idToken")


//GET NETWORK CODE
struct getNetworkCodeApiRequest: ApiRequest {
    let parameter: NetworkParameter
    
    var urlRequest: URLRequest {
        
        let url: URL! = URL(string: BASE_URL+"getNetworks?countryId=\(parameter.countryId)"
        )
        print(url)
        
        var request = URLRequest(url: url)
        do {
            let parameters : [String: Any] = [
                "countryId": parameter.countryId
            ]
            let jsonData1 = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            request.httpBody = jsonData1
            print(jsonData1)
        }catch{
            print(error)
        }
        return request
    }
    
}

//SIGN UP
struct signupApiRequest: ApiRequest {
    let parameter: SignupParameter
    
    var urlRequest: URLRequest {
        
        let url: URL! = URL(string: BASE_URL+"createMember")
        print(url)
        print("\(String(describing: api_token))")


        
        var request = URLRequest(url: url)
        do {
            let parameters : [String: Any] = [
                "networkCode": parameter.networkCode,
                "email": parameter.email,
                "firstName": parameter.firstName,
                "lastName": parameter.lastName,
                "msisdn": parameter.msisdn,
                "language": parameter.language,
                "registrationToken": parameter.registrationToken
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


//MEMBER EXISTS

struct memberExistsRequest: ApiRequest {
    
    var urlRequest: URLRequest {
        
        let url: URL! = URL(string: BASE_URL+"memberExists")
        print(url)
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(api_token!)", forHTTPHeaderField: "idToken")
        request.httpMethod = "GET"
        return request
    }
}




