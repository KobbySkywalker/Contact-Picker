//
//  AdminCampaignSettingsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 09/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import Nuke

class AdminCampaignSettingsVC: BaseViewController {

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var amountRaisedLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var campaignStatusLabel: UILabel!
    @IBOutlet weak var startCampaignStack: UIStackView!
    @IBOutlet weak var startCampaignButton: UIButton!
    @IBOutlet weak var stopCampaignStack: UIStackView!
    @IBOutlet weak var stopCampaignButton: UIButton!
    @IBOutlet weak var pauseCampaignStack: UIStackView!
    @IBOutlet weak var pauseCampaignButton: UIButton!
    @IBOutlet weak var extendCampaignStack: UIStackView!
    @IBOutlet weak var ExtendCampaignButton: UIButton!
    
    var campaignName: String = ""
    var campaignDesc: String = ""
    var campaignId: String = ""
    var currency: String = ""
    var campaignStatus: String = ""
    var campaignInfo: GetGroupCampaignsResponse!
    var groupId: String = ""
    var dateEnded: String = ""
    
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    
    override func viewDidLoad() {
            super.viewDidLoad()
            showChatController()
            disableDarkMode()
            
            campaignNameLabel.text = campaignName
            campaignImage.image = UIImage(named: "defaulticon")
            campaignImage.contentMode = .scaleAspectFit
            amountRaisedLabel.text = "\(currency) \(formatNumber(figure: campaignInfo.amountReceived!))"
            targetAmountLabel.text = "\(currency) \(formatNumber(figure: campaignInfo.target!))"
            createdDateLabel.text = "Created on \(dateConversion(dateValue: campaignInfo.created))"
        if "\(campaignInfo.status!)" == "running" {
            campaignStatus = "running"
            campaignStatusLabel.text = "Active"
        }
        if campaignStatus == "running" {
            pauseCampaignStack.isHidden = false
            startCampaignStack.isHidden = true
        }else if campaignStatus == "pause" {
            campaignStatusLabel.text = "Pause"
            pauseCampaignStack.isHidden = true
            startCampaignStack.isHidden = false
        }else {
            campaignStatusLabel.text = "Stopped"
            pauseCampaignStack.isHidden = true
            startCampaignStack.isHidden = false
        }
        
        
        
            var endDate = Date()
            let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
    //        endDate = formatter.date(from: self.campaignInfo.end!)!
            
            
            
            formatter.dateStyle = DateFormatter.Style.medium
            _ = formatter.string(from: endDate as! Date)
            daysLeftLabel.text = dateEnded
            
            print("end: \(campaignInfo.end) \(campaignInfo.created)")
            
            progressBar.progress = Float(campaignInfo.amountReceived!/campaignInfo.target!)

        if campaignInfo.campaignType == "perpetual"{
            ExtendCampaignButton.isEnabled = false
            ExtendCampaignButton.isHighlighted = false
            daysLeftLabel.text = "Perpetual"
            }
        }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func stopCampaignButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Stop Campaign", message: "Are you sure you want to stop this campaign?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { (action: UIAlertAction!) in
            FTIndicator.showProgress(withMessage: "stopping")
            let parameter : EndCampaignParameter = EndCampaignParameter(campaignId: self.campaignInfo.campaignId)
            self.endCampaign(endCampaignParameter: parameter)
        }
        let noAction = UIAlertAction(title: "NO", style: .default) { (action: UIAlertAction!) in
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pauseCampaignButtonAction(_ sender: Any) {
        if campaignStatus == "running" {
            let alert = UIAlertController(title: "Pause Campaign", message: "Are you sure you want to pause this campaign?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES", style: .default) { (action: UIAlertAction!) in
                let parameter : PauseCampaignParameter = PauseCampaignParameter(campaignId: self.campaignInfo.campaignId)
                self.pauseCampaign(pauseCampaignParameter: parameter)
            }
            let noAction = UIAlertAction(title: "NO", style: .default) { (action: UIAlertAction!) in
            }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func extendCampaignButtonAction(_ sender: Any) {
        let vc: ExtendCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "extend") as! ExtendCampaignVC
        
        vc.campaignId = campaignInfo.campaignId
        vc.groupId = groupId
//        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func startCampaignButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Resume Campaign", message: "Are you sure you want to resume this campaign?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { (action: UIAlertAction!) in
            let parameterr: StartCampaignParameter = StartCampaignParameter(campaignId: self.campaignInfo.campaignId)
            self.startCampaign(startCampaignParameter: parameterr)
        }
        let noAction = UIAlertAction(title: "NO", style: .default) { (action: UIAlertAction!) in
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //START CAMPAIGN
        func startCampaign(startCampaignParameter: StartCampaignParameter) {
            AuthNetworkManager.startCampaign(parameter: startCampaignParameter) { (result) in
                self.parseStartCampaignResponse(result: result)
            }
        }
        
        private func parseStartCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print("response: \(response)")
//                pauseCampaignButton.setImage(UIImage(named: "paused"), for: .normal)
                campaignStatus = "running"
                campaignStatusLabel.text = "Active"
                startCampaignStack.isHidden = true
                pauseCampaignStack.isHidden = false
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CampaignsViewController.self){
                        (controller as! CampaignsViewController).groupCreated = true
                        break
                    }
                }
                break
            case .failure(let error):
                if result.response?.statusCode == 400 {
                    sessionTimeout()
                }else {
                    showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
                }
            }
        }
        
        
        //PAUSE CAMPAIGN
        func pauseCampaign(pauseCampaignParameter: PauseCampaignParameter) {
            AuthNetworkManager.pauseCampaign(parameter: pauseCampaignParameter) { (result) in
                self.parsePauseCampaignResponse(result: result)
            }
        }
        
        private func parsePauseCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print("response: \(response)")
//                startCampaignButton.setImage(UIImage(named: "played"), for: .normal)
                campaignStatus = "pause"
                campaignStatusLabel.text = "Pause"
                startCampaignStack.isHidden = false
                pauseCampaignStack.isHidden = true
    //            groupCreated = true
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CampaignsViewController.self){
                        (controller as! CampaignsViewController).groupCreated = true
    //                    self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
                break
            case .failure(let error):
                if result.response?.statusCode == 400 {
                    sessionTimeout()
                }else {
                    showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
                }
            }
        }
        
        //END CAMPAIGN
        func endCampaign(endCampaignParameter: EndCampaignParameter) {
            AuthNetworkManager.endCampaign(parameter: endCampaignParameter) { (result) in
                self.parseEndCampaignResponse(result: result)
            }
        }
        
        private func parseEndCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print("response: \(response)")
                let alert = UIAlertController(title: "Chango", message: "This campaign has been stopped successfully.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: CampaignsViewController.self){
                            (controller as! CampaignsViewController).groupCreated = true
                            break
                        }
                    }
                self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                break
            case .failure( _):
                if result.response?.statusCode == 400 {
                    sessionTimeout()
                }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        //EXTEND CAMPAIGN
        func extendCampaign(extendCampaignParameter: ExtendCampaignParameter) {
            AuthNetworkManager.extendCampaign(parameter: extendCampaignParameter) { (result) in
                self.parseExtendCampaignResponse(result: result)
            }
        }
        
        private func parseExtendCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print("response: \(response)")
                let alert = UIAlertController(title: "Chango", message: "Campaign has been extended successfully.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                    let formatter = DateFormatter()
                    formatter.locale = Locale.autoupdatingCurrent
                    formatter.timeZone = NSTimeZone(name: "UTC") as? TimeZone
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let date = formatter.date(from: response.end!)
                    
                    formatter.dateStyle = DateFormatter.Style.medium
                    _ = formatter.string(from: date!)
                    let dates = timeFromDate(date!)
                    
//                    self.endCampaignDate.setTitle(dates, for: .normal)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
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
