//
//  LoginViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 09/10/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable
class DesignableButton: UIButton {
}


class LoginViewController: BaseViewController {
    


    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()

//        signUpButton.setTitle("", for: .normal)
//        signUpButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
//        signUpButton.setTitle("Need an account? SIGN UP", for: .normal)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


import UIKit

extension UIButton {
    @IBInspectable
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}
