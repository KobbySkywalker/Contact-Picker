//
//  PolicyCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 09/12/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class PolicyCell: UITableViewCell {

    @IBOutlet weak var policyName: UILabel!
    @IBOutlet weak var policyStatement: UILabel!
    @IBOutlet weak var editPolicyView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
