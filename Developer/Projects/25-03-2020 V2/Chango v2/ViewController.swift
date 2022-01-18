//
//  ViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/10/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import BWWalkthrough

class ViewController: BaseViewController, BWWalkthroughViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showWalkThrough()
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
    
    func walkthroughCloseButtonPressed() {
        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC

        self.present(vc, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)

        print("close walk through")
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    

}

