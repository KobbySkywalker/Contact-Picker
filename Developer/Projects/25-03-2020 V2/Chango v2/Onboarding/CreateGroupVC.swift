//
//  CreateGroupVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 07/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation
import BWWalkthrough


class CreateGroupVC: UIViewController, BWWalkthroughPage {
    
    weak open var delegate:BWWalkthroughViewControllerDelegate?
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        
    }
    
    
    @IBAction func skipButton(_ sender: Any) {
        
        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


