//
//  AddRandomMessageChatViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class AddRandomMessagesChatViewController: DemoChatViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(
            title: "Add message",
            style: .plain,
            target: self,
            action: #selector(addRandomMessage)
        )
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc
    private func addRandomMessage() {
        self.dataSource.addRandomIncomingMessage()
    }
}
