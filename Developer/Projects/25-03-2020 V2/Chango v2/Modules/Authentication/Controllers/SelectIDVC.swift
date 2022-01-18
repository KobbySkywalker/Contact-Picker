//
//  SelectIDVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 12/03/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit

class SelectIDVC: BaseViewController, UIActionSheetDelegate {

    @IBOutlet weak var idNumberTextField: ACFloatingTextfield!
    @IBOutlet weak var selectIDButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var doBStack: UIStackView!
    @IBOutlet weak var doBButton: UIButton!
    
    var mobileNetworks = ["MTN", "Vodafone", "AirtelTigo", "Glo"]
    
    var idType: String = "passport"
    var email: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var settingsPage: Bool = false
    var countryId: String = ""
    var dOB: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        showChatController()
        if settingsPage {
            skipButton.isHidden = true
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if settingsPage {
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectIDButtonAction(_ sender: UIButton) {
        var alert = UIAlertController(title: "Choose ID Type", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose ID Type", message: "", preferredStyle: .actionSheet)
        
        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            print("you cancelled")

        }
        
        let passport: UIAlertAction = UIAlertAction(title: "Passport", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.idType = "passport"
            self.selectIDButton.setTitle("Passport", for: .normal)
            self.doBStack.isHidden = true
        }
        
        let nationalID: UIAlertAction = UIAlertAction(title: "National ID", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.idType = "National ID"
            self.selectIDButton.setTitle("National ID", for: .normal)
            self.doBStack.isHidden = true
        }
        
        let voterID: UIAlertAction = UIAlertAction(title: "Voter's ID", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.idType = "voters"
            self.selectIDButton.setTitle("Voter's ID", for: .normal)
            self.doBStack.isHidden = true
        }
        
        let driverLicense: UIAlertAction = UIAlertAction(title: "Driver's License", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.idType = "driver"
            self.selectIDButton.setTitle("Driver's License", for: .normal)
            self.doBStack.isHidden = false
            
        }
            
            let ssnit: UIAlertAction = UIAlertAction(title: "SSNIT", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.idType = "ssnit"
                self.selectIDButton.setTitle("SSNIT", for: .normal)
                self.doBStack.isHidden = true
                
            }
        
            actionSheetController.addAction(passport)
            if countryId == "GH" {
                actionSheetController.addAction(voterID)
                actionSheetController.addAction(ssnit)
                actionSheetController.addAction(driverLicense)
            }
            actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
            
            break
            default:
                alert = UIAlertController(title: "Choose ID Type", message: "", preferredStyle: UIAlertController.Style.alert)
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
                
            }
            
            let passport: UIAlertAction = UIAlertAction(title: "Passport", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.idType = "passport"
                self.selectIDButton.setTitle("Passport", for: .normal)
                self.doBStack.isHidden = true
            }
            
            let nationalID: UIAlertAction = UIAlertAction(title: "National ID", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.idType = "National ID"
                self.selectIDButton.setTitle("National ID", for: .normal)
                self.doBStack.isHidden = true
            }
            
            let voterID: UIAlertAction = UIAlertAction(title: "Voter's ID", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.idType = "voters"
                self.selectIDButton.setTitle("Voter's ID", for: .normal)
                self.doBStack.isHidden = true
            }
            
            let driverLicense: UIAlertAction = UIAlertAction(title: "Driver's License", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.idType = "driver"
                self.selectIDButton.setTitle("Driver's License", for: .normal)
                self.doBStack.isHidden = false
            }
                
                let ssnit: UIAlertAction = UIAlertAction(title: "SSNIT", style: .default) { action -> Void in
                    print("you just chose perpetual")
                    //display perpetual in button
                    self.idType = "ssnit"
                    self.selectIDButton.setTitle("SSNIT", for: .normal)
                    self.doBStack.isHidden = true
                    
                }
            
            alert.addAction(passport)
                if countryId == "GH" {
                    alert.addAction(voterID)
                    alert.addAction(ssnit)
                    alert.addAction(driverLicense)
                }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        if (idNumberTextField.text?.isEmpty == true) {
            showAlert(title: "Chango", message: "Please enter ID Number of the selected ID.")
        }else if (idType == "driver") && (dOB.isEmpty) {
                showAlert(title: "Chango", message: "Date of Birth cannot be empty.")
        }else {
        let vc: TakePictureVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "takepicture") as! TakePictureVC
            vc.email = email
            vc.password = password
            vc.firstName = firstName
            vc.lastName = lastName
            vc.idNumber = idNumberTextField.text!
            vc.idType = idType
            vc.settingsPage = settingsPage
            vc.doB = dOB
            if settingsPage {
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
            vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func selectDoBButton(_ sender: Any) {
        let maxDate = Date()
        
        switch UIDevice.current.screenType {
            
            
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            
            let alert = UIAlertController(style: .actionSheet, title: "Send Statement", message: "Select Date")
            alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: maxDate)
            { new in
                self.doBButton.setTitle(new.dateString(ofStyle: .medium), for: .normal)
                
                
                
                var day = ""
                var month = ""
                
                //MONTH
                //            var month = ""
                var monthValue = new.month
                if(monthValue < 10){
                    month = "0\(monthValue)"
                }else{
                    month = "\(monthValue)"
                }
                
                //DAY
                var dayValue = new.day
                if(dayValue < 10){
                    day = "0\(dayValue)"
                }else{
                    day = "\(dayValue)"
                }
                
                let year = new.year
                let dateString = "\(year)-\(month)-\(day)"
                
                
                
                self.dOB = dateString
                print(self.dOB)
                
            }
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel))

            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            self.dOB = result
            print("date: \(result)")
            formatter.dateStyle = .medium
            print("resu: \(result)")
            self.doBButton.setTitle(date.dateString(ofStyle: .medium), for: .normal)
            
            self.present(alert, animated: true, completion: nil)
            
        default:
            
            let alert = UIAlertController(style: UIAlertController.Style.alert, title: "Send Statement", message: "Select Date")
                    
            alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: maxDate)
            { new in
                self.doBButton.setTitle(new.dateString(ofStyle: .medium), for: .normal)
                
                
                
                var day = ""
                var month = ""
                
                //MONTH
                //            var month = ""
                var monthValue = new.month
                if(monthValue < 10){
                    month = "0\(monthValue)"
                }else{
                    month = "\(monthValue)"
                }
                
                //DAY
                var dayValue = new.day
                if(dayValue < 10){
                    day = "0\(dayValue)"
                }else{
                    day = "\(dayValue)"
                }
                
                let year = new.year
                let dateString = "\(year)-\(month)-\(day)"
                
                
                
                self.dOB = dateString
                print(self.dOB)
                
            }
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel))
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            self.dOB = result
            print("date: \(result)")
            formatter.dateStyle = .medium
            print("resu: \(result)")
            self.doBButton.setTitle(date.dateString(ofStyle: .medium), for: .normal)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
            let vc: AddMobileNumberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobile") as! AddMobileNumberVC
            vc.email = email
            vc.password = password
            vc.firstName = firstName
            vc.lastName = lastName
            vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func selectNetwork() {
        var alert = UIAlertController(title: "Choose Network", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Network", message: "", preferredStyle: .actionSheet)
        
        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            print("you cancelled")

        }
            for item in mobileNetworks {
            let network: UIAlertAction = UIAlertAction(title: item, style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.idType = item
                print("selected: \(item)")
                self.selectIDButton.setTitle("Passport", for: .normal)
                }
                actionSheetController.addAction(network)
            }
            actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
            
            break
            default:
                alert = UIAlertController(title: "Choose Network", message: "", preferredStyle: UIAlertController.Style.alert)
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
                
            }
                
                for item in mobileNetworks {
                let network: UIAlertAction = UIAlertAction(title: item, style: .default) { action -> Void in
                    print("you just chose perpetual")
                    //display perpetual in button
                    self.idType = item
                    print("selected: \(item)")
                    self.selectIDButton.setTitle("Passport", for: .normal)
                    }
                    alert.addAction(network)
                }
                alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
