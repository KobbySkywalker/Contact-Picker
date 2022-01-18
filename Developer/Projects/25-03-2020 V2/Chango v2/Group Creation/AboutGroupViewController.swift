//
//  AboutGroupViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit

class AboutGroupViewController: BaseViewController {

    @IBOutlet weak var groupDescription: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var blueView: UIView!
    
    var groupName: String = ""
    var areaCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
}

    @IBAction func nextButtonAction(_ sender: UIButton) {
        if (groupDescription.text?.isEmpty)!{
            showAlert(title: "Create Group", message: "Group description cannot be empty")
    }else {
        let vc: GroupSettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupsettings") as! GroupSettingsViewController
            vc.groupDesc = groupDescription.text!
            vc.groupName = self.groupName
            vc.countryId = areaCode
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
