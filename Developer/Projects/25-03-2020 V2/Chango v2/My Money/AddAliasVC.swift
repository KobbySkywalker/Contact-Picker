//
//  AddAliasVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 07/04/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit

class AddAliasVC: UIViewController {

    @IBOutlet weak var cardAliasTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardAliasTextField.delegate = self
        
        disableDarkMode()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
    }

    @objc func endEditing() {
        view.endEditing(true)
    }

}

extension AddAliasVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
