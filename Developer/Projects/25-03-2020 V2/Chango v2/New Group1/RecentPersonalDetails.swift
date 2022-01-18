//
//  RecentPersonalDetails.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 05/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class RecentPersonalDetails: UITableViewCell {

    @IBOutlet weak var campaignName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var campaignAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
