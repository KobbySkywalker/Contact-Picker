//
//  VerifyNumberController.swift
//  Chumi
//
//  Created by Hosny Savage on 04/02/2021.
//

import UIKit

class VerifyNumberController: UIViewController {

    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var countryFlagButton: UIButton!
    @IBOutlet weak var phoneCodeLabel: UILabel!
    private var alertStyle: UIAlertController.Style = .alert
    var country_name: String = ""
    var areaCode: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func countryPickerButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: self.alertStyle)
        alert.addLocalePicker(type: .country) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.countryFlagButton.setImage(UIImage(named: "\(String(describing: flag))"), for: .normal)
            print((info?.flag)!)
            self.phoneCodeLabel.text = info?.phoneCode
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in}
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
