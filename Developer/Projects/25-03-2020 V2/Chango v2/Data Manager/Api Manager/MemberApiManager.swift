//
//  MemberApiManager.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

class MemberApiManager: MemberDataProtocol {


    


    let apiClient: ApiClient
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
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
    
    
    
    func addMembers(parameter: AddMemberParameter, completionHandler: @escaping StringCompletionHandler) {
        let request = addMemberRequest(parameter: parameter)
        apiClient.execute(request: request) { (result: Result<ApiResponse<StringResponse>>) in
            switch result {
            case let .success(response):
                print("success")
                let result = response.entity.string
                completionHandler(.success(result))
            case let .failure(error):
                print("failure")
                completionHandler(.failure(error))
            }
        }
    }
    
    
    func getMembers(parameter: GetMembersParameter, completionHandler: @escaping (Result<[GetMemberResponse]>) -> Void) {
        let request = getMembersApiRequest(parameter: parameter)
        apiClient.execute(request: request) { (result: Result<ApiResponse<[ApiGetMemberResponse]>>) in
            switch result {
            case let .success(response):
                print("success")
                let memberResult = response.entity.map { return
                    $0.mr
                }
                completionHandler(.success(memberResult))
            case let .failure(error):
                print("failure")
                completionHandler(.failure(error))
                
            }
        }
    }

    

}
