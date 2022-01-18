//
//  MemberDataProtocol.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

typealias StringCompletionHandler = (_ response: Result<String>) -> Void

protocol MemberDataProtocol {
    func addMembers(parameter: AddMemberParameter, completionHandler: @escaping (_ members: Result<String>) -> Void)

    func getMembers(parameter: GetMembersParameter, completionHandler: @escaping (_ members: Result<[GetMemberResponse]>) -> Void)
}
