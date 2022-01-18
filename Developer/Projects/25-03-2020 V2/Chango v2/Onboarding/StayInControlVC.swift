//
//  StayInControlVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/10/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import BWWalkthrough

class StayInControlVC: UIViewController, BWWalkthroughPage {

    weak open var delegate:BWWalkthroughViewControllerDelegate?
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func skipButton(_ sender: UIButton) {
        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
