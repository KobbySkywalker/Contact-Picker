//
//  PasswordReset.swift
//  GENPAY
//
//  Created by Administrator on 02/02/2018.
//  Copyright © 2018 ITC. All rights reserved.
//

import UIKit

class PasswordReset: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumber.delegate = self
        
        disableDarkMode()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        // Do any additional setup after loading the view.
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PasswordReset: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
