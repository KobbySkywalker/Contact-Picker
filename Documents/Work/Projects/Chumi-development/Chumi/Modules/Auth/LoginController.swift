//
//  LoginController.swift
//  Chumi
//
//  Created by Hosny Savage on 04/02/2021.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var hideNewPasswordButton: UIButton!
    var iconClick: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.setLeftPaddingPoints(10)
        newPasswordTextField.setLeftPaddingPoints(10)
    }
    @IBAction func hideShowNewPasswordButtonAction(_ sender: UIButton) {
        if iconClick == true {
            if case hideNewPasswordButton.imageView?.image = UIImage(named: "hideeyeicon") {
                sender.setImage(UIImage(named: "eyeicon"), for: .normal)
            }
            sender.setImage(UIImage(named: "hideeyeicon"), for: .normal)
            newPasswordTextField.isSecureTextEntry = false
            print("made visible image invisible")
        } else {
            if case hideNewPasswordButton.imageView?.image = UIImage(named: "eyeicon") {
                sender.setImage(UIImage(named: "hideeyeicon"), for: .normal)
            }
            sender.setImage(UIImage(named: "eyeicon"), for: .normal)
            newPasswordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
}
