//
//  GetStartedViewController.swift
//  Chango v2
//
//  Created by Hosny Savage on 07/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation
import BWWalkthrough


class GetStartedViewController: UIViewController, BWWalkthroughPage {
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    weak open var delegate:BWWalkthroughViewControllerDelegate?
//    var bWalkthroughVC: BWWalkthroughViewController?
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        
    }
    
    override func viewDidLoad() {
//        bWalkthroughVC!.pageControl?.isHidden = true
        getStartedButton.roundCorners([.topRight], radius: 30)
    }
    
    
    @IBAction func getStarted(_ sender: Any) {
        print("GetStarted")
        
        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
        
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)    }
    
    
}
