//
//  BankAddressCell.swift
//  Chango v2
//
//  Created by Hosny Savage on 06/07/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit

class BankAddressCell: UITableViewCell {

    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var bankAccount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.img.layer.cornerRadius = 5.0
        self.img.clipsToBounds = true
        self.img.layer.borderWidth = 0.8
        self.img.layer.masksToBounds = true
        self.img.layer.borderColor = UIColor(red: 50.0/255.0, green: 54.0/255.0, blue: 65.0/255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
