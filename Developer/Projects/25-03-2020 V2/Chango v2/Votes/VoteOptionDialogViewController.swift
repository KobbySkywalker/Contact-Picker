//
//  VoteOptionDialogViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 11/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class VoteOptionDialogViewController: BaseViewController {

    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var voteDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()
        // Do any additional setup after loading the view.
    }




}
