//
//  InvitationDialogViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 07/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class InvitationDialogViewController: BaseViewController {

    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var termsConditions: UILabel!
    @IBOutlet weak var cashoutPolicy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()
        
        groupImage.layer.borderWidth = 0.5
        groupImage.borderColor = UIColor.lightGray
        groupImage.layer.cornerRadius = 40.0
        groupImage.clipsToBounds = true
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
