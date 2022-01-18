//
//  RecurringCollectionCell.swift
//  Chango v2
//
//  Created by Hosny Savage on 22/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit

class RecurringCollectionCell: UICollectionViewCell {

    @IBOutlet weak var checkBox: VKCheckbox!
    @IBOutlet weak var recurringItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBox.checkboxValueChangedBlock = {
            isOn in
            self.checkBox.vBorderColor = UIColor(hexString: "#228CC7")
            self.checkBox.backgroundColor = UIColor(hexString: "#228CC7")
            self.checkBox.color = .white
            print("Checkbox is \(isOn ? "ON" : "OFF")")

            if self.checkBox.isOn() {

            }else{
                self.checkBox.backgroundColor = UIColor.white
            }
        }
    }

}
