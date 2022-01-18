//
//  NewGroupViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit

class NewGroupViewController: BaseViewController {

    
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var groupDescription: ACFloatingTextfield!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var blueView: UIView!
    
    var nameGroup: String = ""
    var areaCode: String = ""
    var countryId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 15)!], for: .normal)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if (groupName.text?.isEmpty)! {
            showAlert(title: "Create Group", message: "Please enter a group name.")
        }else if (groupDescription.text?.isEmpty)!{
                showAlert(title: "Create Group", message: "Group description cannot be empty")
        }else if (groupName.text!.count > 50) {
            showAlert(title: "Create Campaign", message: "Group Name should not exceed 50 characters.")
        }else if groupDescription.text?.count < 10 {
        showAlert(title: "Create Campaign", message: "Group description should be more than 10 characters")
    }else {
            let vc: GroupSettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupsettings") as! GroupSettingsViewController
                vc.groupDesc = groupDescription.text!
                vc.groupName = groupName.text!
                vc.countryId = countryId
            self.navigationController?.pushViewController(vc, animated: true)
            }
//        else {
//                    let vc: AboutGroupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "about") as! AboutGroupViewController
//                    vc.areaCode = areaCode
//                    vc.groupName = groupName.text!
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
