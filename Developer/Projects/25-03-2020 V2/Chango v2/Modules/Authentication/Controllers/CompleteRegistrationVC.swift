//
//  CompleteRegistrationVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FTIndicator
import Alamofire

class CompleteRegistrationVC: BaseViewController {
    
    @IBOutlet weak var firstName: ACFloatingTextfield!
    @IBOutlet weak var lastName: ACFloatingTextfield!
    @IBOutlet weak var nextButton: UIButton!
    
    var email: String = ""
    var password: String = ""
    var phone: String = ""
    var areaCode: String = ""
    var country_name: String = ""
    var first: String = ""
    var last: String = ""
    var networkCode: String = ""
    var changeName: Int = 0
    var failedSignUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        print("phoneNumber: \(phone)")
        print("area Code: \(areaCode)")
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if ((firstName.text?.isEmpty)! && (lastName.text?.isEmpty)!) {
            showAlert(title: "SIGN UP", message: "Please fill empty fields.")
        } else if changeName == 1 {
            let fullName = "\(firstName.text!) \(lastName.text!)"
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
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else {
            
            //            if failedSignUp == true {
            //                FTIndicator.showProgress(withMessage: "loading")
            //                let idToken = UserDefaults.standard.string(forKey: "idToken")
            //                let parameter: SignUpParameter = SignUpParameter(countryId: areaCode, email: email, firstName: firstName.text!, lastName: lastName.text!, msisdn: phone, language: "EN", registrationToken: idToken!)
            //                print(parameter)
            //                self.signupServer(signupParameter: parameter)
            //            }
            //            else {
            //                //DISPLAY NAME
            //                FTIndicator.showProgress(withMessage: "loading")
            //                let fullName = "\(firstName.text!) \(lastName.text!)"
            //                print(fullName)
            //
            //                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            //                changeRequest?.displayName = fullName
            //                changeRequest?.commitChanges { (error) in
            //                    // ...
            //                    if error != nil {
            //                        FTIndicator.dismissProgress()
            //                        self.showAlert(title: "SIGN UP", message: String(describing: error?.localizedDescription))
            //                    }else {
            //
            //                    }
            //                }
            //                let vc: VerifyCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "code") as! VerifyCodeVC
            
            //                let vc: SignupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "up") as! SignupVC
            ////                vc.phone = self.phone
            ////                vc.area = self.areaCode
            ////                vc.mail = self.email
            ////                vc.password = self.password
            ////                vc.language = self.areaCode
            //                vc.firstName = firstName.text!
            //                vc.lastName = lastName.text!
            //                //vc.networkCode = self.networkCode
            //                print("text: \(email), \(password), \(firstName.text!), \(lastName.text!), \(phone)")
            //                vc.modalPresentationStyle = .fullScreen
            //                self.present(vc, animated: true, completion: nil)
            
            FTIndicator.showProgress(withMessage: "loading")
            let idToken = UserDefaults.standard.string(forKey: "idToken")
            let parameter: SignUpParameter = SignUpParameter(countryId: areaCode, email: email, firstName: firstName.text!, lastName: lastName.text!, msisdn: phone, language: "EN", registrationToken: idToken!)
            self.signupServer(signupParameter: parameter)

            let registerParams: RegisterParameter = RegisterParameter(countryId: areaCode, email: email, firstName: firstName.text!, lastName: lastName.text!, msisdn: phone, language: "EN", registrationToken: idToken!, userIconPath: "")
            print(registerParams)
            self.registerUser(registerParameter: registerParams)

        }
//        }
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
            //add display name
            let fullName = "\(firstName.text!) \(lastName.text!)"
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
            print("update users table")
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

    // NEW REGISTER
    func registerUser(registerParameter: RegisterParameter) {
        AuthNetworkManager.registerUser(parameter: registerParameter) { (result) in
            self.parseRegisterUserResponse(result: result)
        }
    }



    private func parseRegisterUserResponse(result: DataResponse<RegisterUserResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
            //add display name
            let fullName = "\(firstName.text!) \(lastName.text!)"
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
