//
//  AuthApiManager.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 20/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

class AuthApiManager: AuthDataProtocol {
    
    let apiClient: ApiClient
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func signup(parameter: SignupParameter, completionHandler: @escaping (Result<RegisterResponse>) -> Void) {
        let request = signupApiRequest(parameter: parameter)
        apiClient.execute(request: request) { (result: Result<ApiResponse<ApiRegisterResponse>>) in
            switch result {
            case let .success(response):
                print("success")
                let userResult = response.entity.registerResponse
                completionHandler(.success(userResult))
            case let .failure(error):
                print("failure")
                completionHandler(.failure(error))
            }
        }
    }
    
    func getNetworkCode(parameter: NetworkParameter, completionHandler: @escaping (Result<[NetworkCode]>) -> Void) {
        let request = getNetworkCodeApiRequest(parameter: parameter)
        apiClient.execute(request: request) { (result: Result<ApiResponse<[ApiNetworkCode]>>) in
            switch result {
            case let .success(response):
                print("Success")
                let userResult = response.entity.map { return
                    $0.network
                }
                completionHandler(.success(userResult))
            case let .failure(error):
                print("failure")
                completionHandler(.failure(error))
            }
        }
    }
    
    
    struct StringResponse: InitializableWithData {
        
        var string: String
        
        init(data: Data?) throws {
            if(!(data != nil)) {
                throw NSError.createParseError()
            }
            if let returnData = String(data: data!, encoding: .utf8){
                string = returnData
                return
            }
            
            throw NSError.createParseError()
        }
    }
    
    
    func memberExists(completionHandler: @escaping StringCompletionHandler) {
    
        let request = memberExistsRequest()
        apiClient.execute(request: request) { (result: Result<ApiResponse<StringResponse>>) in
            switch result {
            case let .success(response):
                let result = response.entity.string
                completionHandler(.success(result))
            case let .failure(error):
                print("failure")
                completionHandler(.failure(error))
            }
        }
    }
    
}
