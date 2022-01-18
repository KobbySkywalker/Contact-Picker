//
//  SignupVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FTIndicator

class SignupVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: ACFloatingTextfield!
    @IBOutlet weak var password: ACFloatingTextfield!
    @IBOutlet weak var confirmPassword: ACFloatingTextfield!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var eyeImage: UIButton!
    @IBOutlet weak var eyeImage2: UIButton!
    
    var complete: CompleteRegistrationVC!
    var iconClick = true
    var iconClick2 = true
    var firstName = ""
    var lastName = ""
    var emailAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        
        signupButton.layer.cornerRadius = 10.0
        eyeImage.isHidden = true
        eyeImage2.isHidden = true
        password.delegate = self
        confirmPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        if emailAddress != "" {
            self.email.text = self.emailAddress
        }else {
            self.email.text = ""
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == password) {
            print("show icon")
            eyeImage.isHidden = false
        }else {
            eyeImage.isHidden = true
        }
        
        if (textField == confirmPassword) {
            eyeImage2.isHidden = false
        }else {
            eyeImage2.isHidden = true
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func termsConditionsButtonAction(_ sender: Any) {
        let vc: PrivacyPolicyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "privacy") as! PrivacyPolicyViewController
        vc.checkNavigation = 1
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func eyeButtonAction1(_ sender: UIButton) {
        if(iconClick == true) {
            if case eyeImage.imageView?.image = UIImage(named: "invisible") {
                //                sender.setImage(UIImage(named: "eye"), for: .normal)
            }
            password.isSecureTextEntry = false
            sender.setTitle("HIDE", for: .normal)
            print("made visible so image invisible")
            
        } else {
            if case eyeImage.imageView?.image = UIImage(named: "eye") {
                //                sender.setImage(UIImage(named: "invisible"), for: .normal)
            }
            sender.setTitle("SHOW", for: .normal)
            password.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func eyeButtonAction2(_ sender: UIButton) {
        if(iconClick2 == true) {
            if case eyeImage2.imageView?.image = UIImage(named: "invisible") {
                sender.setImage(UIImage(named: "eye"), for: .normal)
            }
            confirmPassword.isSecureTextEntry = false
            print("made visible so image invisible")
            
        } else {
            if case eyeImage2.imageView?.image = UIImage(named: "eye") {
                sender.setImage(UIImage(named: "invisible"), for: .normal)
            }
            confirmPassword.isSecureTextEntry = true
        }
        
        iconClick2 = !iconClick2
    }
    
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else {
            return false }
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}")
        
        
//        ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$
//        ^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d[^\\d\\w]]{8,}$
        
        print(passwordTest.evaluate(with: testStr))
        return passwordTest.evaluate(with: testStr)
    }
    
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        if ((email.text?.isEmpty)! && (password.text?.isEmpty)! && (confirmPassword.text?.isEmpty)!) {
            showAlert(title: "SIGN UP", message: "Please fill phone number field")
        }else if (password.text! != confirmPassword.text!) {
            showAlert(title: "SIGN UP", message: "Passwords do not match")
        }else if isValidPassword(testStr: password.text) == false {
            print("is not valid")
            showAlert(title: "SIGN UP", message: "Passwords should contain at least one digit, one alphabet, one capital letter & at least 8 characters.")
        }else {
            FTIndicator.showProgress(withMessage: "authenticating", userInteractionEnable: false)
            self.getVerifyIDToken()
            print(email.text!)
            Auth.auth().createUser(withEmail: self.email.text!, password: password.text!) { (authResult, error) in
                if error != nil {
                    FTIndicator.dismissProgress()
                    print(error)
                    
                    if error?.localizedDescription == "The email address is already in use by another account." {
                        let alert = UIAlertController(title: "SIGN UP", message: "\(error!.localizedDescription) would you like to login?", preferredStyle: .alert)
                        
                        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                        
                        let okAction = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction!) in
                            
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        let cancelAction = UIAlertAction(title: "No", style: .default) { (action: UIAlertAction!) in
                        }
                        alert.addAction(okAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        self.showAlert(withTitle: "SIGN UP", message: error!.localizedDescription)
                    }
                }else {
                    guard let user = authResult?.user else { return }
                    
                    let vc: AddMobileNumberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobile") as! AddMobileNumberVC
                    vc.email = self.email.text!
                    vc.password = self.password.text!
                    vc.firstName = self.firstName
                    vc.lastName = self.lastName
                    vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    //VERIFY ID
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
        }
    }
    
    
}
