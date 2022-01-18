//
//  RecurringPaymentCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 02/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class RecurringPaymentCell: UIViewController {

    @IBOutlet weak var oTP: ACFloatingTextfield!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == oTP) {
            print("show icon")
            showBtn.isHidden = false
        }else {
            showBtn.isHidden = true
        }
    }


    @IBAction func showHideButton(_ sender: UIButton) {
        
        if(iconClick == true) {

            sender.setTitle("HIDE", for: .normal)
            oTP.isSecureTextEntry = false
            print("made visible so image invisible")
            
        } else {

            sender.setTitle("SHOW", for: .normal)
            oTP.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    

}
