//
//  VerifyChangePasswordVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 04/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import FirebaseAuth

class VerifyChangePasswordVC: BaseViewController {
    @IBOutlet weak var passwordTextField: ACFloatingTextfield!
    @IBOutlet weak var hideShowButton: UIButton!

    var iconClick = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func hideShowButtonAction(_ sender: UIButton) {
        
        if(iconClick == true) {

            sender.setTitle("HIDE", for: .normal)
            passwordTextField.isSecureTextEntry = false
            print("made visible so image invisible")
            
        } else {

            sender.setTitle("SHOW", for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
        
    }
    
    @IBAction func verifyPassword(_ sender: UIButton) {
        FTIndicator.init()
        FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
        FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
        //Firebase Auth
        var currentUser = Auth.auth().currentUser
        Auth.auth().signIn(withEmail: (currentUser?.email)!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                FTIndicator.dismissProgress()
                self.showAlert(withTitle: "Verify Password", message: "Invalid credentials")
                print(error?.localizedDescription)
            } else {
                FTIndicator.dismissProgress()
        let vc1: UpdatEmailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "upd") as! UpdatEmailViewController
        
        self.navigationController?.pushViewController(vc1, animated: true)
            }
        }
    }
    

}
