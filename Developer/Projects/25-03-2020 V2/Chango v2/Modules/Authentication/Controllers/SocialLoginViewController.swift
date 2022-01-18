//
//  SocialLoginViewController.swift
//  
//
//  Created by Hosny Savage on 25/08/2021.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import TwitterKit
import FBSDKLoginKit
import AuthenticationServices


class SocialLoginViewController: BaseViewController, GIDSignInDelegate, AuthUIDelegate, LoginButtonDelegate {

    @IBOutlet weak var fbButton: FBButton!

    var firebaseHelper: FirebaseHelperProtocol? = FirebaseHelper()
    var cryptHelper = CryptHelper()
    let fbLoginButton = FBLoginButton()
    var nonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        showChatController()
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["public_profile", "email"]
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //yo
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //yo
        if let error = error {
            showAlert(title: "Login", message: error.localizedDescription)
            return
        }
        print("no error")
        firebaseFacebookLogin()
    }
    
    func twitterButtonTapped() {
        firebaseTwitterLogin()
    }
    
    func googleButtonTapped() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func facebookButtonTapped(){
//        loginButton.delegate = self
    }
    
    @available(iOS 13.0, *)
    func appleButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = get256Sha()

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        startLoader()
        if error != nil {
            self.showAlert(title: "Error", message: "Could not sign in. Please try again later.")
            return
        }
//        cancelLoader()
        print("try login")
        firebaseGoogleLogin(with: user)
    }
    
    func firebaseGoogleLogin(with googleUser: GIDGoogleUser) {
        let credential = firebaseHelper?.getCredentialFromGoogle(with: googleUser)
        firebaseHelper?.loginUser(credential: credential!) { (result, error) in
            self.signedIn(error: error, result: result)
        }
    }
    
    func firebaseAppleLogin(with idToken: String) {
        let credential = firebaseHelper?.getCredentialFromApple(with: idToken, nonce: nonce!)
        firebaseHelper?.loginUser(credential: credential!) { (result, error) in
            self.signedIn(error: error, result: result)
        }
    }
    
    func firebaseTwitterLogin() {
        TWTRTwitter.sharedInstance().logIn { session, error in
            if (error != nil) {
                print("nnil")
                self.showAlert(title: "Chango", message: error?.localizedDescription ?? "Error. Please try again")
            }else {
                let credential = self.firebaseHelper?.getCredentialFromTwitter(session: session!)
                self.firebaseHelper?.loginUser(credential: credential!, completion: { result, error in
                    self.signedIn(error: error, result: result)
                })
            }
        }
        
    }
    
    func firebaseFacebookLogin() {
        print("facebook")
        let credential = firebaseHelper?.getCredentialFromFacebook()
        firebaseHelper?.loginUser(credential: credential!, completion: { result, error in
            print("login user")
            self.signedIn(error: error, result: result)
        })
    }
    
    @available(iOS 13, *)
    func get256Sha() -> String {
        self.nonce = cryptHelper.randomNonceString()
        return cryptHelper.sha256(self.nonce!)
    }
    
    func signedIn(error: Error?, result: FirebaseAuthResult?) {
        var errorMessage: String?
        print("signed in")
        if error != nil {
            print("there is an error")
            if let errorCode = AuthErrorCode(rawValue: error!._code) {
                switch errorCode {
                case.wrongPassword:
                    errorMessage = "You entered an invalid password please try again!"
                case .weakPassword:
                    errorMessage = "You entered a weak password. Please choose another!"
                case .emailAlreadyInUse:
                    errorMessage = "An account with this email already exists. Please log in!"
                case .accountExistsWithDifferentCredential:
                    errorMessage = "This account exists with different credentials"
                default:
                    errorMessage = "Unexpected error \(errorCode.rawValue) please try again!"
                }
            }
        }
        if let message = errorMessage {
            print("show error alert")
            self.showAlert(title: "Error", message: message)
            return
        }
        // get verified token
        print("verifyToken")
        getVerifyIDToken()
    }

    @IBAction func googleSignIn(_ sender: UIButton) {
//        googleButtonTapped()
        firebaseTwitterLogin()
    }
    
    @available(iOS 13.0, *)
    @IBAction func appleSignIn(_ sender: UIButton) {
//        appleButtonTapped()
        print("tapped")
        fbButtonAction(fbButton)
    }
    
    @IBAction func fbButtonAction(_ sender: FBButton) {
        print("nnothig here")
        var loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { results, error in
            print("\(results), \(error)")
            if let error = error {
                self.showAlert(title: "Login", message: error.localizedDescription)
                return
            }
            print("no error")
            self.firebaseFacebookLogin()
        }
    }
}



@available(iOS 13.0, *)
extension SocialLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}

@available(iOS 13.0, *)
extension SocialLoginViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            firebaseAppleLogin(with: idTokenString)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}
