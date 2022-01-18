//
//  SendContributionsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 07/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation
import BWWalkthrough


class SendContributionsVC: UIViewController, BWWalkthroughPage {
    
    weak open var delegate:BWWalkthroughViewControllerDelegate?
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
    }
    
    @IBAction func skipButton(_ sender: Any) {
        
        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
        func showWalkThrough(){
            
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
            
            let page_one = stb.instantiateViewController(withIdentifier: "walk1")
            
            let page_two = stb.instantiateViewController(withIdentifier: "walk2")
            
            
            let page_three = stb.instantiateViewController(withIdentifier: "walk3")
            
            let page_four = stb.instantiateViewController(withIdentifier: "walk4")
            
            let page_five = stb.instantiateViewController(withIdentifier: "walk5")
            
            let page_six = stb.instantiateViewController(withIdentifier: "walk6")
            
            
            //Attach the pages to the master
            walkthrough.delegate = self as? BWWalkthroughViewControllerDelegate
    //        walkthrough.add(viewController: page_one)
            walkthrough.add(viewController: page_three)
            walkthrough.add(viewController: page_two)
            walkthrough.add(viewController: page_four)
            walkthrough.add(viewController: page_five)
            walkthrough.add(viewController: page_six)

            
            
            self.present(walkthrough, animated: true, completion: nil)
        }
    
}
