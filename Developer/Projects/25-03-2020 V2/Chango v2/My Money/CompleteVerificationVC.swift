//
//  CompleteVerificationVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 16/02/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import Nuke

class CompleteVerificationVC: UIViewController {

    @IBOutlet weak var mobileNetworkLabel: UILabel!
    @IBOutlet weak var networkImage: UIImageView!
    
    @IBOutlet weak var verifyTextLabel: UILabel!
    var network: String = ""
    var networkIcon: String = ""
    var fromWalletView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileNetworkLabel.text = network
        networkImage.image = nil
        networkImage.image = UIImage(named: "defaultgroupicon")
        let url = URL(string: networkIcon)
        if(networkIcon == "<null>") || (networkIcon == "") {
            networkImage.image = UIImage(named: "defaultgroupicon")
        }else {
            Nuke.loadImage(with: url!, into: networkImage)
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okayButtonAction(_ sender: Any) {
        if fromWalletView == false {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: SettingsVC.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }else {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: PrivateGroupDashboardVC.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
    }
}
