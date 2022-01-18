//
//  SendStatementViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import FirebaseAuth
import Alamofire
import Nuke

class SendStatementViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var emailAddress: ACFloatingTextfield!
    @IBOutlet weak var fromDate: UIButton!
    @IBOutlet weak var toDate: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var statementLabel: UILabel!
    @IBOutlet weak var statementSwitch: UISwitch!
    @IBOutlet weak var withoutAmountLabel: UILabel!
    @IBOutlet weak var fileFormatSwitch: UISwitch!

    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    let textField = UITextField()
    var endDate = ""
    var startDate = ""
    var groupId: String = ""
    var groupIconPath: String = ""
    var groupName: String = ""
    var created: String = ""
    var statementType: String = ""
    var withoutAmount: Bool = false
    var campaignStatement: Bool = false
    var fileFormat: String = "PDF"
    var campaignId: String = ""
    var memberId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        emailAddress.delegate = self
        emailAddress.text = user?.email
        groupNameLabel.text = groupName
        createdLabel.text = created
        
        retrieveMember()
        
        if (groupIconPath == "<null>") || (groupIconPath == nil) || (groupIconPath == ""){
            groupImage.image = UIImage(named: "defaultgroupicon")
                    print(groupIconPath)
            groupImage.contentMode = .scaleAspectFit
            
        }else {
            groupImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupImage)
        }
        
        showChatController()
        disableDarkMode()
        
        if statementType == "GROUP" || statementType == "CAMPAIGN" {
            if campaignStatement {
                statementLabel.text = "Send Campaign Statement"
                self.title = "Send Campaign Statement"
            }else {
            statementLabel.text = "Send Group Statement"
            self.title = "Send Group Statement"
            }
        }else {
            statementLabel.text = "Send Personal Statement"
            self.title = "Send Personal Statement"
            statementSwitch.isHidden = true
            withoutAmountLabel.isHidden = true
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func withoutAmountSwitchBtn(_ sender: Any) {
        if statementSwitch.isOn {
            print("on")
            withoutAmount = true
        }else {
            print("off")
            withoutAmount = false
        }
    }

    @IBAction func chooseFormatSwitchBtn(_ sender: Any) {
        if fileFormatSwitch.isOn {
            fileFormat = "CSV"
        }else {
            fileFormat = "PDF"
        }
    }

    
    @IBAction func fromDateAction(_ sender: UIButton) {
        let maxDate = Date()
        
        switch UIDevice.current.screenType {
            
            
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:

            let alert = UIAlertController(style: self.alertStyle, title: "Send Statement", message: "Select Date")

        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: maxDate)
        { new in
            self.fromDate.setTitle(new.dateString(ofStyle: .medium), for: .normal)
            
            
            
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
            
            
            
            self.startDate = dateString
            print(self.startDate)
            print("new: \(new)")
            
        }
        alert.addAction(title: "Done", style: .cancel)
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            self.startDate = result
            print("date: \(result)")
            formatter.dateStyle = .medium
            print("resu: \(result)")
            self.fromDate.setTitle(date.dateString(ofStyle: .medium), for: .normal)
        
        self.present(alert, animated: true, completion: nil)
            
        default:
            
            let alert = UIAlertController(style: UIAlertController.Style.alert, title: "Send Statement", message: "Select Date")

            alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: maxDate)
                   { new in
                       self.fromDate.setTitle(new.dateString(ofStyle: .medium), for: .normal)
                       
                       
                       
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
                       
                       
                       
                       self.startDate = dateString
                       print(self.startDate)
                       print("new: \(new)")
                       
                   }
                   alert.addAction(title: "Done", style: .cancel)
                       
                       let date = Date()
                       let formatter = DateFormatter()
                       formatter.dateFormat = "yyyy-MM-dd"
                       let result = formatter.string(from: date)
                       self.startDate = result
                       print("date: \(result)")
                       formatter.dateStyle = .medium
                       print("resu: \(result)")
                       self.fromDate.setTitle(date.dateString(ofStyle: .medium), for: .normal)
                   
                   self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func toDateAction(_ sender: UIButton) {
        let maxDate = Date()
        
        switch UIDevice.current.screenType {
            
            
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            
            let alert = UIAlertController(style: .actionSheet, title: "Send Statement", message: "Select Date")
            alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: maxDate)
            { new in
                self.toDate.setTitle(new.dateString(ofStyle: .medium), for: .normal)
                
                
                
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
                
                
                
                self.endDate = dateString
                print(self.endDate)
                
            }
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel))

            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            self.endDate = result
            print("date: \(result)")
            formatter.dateStyle = .medium
            print("resu: \(result)")
            self.toDate.setTitle(date.dateString(ofStyle: .medium), for: .normal)
            
            self.present(alert, animated: true, completion: nil)
            
        default:
            
            let alert = UIAlertController(style: UIAlertController.Style.alert, title: "Send Statement", message: "Select Date")
                    
            alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: maxDate)
            { new in
                self.toDate.setTitle(new.dateString(ofStyle: .medium), for: .normal)
                
                
                
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
                
                
                
                self.endDate = dateString
                print(self.endDate)
                
            }
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel))
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            self.endDate = result
            print("date: \(result)")
            formatter.dateStyle = .medium
            print("resu: \(result)")
            self.toDate.setTitle(date.dateString(ofStyle: .medium), for: .normal)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

    @IBAction func sendButtonAction(_ sender: Any) {
        if endDate == "" || startDate == "" {
            
            let alert = UIAlertController(title: "Chango", message: "Please select a date.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {

                if statementType == "MEMBER" {
                    FTIndicator.showProgress(withMessage: "sending statement")
                    if withoutAmount == true {
                        let parameter: GetCampaignStatementParameter = GetCampaignStatementParameter(email: emailAddress.text!, end: endDate, campaignId: campaignId, groupId: groupId, start: startDate, format: fileFormat, statementType: "CAMPAIGN_CONTRIBUTORS", memberId: memberId)
                        sendCampaignStatement(getCampaignStatementParameter: parameter)
                    }else {
                        let parameter: GetCampaignStatementParameter = GetCampaignStatementParameter(email: emailAddress.text!, end: endDate, campaignId: campaignId, groupId: groupId, start: startDate, format: fileFormat, statementType: "MEMBER_SEG", memberId: memberId)
                        sendCampaignStatement(getCampaignStatementParameter: parameter)
                    }
                }else {
                    FTIndicator.showProgress(withMessage: "sending statement")
                    if withoutAmount == true {
                        let parameter: GetStatementParameter = GetStatementParameter(email: emailAddress.text!, end: endDate, groupId: groupId, start: startDate, format: fileFormat, statementType: "GROUP_CONTRIBUTORS", memberId: memberId)
                        sendStatement(getStatementParameter: parameter)
                    }else {
                        let parameter: GetStatementParameter = GetStatementParameter(email: emailAddress.text!, end: endDate, groupId: groupId, start: startDate, format: fileFormat, statementType: "GROUP_SEGREGATED", memberId: memberId)
                        sendStatement(getStatementParameter: parameter)
                    }
            }
        }
    }
    
    
    func sendStatement(getStatementParameter: GetStatementParameter) {
        AuthNetworkManager.getStatement(parameter: getStatementParameter) { (result) in
            FTIndicator.dismissProgress()
            print("result: \(result)")

                let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                    self.navigationController?.popViewController(animated: true)
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
        }
    }

    func sendCampaignStatement(getCampaignStatementParameter: GetCampaignStatementParameter) {
        AuthNetworkManager.getCampaignStatement(parameter: getCampaignStatementParameter) { (result) in
            FTIndicator.dismissProgress()
            print("result: \(result)")

                let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                    self.navigationController?.popViewController(animated: true)

                }

                alert.addAction(okAction)

                self.present(alert, animated: true, completion: nil)
        }
    }

    func retrieveMember() {
        AuthNetworkManager.retrieveMember() { (result) in
            self.parseRetrieveMemberResponse(result: result)
        }
    }

    private func parseRetrieveMemberResponse(result: DataResponse<RetrieveMemberResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            memberId = response.memberId
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
}
