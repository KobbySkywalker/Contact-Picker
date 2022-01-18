//
//  WalletCell.swift
//  Chango v2
//
//  Created by Hosny Savage on 07/04/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit

class WalletCell: UITableViewCell {

    @IBOutlet weak var walletName: UILabel!
    @IBOutlet weak var walletNumber: UILabel!
    @IBOutlet weak var verifiedCardLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var rectanglularView: UIView!
    @IBOutlet weak var walletOptions: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImage.layer.borderWidth = 0.2
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.cornerRadius = 15
//        backgroundImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        rectanglularView.layer.borderWidth = 0.0
        rectanglularView.clipsToBounds = true
        rectanglularView.layer.cornerRadius = 15
//        rectanglularView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        backgroundImage.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
