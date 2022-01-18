//
//  VerifyCodeVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import KWVerificationCodeView
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import FTIndicator

class VerifyCodeVC: BaseViewController {
    
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var verificationView: KWVerificationCodeView!
    
    var phone: String = ""
    var mail: String = ""
    var area: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var language: String = ""
    var password: String = ""
    var networkCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        verificationView.delegate = self as? KWVerificationCodeViewDelegate
        
        activateButton.layer.cornerRadius = 10.0
        resendCodeButton.layer.cornerRadius = 10.0
        
        let phoneUtil = NBPhoneNumberUtil()
        
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: nil)
            //        let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            area = phoneUtil.getRegionCode(for: phoneNumber)
            //
            //        NSLog("[%@]", formattedString)
            //        print("formatted string \(formattedString)")
            
            print("code: \(area)")
        }catch {
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func activateButtonAction(_ sender: UIButton) {
        
        if verificationView.hasValidCode() == false {
            let alert = UIAlertController(title: "Chango", message: "Please enter verification code.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {
            FTIndicator.showProgress(withMessage: "verifying")
            
            let verificationCode = "\(verificationView.getVerificationCode())"
            print("\(verificationView.getVerificationCode())")
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: verificationCode)
            let emailCredential = EmailAuthProvider.credential(withEmail: self.mail, password: self.password)
            let user = Auth.auth().currentUser
            user!.link(with: credential) { (authResult, error) in
                if let error = error {
                    // ...
                    FTIndicator.dismissProgress()
                    self.showAlert(title: "Chango", message: "\(error.localizedDescription)")
                    print("verified?: \(error.localizedDescription)")
                    return
                }
                self.getVerifyIDToken()
                
            }
        }
    }
    
    
    @IBAction func resendCodeButtonAction(_ sender: UIButton) {
        FTIndicator.showProgress(withMessage: "resending code")
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                FTIndicator.dismissProgress()
                print("sign up error: \(error.localizedDescription)")
                self.showAlert(title: "Chango", message: "\(error.localizedDescription)")
                return
            }
            FTIndicator.dismissProgress()
            self.showAlert(title: "Chango", message: "You will receive a phone code shortly.")
            // Sign in using the verificationID and the code sent to the user
            // ...
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
    
    
    //verify id
    func getVerifyIDToken(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print("error: \(error.localizedDescription)")
                return
            }
            print("id token: \(String(describing: idToken))")
            
            let def: UserDefaults = UserDefaults.standard
            def.set(idToken, forKey: "idToken")
            // Send token to your backend via HTTPS
            // ...
            print(self.mail)
//            let parameter: SignUpParameter = SignUpParameter(countryId: self.area, email: self.mail, firstName: self.firstName, lastName: self.lastName, msisdn: self.phone, language: "EN", registrationToken: idToken!)
//            print(parameter)
//            self.signupServer(signupParameter: parameter)
            
            let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
            
            vc.email = self.mail
            vc.phone = self.phone
            vc.areaCode = self.area
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func signupServer(signupParameter: SignUpParameter) {
        AuthNetworkManager.register(parameter: signupParameter) { (result) in
            self.parseSignupResponse(result: result)
        }
    }
    
    
    
    private func parseSignupResponse(result: DataResponse<RegisterResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            let fullName = "\(response.firstName) \(response.lastName)"
            print(fullName)
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            changeRequest?.commitChanges { (error) in
                // ...
                if error != nil {
                    FTIndicator.dismissProgress()
                    self.showAlert(title: "SIGN UP", message: String(describing: error?.localizedDescription))
                }else {
                    
                }
            }
            let usersRef = Database.database().reference().child("users")
            let userMemberId = usersRef.child("\(response.authProviderId)")
            userMemberId.child("authProviderId").setValue("\(response.authProviderId)")
            userMemberId.child("email").setValue("\(response.email)")
            userMemberId.child("memberId").setValue("\(response.memberId)")
            userMemberId.child("msisdn").setValue("\(response.msisdn)")
            userMemberId.child("name").setValue("\(response.firstName) \(response.lastName)")
            //user has signed up successfully
            UserDefaults.standard.set(true, forKey: "authenticated")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(withTitle: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
}

