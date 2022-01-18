//
//  AuthDataProtocol.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 20/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

protocol  AuthDataProtocol {
    func signup(parameter: SignupParameter, completionHandler: @escaping (_ users: Result<RegisterResponse>) -> Void)
    
    func memberExists(completionHandler: @escaping (_ users: Result<String>) -> Void)

}


