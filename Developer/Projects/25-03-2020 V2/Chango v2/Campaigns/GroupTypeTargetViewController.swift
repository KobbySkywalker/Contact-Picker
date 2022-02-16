//
//  GroupTypeTargetViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire

class GroupTypeTargetViewController: BaseViewController {
    
    @IBOutlet weak var groupTypeTargetView: UIView!
    @IBOutlet weak var groupTypeView: UIStackView!
    @IBOutlet weak var campaignTarget: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectDateStack: UIStackView!
    @IBOutlet weak var perpetualCampaignButton: UIButton!
    @IBOutlet weak var temporaryCampaignButton: UIButton!
    @IBOutlet weak var perpetualCampaignCheck: UIImageView!
    @IBOutlet weak var temporaryCampaignCheck: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var selectDateButton: UIButton!
    
    private var alertStyle: UIAlertController.Style = .actionSheet
    
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var campaign: GetGroupCampaignsResponse!
    var group = ""
    var chosenGroupType: String = ""
    var mainViewController: MainMenuTableViewController!
    var campaignsViewController: CampaignsViewController!
    var campaignDescription: String = ""
    var campaignName: String = ""
    var endDate = ""
    var sendDate = ""
    var endDateString = ""
    var campType: String = ""
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        currencyLabel.text = currency
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func perpetualCampaignButtonAction(_ sender: Any) {
        perpetualCampaignButton.backgroundColor = UIColor(hexString: "#05406F")
        temporaryCampaignButton.backgroundColor = UIColor(hexString: "#228CC7")
        selectDateStack.isHidden = true
        perpetualCampaignCheck.isHidden = false
        temporaryCampaignCheck.isHidden = true
        campType = "perpetual"
    }
    
    @IBAction func temporaryCampaignButtonAction(_ sender: Any) {
        temporaryCampaignButton.backgroundColor = UIColor(hexString: "#05406F")
        perpetualCampaignButton.backgroundColor = UIColor(hexString: "#228CC7")
        perpetualCampaignCheck.isHidden = true
        temporaryCampaignCheck.isHidden = false
        selectDateStack.isHidden = false
        campType = "temporary"
    }
    
    @IBAction func selectDateButtonAction(_ sender: Any) {
        let alert = UIAlertController(style: self.alertStyle, title: "Create Campaign", message: "Select Date")
        let minDate = Date()
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: minDate, maximumDate: nil)
        { new in
            self.selectDateButton.setTitle(new.dateString(ofStyle: .medium), for: .normal)
            var day = ""
            var month = ""
            var hour = ""
            var min = ""
            var sec = ""
            //MONTH
            //            var month = ""
            let monthValue = new.month
            if(monthValue < 10){
                month = "0\(monthValue)"
            }else{
                month = "\(monthValue)"
            }
            //DAY
            let dayValue = new.day
            if(dayValue < 10){
                day = "0\(dayValue)"
            }else{
                day = "\(dayValue)"
            }
            //HOUR
            let hourValue = new.hour
            if(hourValue < 10){
                hour = "0\(hourValue)"
            }else{
                hour = "\(hourValue)"
            }
            //MINUTES
            let minuteValue = new.minute
            if(minuteValue < 10){
                min = "0\(minuteValue)"
            }else{
                min = "\(minuteValue)"
            }
            //SECONDS
            let secondValue = new.second
            if(secondValue < 10){
                sec = "0\(secondValue)"
            }else{
                sec = "\(secondValue)"
            }

            let year = new.year
            let dateString = "\(year)-\(month)-\(day)"
            
            self.endDate = dateString
            self.endDateString = dateString
            print(self.endDate)
            print("dateString: \(dateString)")
        }
        alert.addAction(title: "Done", style: .cancel)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        self.endDate = result
        print("date: \(result)")
        formatter.dateStyle = .medium
        print("resu: \(result)")
        self.selectDateButton.setTitle(date.dateString(ofStyle: .medium), for: .normal)

        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as! UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func createCampaignButtonAction(_ sender: Any) {
        if (campType == "") {
            showAlert(title: "Create Campaign", message: "Please select a campaign type.")
        }else if ((campType == "temporary") && selectDateButton.titleLabel?.text == nil) {
            showAlert(title: "Create Campaign", message: "Please select a date to end campaign")
        }else if campaignTarget.text!.isEmpty {
            showAlert(title: "Create Campaign", message: "Please enter a target amount for this campaign. Amount cannot be zero.")
        }else if Int(campaignTarget.text!) == 0 {
            showAlert(title: "Create Campaign", message: "Amount cannot be zero. Please enter a valid amount.")
        }else {
            FTIndicator.showProgress(withMessage: "loading")
            print(self.endDate)
            print(campaignName)
            print(group)
            let parameter: CreateCampaignParameter = CreateCampaignParameter(amountReceived: "0",campaignId: "", campaignName: campaignName, description: campaignDescription, campaignType: campType, end: self.endDate, groupId: group, start: "0", target: campaignTarget.text!)
            print(campType)
            print(self.endDate)
            print(campaignName)
            self.createCampaign(createCampaignParameter: parameter)
        }
    }
    
    //GROUP CAMPAIGN
    func createCampaign(createCampaignParameter: CreateCampaignParameter) {
        AuthNetworkManager.createCampaign(parameter: createCampaignParameter) { (result) in
            self.parseCreateCampaignResponse(result: result)
        }
    }
    
    private func parseCreateCampaignResponse(result: DataResponse<CreateGroupCampaignResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CampaignsViewController.self){
                        (controller as! CampaignsViewController).groupCreated = true
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else if result.response?.statusCode == 401 {
                let alert = UIAlertController(title: "Chango", message: "Campaign creation failed. Member has been disabled in this group ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: CampaignsViewController.self){
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else if result.response?.statusCode == 226 {
                print("226 now")
                let alert = UIAlertController(title: "Chango", message: "Campagin limit reached. You can only have 10 active campaigns at a time.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: CampaignsViewController.self){
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else if result.response?.statusCode == 403 {
                print("403 now")
                let alert = UIAlertController(title: "Chango", message: "A campaign already exists with this name.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: CampaignsViewController.self){
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
}
