//
//  DeactivateAccountVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 13/08/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit

class DeactivateAccountVC: UIViewController {

    @IBOutlet weak var passwordTextField: ACFloatingTextfield!
    @IBOutlet weak var deactivationInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func hideShowButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func deactivateButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
