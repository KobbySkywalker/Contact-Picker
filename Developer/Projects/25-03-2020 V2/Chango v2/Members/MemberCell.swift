//
//  MemberCell.swift
//  Kyama1
//
//  Created by Hosny Ben Savage on 12/30/16.
//  Copyright © 2016 ITC. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var memberStatus: UILabel!
    @IBOutlet weak var msisdn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImage.clipsToBounds = true
		self.userImage.layer.masksToBounds = true
        self.userImage.layer.borderWidth = 0.0
//        self.userImage.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        self.userImage.layer.cornerRadius = 10.0
        //self.userImage.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
