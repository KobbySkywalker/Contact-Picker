//
//  PublicGroupsDashboardViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import Nuke

class PublicGroupsDashboardViewController: BaseViewController {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var target: UILabel!
    @IBOutlet weak var timeframe: UILabel!


    var publicContribution: DefaultCampaignResponse!
    var publicGroup: GroupResponse!
    var myPublicGroupContributions: [Content] = []
    var campaignId: String = ""
    var publicContact: [PublicContact] = []
    var phoneNumber: String = ""
    var location: String = ""
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        
        self.navigationItem.title = publicGroup.groupName
        self.groupDescription.text = publicGroup.description
        print(publicGroup)
        

        
        if (publicGroup.groupIconPath == "<null>") || (publicGroup.groupIconPath == nil) || (publicGroup.groupIconPath == ""){
            groupImage.image = UIImage(named: "people")
            groupImage.contentMode = .scaleAspectFit
            
        }else {
            groupImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: publicGroup.groupIconPath!)!, into: groupImage)
        }
        
        
        //        Default Contributions
//                let parameter: defaultCampaignParameter = defaultCampaignParameter(groupId: publicGroup.groupId)
//        print(parameter)
//                self.defaultCampaign(defaultCampaignParameter: parameter)
        


    }
    

    @IBAction func contributionButtonAction(_ sender: UIButton) {
        let vc: PublicGroupContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contributions") as! PublicGroupContributionsViewController
        
        vc.publicGroup = publicGroup
        vc.campaignId = publicGroup.defaultCampaignId ?? ""
        vc.publicContributions = publicContribution
        vc.publicGroupContrbutions = myPublicGroupContributions
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func campaignsButtonAction(_ sender: Any) {

        let vc: PublicCampaignsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publiccampaigns") as! PublicCampaignsViewController
        
        vc.publicGroup = publicGroup
        self.navigationController?.pushViewController(vc, animated: true)


    }
    
    @IBAction func contactsButtonAction(_ sender: UIButton) {
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let param: PublicContactParameter = PublicContactParameter(groupId: publicGroup.groupId)
        self.publicContact(publicContactParameter: param)
    }
    
    
    @IBAction func feedbackButtonAction(_ sender: UIButton) {
        let vc: FeebackViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedback") as! FeebackViewController
        vc.campaignId = publicGroup.defaultCampaignId ?? ""
        print(campaignId)
        vc.publicGroup = publicGroup
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func defaultCampaign(defaultCampaignParameter: defaultCampaignParameter){
        AuthNetworkManager.defaultCampaign(parameter: defaultCampaignParameter) { (result) in
            self.parseDefaultCampaignResponse(result: result)
        }
    }
    
    private func parseDefaultCampaignResponse(result: DataResponse<DefaultCampaignResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            
            publicContribution = response
            campaignId = response.campaignId!
            print(campaignId)
            
            let parameter: memberContributionsParameter = memberContributionsParameter(campaignId: campaignId)
            self.memberContributions(memberContributionsParameters: parameter)
            
            break
        case .failure(let error):
            
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
    
    
    // MEMBER CONTRIBUTIONS
    func memberContributions(memberContributionsParameters: memberContributionsParameter) {
        AuthNetworkManager.memberContributions(parameter: memberContributionsParameters) { (result) in
            self.parseMemberContributionsResponse(result: result)
        }
    }
    
    private func parseMemberContributionsResponse(result: DataResponse<[Content], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("mem response: \(response)")
//                for item in response {
//                    self.myPublicGroupContributions.append(item)
//                }
            self.myPublicGroupContributions = response
            
            break
        case .failure(let error):
            
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
    

}
