//
//  InvitesCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit

class InvitesCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        groupImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
