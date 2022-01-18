//
//  GroupsDataProtocol.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

protocol GroupsDataProtocol {
    func getPrivateGroups(completionHandler: @escaping (_ groups: Result<[PrivateResponse]>) -> Void)
    
    func getPublicGroups(parameter: PublicGroupsParameter, completionHandler: @escaping (_ groups: Result<[PublicResponse]>) -> Void)
    
    func createPrivateGroup(parameter: CreateGroupParameter, completionHandler: @escaping (_ group: Result<GroupCreationResponse>) -> Void)
}
