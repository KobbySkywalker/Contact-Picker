//
//  LeftDrawerCell.swift
//  Chango v2
//
//  Created by Hosny Savage on 17/09/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

class LeftDrawerCell: UITableViewCell {

    @IBOutlet weak var drawerIcon: UIImageView!
    @IBOutlet weak var drawerCellName: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            self.drawerIcon.clipsToBounds = true
            self.drawerIcon.layer.masksToBounds = true
            self.drawerIcon.layer.borderWidth = 0.0

        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
}
