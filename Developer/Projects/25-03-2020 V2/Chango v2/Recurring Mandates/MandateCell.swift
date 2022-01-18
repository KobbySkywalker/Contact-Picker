//
//  MandateCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 06/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class MandateCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var debitDate: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
