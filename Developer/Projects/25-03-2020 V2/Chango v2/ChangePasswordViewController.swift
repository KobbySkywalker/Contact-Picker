//
//  ChangePasswordViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var currentPassword: ACFloatingTextfield!
    @IBOutlet weak var newPassword: ACFloatingTextfield!
    @IBOutlet weak var confirmPassword: ACFloatingTextfield!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var hideShowButton: UIButton!
    @IBOutlet weak var hideShowNewButton: UIButton!
    @IBOutlet weak var hideShowConfirmButton: UIButton!
    
    var iconClick = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()

        changePassword.cornerRadius = 15.0
        
        disableDarkMode()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func hideShowButtonAction(_ sender: UIButton) {
        
        if(iconClick == true) {
            sender.setTitle("HIDE", for: .normal)
            currentPassword.isSecureTextEntry = false
            print("made visible so image invisible")
            
        } else {
            sender.setTitle("SHOW", for: .normal)
            currentPassword.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    
    @IBAction func hideShowNewButtonAction(_ sender: UIButton) {
        
        if(iconClick == true) {
            sender.setTitle("HIDE", for: .normal)
            newPassword.isSecureTextEntry = false
            print("made visible so image invisible")
            
        } else {
            sender.setTitle("SHOW", for: .normal)
            newPassword.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    
    @IBAction func hideShowConfirmButtonAction(_ sender: UIButton) {
        
        if(iconClick == true) {
            sender.setTitle("HIDE", for: .normal)
            confirmPassword.isSecureTextEntry = false
            print("made visible so image invisible")
            
        } else {
            sender.setTitle("SHOW", for: .normal)
            confirmPassword.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else {
            return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-z]).{8,}")
        
        print(passwordTest.evaluate(with: testStr))
        return passwordTest.evaluate(with: testStr)
    }

    @IBAction func changePasswordButtonAction(_ sender: UIButton) {
        
        if ((currentPassword.text?.isEmpty)! && (newPassword.text?.isEmpty)! && (confirmPassword.text?.isEmpty)!) {
            
            alertDialog(title: "Change Password", message: "Please fill empty fields.")
            
        }else if (currentPassword.text! == newPassword.text!) {
            
            alertDialog(title: "Change Password", message: "New password cannot be the same as old password. Please use a different password")
            
        }else if(!(newPassword.text! == confirmPassword.text!)){
            
            alertDialog(title: "Change Password", message: "New password does not match with re-entered password. Both should be the same")
            
        }else if isValidPassword(testStr: newPassword.text) == false {
            print("is not valid")
            
            alertDialog(title: "Change Password", message: "Passwords should contain at least one digit, one alphabet and at least 8 characters.")
            
        }else {
        let user = Auth.auth().currentUser
        if (!(user == nil)){
            let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: currentPassword.text!)

                user?.reauthenticate(with: credential, completion: { (result, error) in

            if error != nil{
                print(error!.localizedDescription)
                print("Error reauthenticating user")
                let alert = UIAlertController(title: "Change Password", message: String(describing: error?.localizedDescription), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }else{
                //change to new password
                Auth.auth().currentUser?.updatePassword(to: self.newPassword.text!) { (error) in
                    // ...
                    if error != nil {
                    let alert = UIAlertController(title: "Change Password", message: String(describing: error?.localizedDescription), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                
                    }else {
                        
                        let alert = UIAlertController(title: "Change Password", message: "Password changed successfully", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                            
                            self.navigationController?.popToRootViewController(animated: true)

                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                }
            })
        }
        
    }
    }


}
