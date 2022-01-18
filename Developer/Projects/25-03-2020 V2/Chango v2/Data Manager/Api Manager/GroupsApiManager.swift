//
//  GroupsApiManager.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

class GroupsApiManager: GroupsDataProtocol {

    


    let apiClient: ApiClient
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
func getPrivateGroups(completionHandler: @escaping (Result<[PrivateResponse]>) -> Void) {
    print("before private")
let request = getPrivateGroupsRequest()
    print("before execute")
apiClient.execute(request: request) { (result: Result<ApiResponse<[ApiPrivateResponse]>>) in
    switch result {
    case let .success(response):
        print("success")
        let privateGroupResult = response.entity.map { return
            $0.pgr
        }
        completionHandler(.success(privateGroupResult))
    case let .failure(error):
        print("failure")
        completionHandler(.failure(error))
        }
    
    }
}
    
    
func getPublicGroups(parameter: PublicGroupsParameter, completionHandler: @escaping (Result<[PublicResponse]>) -> Void) {
    print("before public")
    let request = publicGroupsRequest(parameter: parameter)
    print("before public request")
    apiClient.execute(request: request) { (result: Result<ApiResponse<[ApiPublicResponse]>>) in
        switch result {
        case let .success(response):
            print("success")
            let publicGroupResult = response.entity.map { return
                $0.grp
            }
            completionHandler(.success(publicGroupResult))
        case let .failure(error):
            print("failure")
            completionHandler(.failure(error))
        }
    }
}
    
    
    func createPrivateGroup(parameter: CreateGroupParameter, completionHandler: @escaping (Result<GroupCreationResponse>) -> Void) {
        let request = createGroupRequest(parameter: parameter)
        apiClient.execute(request: request) { (result: Result<ApiResponse<ApiGroupCreationResponse>>) in
            switch result {
            case let .success(response):
                print("Success")
                let groupCreationResult = response.entity.groupCreationResponse
                completionHandler(.success(groupCreationResult))
            case let .failure(error):
                print("failure")
                completionHandler(.failure(error))
            }
        }
    }
    
    
    func joinGroup(parameter: JoinGroupParameter, completionHandler: @escaping (Result<JoinGroupResponse>) -> Void) {
        let request = joinGroupRequest(parameter: parameter)
        apiClient.execute(request: request) { (result: Result<ApiResponse<ApiJoinGroupResponse>>) in
            switch result {
            case let .success(response):
                print("Success")
                let joinGroupResult = response.entity.joinGroupResponse
                completionHandler(.success(joinGroupResult))
            case let .failure(error):
                print("failure")
                completionHandler(.failure(error))
            }
        }
    }



}
