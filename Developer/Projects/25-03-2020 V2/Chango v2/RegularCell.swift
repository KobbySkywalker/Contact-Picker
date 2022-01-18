//
//  RegularCell.swift
//  Chango v2
//
//  Created by Hosny Savage on 14/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit

class RegularCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var topValue: UILabel!
    @IBOutlet weak var bottomValue: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
