//
//  PublicGroupHeaderCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 10/10/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class PublicGroupHeaderCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
