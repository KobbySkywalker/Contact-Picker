//
//  SelectCountryViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit

class SelectCountryViewController: BaseViewController {

    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryPicker: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var blueView: UIView!
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    @IBOutlet weak var CountryName: UILabel!
    @IBOutlet weak var phoneCode: UILabel!
    
    var areaCode: String = "GH"
    var groupName: String = ""
    var groupDesc: String = ""
    var country_name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
//        countryFlag.layer.cornerRadius = 38.0
        countryFlag.layer.masksToBounds = true
        countryFlag.clipsToBounds = true
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!], for: .normal)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let currentLocale = Locale.current
        let englishLocale: NSLocale = NSLocale.init(localeIdentifier: "en_US")
        print(englishLocale)
        
        
        var theEnglishName: String? = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: currentLocale.identifier)
        if let theEnglishName = theEnglishName {

//            country_name = theEnglishName.sliceFrom(start: "(", to: ")")!
//            print(country_name)
//            self.CountryName.text = country_name
        }
        
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//            print(countryCode)
//            self.areaCode = countryCode
//            self.countryFlag.image = UIImage(named: countryCode)
////            self.phoneCode.text = countryCode.getCountryPhoneCode()
//        }
        
        
        
    }
    
    @IBAction func contryPickerButton(_ sender: UIButton) {
        let alert = UIAlertController(style: .alert, message: "Select Country")
        alert.addCreateGroupLocalePicker(type: .country) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.countryFlag.image = flag
            print((info?.flag)!)
            print((info?.code)!)
            
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
//        alert.show()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        let vc: NewGroupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "new") as! NewGroupViewController
        print(areaCode)
            vc.countryId = areaCode

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
