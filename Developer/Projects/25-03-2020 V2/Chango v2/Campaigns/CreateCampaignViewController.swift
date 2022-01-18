//
//  CreateCampaignViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator

class CreateCampaignViewController: BaseViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var calenderButton: UIButton!
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    @IBOutlet weak var selectDate: UIButton!
    @IBOutlet weak var campaignView: UIView!
    
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var campaign: GetGroupCampaignsResponse!
    var group = ""
    var campaignDescription: String = ""
    var campaignName: String = ""
    var campType: String = ""
    var campTarget: String = ""
    var endDate = ""
    var sendDate = ""
    var endDateString = ""
    var mainViewController: MainMenuTableViewController!
    //    var month = ""
    //    var day = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        campaignView.layer.cornerRadius = 10.0
        campaignView.layer.shadowRadius = 5.0
        campaignView.layer.shadowColor = UIColor.black.cgColor
        campaignView.layer.shadowRadius = 8.0
        campaignView.layer.shadowOpacity = 0.2
        createButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func calenderPickerButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(style: self.alertStyle, title: "Create Campaign", message: "Select Date")
        let minDate = Date()
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: minDate, maximumDate: nil)
        { new in
            self.selectDate.setTitle(new.dateString(ofStyle: .medium), for: .normal)
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
        self.selectDate.setTitle(date.dateString(ofStyle: .medium), for: .normal)

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
    
    @IBAction func createButtonAction(_ sender: UIButton) {
        if (selectDate.titleLabel?.text == "SELECT DATE") {
            showAlert(title: "Create Campaign", message: "Please select a date to end campaign.")
        }else {
            FTIndicator.showProgress(withMessage: "loading")
            print(campTarget)
            print(campType)
            print(self.endDate)
            print(campaignName)
            print(group)
            let parameter: CreateCampaignParameter = CreateCampaignParameter(amountReceived: "0",campaignId: "0", campaignName: campaignName, description: campaignDescription, campaignType: campType, end: self.endDate, groupId: group, start: "0", target: campTarget)
            print(campTarget)
            print(campType)
            print(self.endDate)
            print(campaignName)
            self.createCampaign(createCampaignParameter: parameter)
        }
    }
    
    
    @IBAction func calenderIconButtonAction(_ sender: UIButton) {
        
    }
    
    //CREATE CAMPAIGN
    func createCampaign(createCampaignParameter: CreateCampaignParameter) {
        AuthNetworkManager.createCampaign(parameter: createCampaignParameter) { (result) in
            self.parseCreateCampaignResponse(result: result)
        }
    }
    
    private func parseCreateCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            let alert = UIAlertController(title: "Chango", message: "Campaign created successfully.", preferredStyle: .alert)
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
        case .failure( _):
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
                let alert = UIAlertController(title: "Chango", message: "Campagin limit reached. You can only have 5 active campaigns at a time.", preferredStyle: .alert)
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
            } else if result.response?.statusCode == 403 {
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
            } else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
}
