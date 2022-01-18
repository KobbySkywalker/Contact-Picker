//
//  MockNetworkManager.swift
//  Chango v2
//
//  Created by Hosny Savage on 08/08/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import Foundation
import Alamofire


class MockNetworkManager: AuthNetworkManagerProtocol {
    func register(parameter: SignUpParameter, completion: @escaping (DataResponse<RegisterResponse, AFError>) -> Void) {
        let registerResponse = RegisterResponse(email: "fitzafful@gmail.com", firstName: "Quesifol", lastName: "Afful", msisdn: "0544524329", authProviderId: "325234554t3f3", memberId: "345")
        
        let response = DataResponse<RegisterResponse, AFError>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: .success(registerResponse))
        
        let failedResponse = DataResponse<RegisterResponse, AFError>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: .failure(AFError.explicitlyCancelled))
        completion(failedResponse)
    }
    
}
