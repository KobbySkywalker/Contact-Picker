//
//  PublicCampaignTableViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 30/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import PopupDialog



class PublicCampaignTableViewController: BaseTableViewController {
    
    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var amountRaisedLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var guaranteeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var campaignStatusLabel: String = ""
    var campaignEndDateLabel: String = ""
    var dateCreated: String = ""
    var targetAmount: Double = 0.0
    var amountReceived: Double = 0.0
    var publicGroupDescriptionLabel: String = ""
    var campaignId: String = ""
    var groupId: String = ""
    var campaignName: String = ""
    var campaignDescription: String = ""
    var publicGroup: GroupResponse!
    var publicContact: [PublicContact] = []
    var phoneNumber: String = ""
    var location: String = ""
    var email: String = ""
    var userNumber: String = ""
    var userNetwork: String = ""
    var msisdn: String = ""
    var campaignType: String = ""
    var carouselVC: CarouselPageViewController!
    var campaignExpiry: String = ""
    var alias: String = ""
    var maxContributionPerDay: Double = 0.0
    var currency: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(publicGroup.groupName)"
        
        self.memberNetwork()
        disableDarkMode()
        
        let largeNumber = targetAmount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))

        
        let attributedText = NSMutableAttributedString(string: "\(publicGroup.countryId.currency) \(formattedNumber!)" ?? "\(targetAmount)", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25.0)!])
        
        attributedText.append(NSAttributedString(string: " target", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 13.0)!]))
        

        campaignNameLabel.text = campaignName
        amountRaisedLabel.text = "\(publicGroup.countryId.currency) \(amountReceived.formatPoints()) raised"
        endDateLabel.text = campaignEndDateLabel
        createdDateLabel.text = dateCreated
        descriptionLabel.text = campaignDescription
        print("type: \(campaignType)")
        if campaignType == "perpetual" {
            progressBar.isHidden = true
            targetAmountLabel.isHidden = true
        }else {
            targetAmountLabel.attributedText = attributedText
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 2.5
        progressBar.progress = Float(amountReceived/targetAmount)
        }
        
        if campaignEndDateLabel == "" {
            endDateLabel.isHidden = true
            endDateLabel.isHidden = true
            
        }else {
            print(campaignEndDateLabel)
            endDateLabel.text = "Ends \(campaignEndDateLabel)"
            
        }
        
        if dateCreated == "" {
            createdDateLabel.isHidden = true
            createdDateLabel.isHidden = true
        }else {
            
            createdDateLabel.text = "Created on \(dateCreated)"
        }
        
        guaranteeLabel.text = "\(publicGroup.groupName) has been vetted & approved by Access Bank Ghana"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ⓘ", style: .plain, target: self, action: #selector(clickOnButton))
        
        let parameter : CampaignImagesParameter = CampaignImagesParameter(id: campaignId)
        self.campaignImages(campaignImageParameter: parameter)
           
        let param: AppConfigurationParameter = AppConfigurationParameter(countryId: publicGroup.countryId.countryId!)
        appConfiguration(appConfigurationParameter: param)
    }
    
    
    @objc func clickOnButton() {
        
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let param: PublicContactParameter = PublicContactParameter(groupId: publicGroup.groupId)
        self.publicContact(publicContactParameter: param)
    }
    

    @IBAction func contributeNowButton(_ sender: UIButton) {
        
        let vc: PublicContributionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publiccontribute") as! PublicContributionViewController
        
        vc.campaignId = campaignId
        vc.publicGroup = publicGroup
//        vc.campaignName = campaignName
//        vc.userNumber = userNumber
//        vc.userNetwork = userNetwork
//        vc.msisdn = msisdn
//        vc.campaignExpiry = campaignExpiry
//        vc.maxContribution = Int(maxContributionPerDay)
//        vc.currency = currency
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        let shareText = "Share this campaign with your friends"
        let secondActivityItem : NSURL = NSURL(string: "https://changoapp.com/\(alias)")!
        
        //        if let image = UIImage(named: "myImage") {
        let vc = UIActivityViewController(activityItems: [shareText, secondActivityItem], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = sender
        self.present(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            print("case \(indexPath.section)")
        if indexPath.row == 5 {
            print("report")
            showReportCampaignDialog(animated: true)
        }
            
        default:
            print("default")
        }
    }
    
    
    //REPORT CAMPAIGN DIALOG
    func showReportCampaignDialog(animated: Bool = true) {
        
        //create a custom view controller
        let reportCampaignVC = ReportCampaignVC(nibName: "ReportCampaignVC", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: reportCampaignVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
        }
        CancelButton.appearance().titleColor = UIColor.lightGray
        
        //create second button
        let buttonTwo = DefaultButton(title: "SEND REPORT", height: 60) {
            if(reportCampaignVC.campaignReport.textColor == UIColor.lightGray){
                let alert = UIAlertController(title: "Report this Campaign", message: "Please enter a report", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                }
                
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else {


            }
        }
        DefaultButton.appearance().titleColor = UIColor(red: 49/255, green: 102/255, blue: 216/255, alpha: 1)
        
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }

       
       //APP CONFIGURATION
       func appConfiguration(appConfigurationParameter: AppConfigurationParameter) {
           AuthNetworkManager.appConfiguration(parameter: appConfigurationParameter) { (result) in
               self.parseAppConfigurationResponse(result: result)
           }
       }
       
       
       private func parseAppConfigurationResponse(result: DataResponse<AppConfiguratonResponse, AFError>){
           FTIndicator.dismissProgress()
           switch result.result {
           case .success(let response):
               
            maxContributionPerDay = Double(response.maxPublicContribution!)
               currency = response.currency!
               
           break
           case .failure(_ ):
               
               if result.response?.statusCode == 400 {
                   
                   baseTableSessionTimeout()
                   
               }else {
                   let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                   
                   let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                       
                   }
                   
                   alert.addAction(okAction)
                   
                   self.present(alert, animated: true, completion: nil)
               }
           }
       }
    
    
    func campaignImages(campaignImageParameter: CampaignImagesParameter) {
        AuthNetworkManager.campaignImages(parameter: campaignImageParameter) { (result) in
            //            self.parseGetCampaignBalance(result: result)
            switch result.result {
                
            case .success(let response):

//            print(result)
//            print("Result: \(result)")
                
//                campaignImageArray = response
                
                SwiftEventBus.post("images", sender: imageEvent(groupImages_: response))


                
            default:
                print("default")
                
            }
             
        }
        
    }
    
    //PUBLIC CONTACT
    func publicContact(publicContactParameter: PublicContactParameter) {
        AuthNetworkManager.publicContact(parameter: publicContactParameter) { (result) in
            self.parsePublicContactResponse(result: result)
        }
    }
    
    private func parsePublicContactResponse(result: DataResponse<[PublicContact], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("contact: \(response)")
            
            for item in response {
                publicContact.append(item)
                if item.contactType == "email"{
                    email = item.contactValue
                    print("email: \(email)")
                }else if item.contactType == "phone" {
                    phoneNumber = item.contactValue
                    print("phoneNumber: \(phoneNumber)")
                }else if item.contactType == "address" {
                    location = item.contactValue
                    print("location: \(location)")
                }
            }
            
            let vc: PublicGroupContactsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contact") as! PublicGroupContactsViewController
            
            vc.groupNamed = publicGroup.groupName
            vc.groupImage = publicGroup.groupIconPath!
            vc.publicGroup = publicGroup
            vc.mail = email
            vc.phoneNumber = phoneNumber
            vc.location = location
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                baseTableSessionTimeout()
                
            }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func memberNetwork() {
        AuthNetworkManager.memberNetwork { (result) in
            self.parsememberNetworkResponse(result: result)
        }
    }
    
    
    private func parsememberNetworkResponse(result: DataResponse<MemberNetworkResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            userNumber = response.msisdn
            userNetwork = response.network
            
            msisdn = userNumber
            msisdn.removeFirst()
            

            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                
                baseTableSessionTimeout()
                
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
    
}

