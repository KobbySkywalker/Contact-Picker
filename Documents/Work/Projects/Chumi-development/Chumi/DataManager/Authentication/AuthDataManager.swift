//
//  AuthDataManager.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation

class AuthDataManager {
    let webReqestManager = WebRequestManager()

    func login(email: String, password: String, completionHandler: @escaping CompletionHandler<LoginResponse>) {
        let parameters = ["grant_type": "password", "username": email, "password": password]
        webReqestManager.load(url: URLS.login, parameters: parameters, authentication: false, completion: completionHandler)
    }
}
