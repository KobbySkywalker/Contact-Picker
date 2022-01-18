//
//  FirebaseService.swift
//  Chango v2
//
//  Created by Hosny Savage on 16/08/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import TwitterKit
import FBSDKLoginKit

typealias FirebaseAuthResult = AuthDataResult

protocol FirebaseHelperProtocol {
    func getCredentialFromGoogle(with googleUser: GIDGoogleUser) -> AuthCredential
    func getCredentialFromApple(with idToken: String, nonce: String) -> AuthCredential
    func getCredentialFromTwitter(session: TWTRSession) -> AuthCredential
    func getCredentialFromFacebook() -> AuthCredential
    func loginUser(credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void)
}

class FirebaseHelper: FirebaseHelperProtocol {
    
    func loginUser(credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credential) { (result, error) in
            completion(result, error)
        }
    }
    
    func getCredentialFromGoogle(with googleUser: GIDGoogleUser) -> AuthCredential {
        let authentication = googleUser.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        return credential
    }
    
    func getCredentialFromApple(with idToken: String, nonce: String) -> AuthCredential {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        return credential
    }

    func getCredentialFromTwitter(session: TWTRSession) -> AuthCredential {
        let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
        return credential
        }
    
    func getCredentialFromFacebook() -> AuthCredential {
        let credential = FacebookAuthProvider
          .credential(withAccessToken: AccessToken.current!.tokenString)
        print("cred: \(credential)")
        return credential
    }

}
