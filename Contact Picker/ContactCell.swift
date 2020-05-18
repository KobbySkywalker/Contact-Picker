//
//  ContactCell.swift
//  Contact Picker
//
//  Created by Hosny Ben Savage on 12/11/2019.
//  Copyright © 2019 ITConsortium. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImage.layer.masksToBounds = true
        contactImage.clipsToBounds = true
        contactImage.layer.cornerRadius = 35.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
