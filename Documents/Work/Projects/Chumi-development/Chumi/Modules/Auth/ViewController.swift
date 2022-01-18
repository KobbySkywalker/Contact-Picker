//
//  ViewController.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var hideShowNewPassword: UIButton!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var hideShowConfirmPassword: UIButton!

    var iconClick: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.setLeftPaddingPoints(10)
        firstNameTextField.setLeftPaddingPoints(10)
        lastNameTextField.setLeftPaddingPoints(10)
        emailTextField.setLeftPaddingPoints(10)
        newPasswordTextField.setLeftPaddingPoints(10)
        confirmPasswordTextfield.setLeftPaddingPoints(10)
    }
    @IBAction func showNewPasswordButtonAction(_ sender: UIButton) {
        if iconClick == true {
            if case hideShowNewPassword.imageView?.image = UIImage(named: "hideeyeicon") {
                sender.setImage(UIImage(named: "eyeicon"), for: .normal)
            }
            sender.setImage(UIImage(named: "hideeyeicon"), for: .normal)
            newPasswordTextField.isSecureTextEntry = false
            print("made visible image invisible")
        } else {
            if case hideShowNewPassword.imageView?.image = UIImage(named: "eyeicon") {
                sender.setImage(UIImage(named: "hideeyeicon"), for: .normal)
            }
            sender.setImage(UIImage(named: "eyeicon"), for: .normal)
            newPasswordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    @IBAction func showConfirmPasswordButtonAction(_ sender: UIButton) {
        if iconClick == true {
            if case hideShowConfirmPassword.imageView?.image = UIImage(named: "hideeyeicon") {
                sender.setImage(UIImage(named: "eyeicon"), for: .normal)
            }
            sender.setImage(UIImage(named: "hideeyeicon"), for: .normal)
            confirmPasswordTextfield.isSecureTextEntry = false
            print("made visible image invisible")
        } else {
            if case hideShowConfirmPassword.imageView?.image = UIImage(named: "eyeicon") {
                sender.setImage(UIImage(named: "hideeyeicon"), for: .normal)
            }
            sender.setImage(UIImage(named: "eyeicon"), for: .normal)
            confirmPasswordTextfield.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
