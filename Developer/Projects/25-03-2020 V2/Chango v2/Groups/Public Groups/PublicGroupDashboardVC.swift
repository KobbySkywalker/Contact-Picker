//
//  PublicGroupDashboardVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 05/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import FirebaseAuth
import Nuke

class PublicGroupDashboardVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupIconPath: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]
    let cell = "cellId"

    var publicGroup: GroupResponse!
    var campaigns: [GetGroupCampaignsResponse] = []
    var groupContributions: CampaignContributionResponse!
    var campaignContributions: CampaignContributionResponse!
    //    var campaignInfo: [Campaign] = []
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var campaignNames: [String] = []
    var campaignIds: [String] = []
    var campaignId: String = ""
    var campaignName: String = ""
    var publicContact: [PublicContact] = []
    var phoneNumber: String = ""
    var location: String = ""
    var email: String = ""
    var endDateFromNow: String = ""
    var groupIconPathString: String = ""
    var createdDaysAgo: String = ""
    var userNumber: String = ""
    var userNetwork: String = ""
    var msisdn: String = ""
    var maxContributionPerDay: Int = 0
    var currency: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "GroupCampaignsCell", bundle: nil), forCellReuseIdentifier: "GroupCampaignsCell")
        self.tableView.tableFooterView = UIView()
        
        //GET PUBLIC GROUP CAMPAIGNS
        let parameter: GetActivePausedCampaignsParameter = GetActivePausedCampaignsParameter(groupId: publicGroup.groupId)
        getGroupCampaign(groupCampaignsParameter: parameter)
        FTIndicator.showProgress(withMessage: "Loading")
        
        currency = publicGroup.countryId.currency
        
//        let param: AppConfigurationParameter = AppConfigurationParameter(countryId: publicGroup.countryId.countryId!)
//        appConfiguration(appConfigurationParameter: param)
        
        let param: GroupLimitsParamter = GroupLimitsParamter(groupId: publicGroup.groupId)
        retrieveGroupLimits(groupLimitsParameter: param)
        
        groupDescriptionLabel.text = publicGroup.description
        groupNameLabel.text = publicGroup.groupName

        if (publicGroup.groupIconPath! == "<null>") || (publicGroup.groupIconPath! == ""){
            groupIconPath.image = UIImage(named: "defaultgroupicon")
                    print(groupIconPath)
            groupIconPath.contentMode = .scaleAspectFit
            
        }else {
            groupIconPath.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: publicGroup.groupIconPath!)!, into: groupIconPath)
            
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func publicContactButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let param: PublicContactParameter = PublicContactParameter(groupId: publicGroup.groupId)
        self.publicContact(publicContactParameter: param)
    }
    
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
                return campaigns.count
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 184.0
        }

        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell: GroupCampaignsCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCampaignsCell", for: indexPath) as! GroupCampaignsCell

            cell.selectionStyle = .none

            let myCampaign = self.campaigns[indexPath.row]
                
            
                print("amt received: \(myCampaign.amountReceived), target: \(myCampaign.target)")
            
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if self.campaigns[indexPath.row].modified == nil {
                
                cell.campaignDate.isHidden = true
            }else {
            
            let date = formatter.date(from: self.campaigns[indexPath.row].modified!)
            
            
            formatter.dateStyle = DateFormatter.Style.medium
                
            
            _ = formatter.string(from: date as! Date)
                
                
            let dates = timeAgoSinceDate(date!)
            
    //            cell.dateModified.text = dates
                cell.campaignDate.isHidden = true
            }
    //        cell.groupsName.text = myCampaign.campaignName
    //
    //        cell.groupsDate.text = dates
    //
            let formatters = DateFormatter()
            formatters.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

            if myCampaign.end == nil {

    //            cell.endDate.isHidden = true
                cell.campaignDate.isHidden = true

            }else {
                let date = formatters.date(from: myCampaign.end!)


                formatters.dateStyle = DateFormatter.Style.medium
                _ = formatters.string(from: date as! Date)




                let dates = timeFromDate(date!)
                endDateFromNow = dates
                
                print("date: \(date!) \(dates)")

                cell.daysLeft.text = "Ends \(dates)"
            }
            
            cell.campaignName.text = myCampaign.campaignName
            guard let alias = myCampaign.alias else {return cell}
            cell.campaignDescription.text = myCampaign.description
            cell.rectangleView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
                
            cell.campaignImage.contentMode = .scaleAspectFill
                if(myCampaign.defaultCampaignIconPath == "null") || (myCampaign.defaultCampaignIconPath == nil) || (myCampaign.defaultCampaignIconPath == "") {
                    cell.campaignImage.image = UIImage(named: "people")
                }else {
                    let url = URL(string: myCampaign.defaultCampaignIconPath!)

                    Nuke.loadImage(with: url!, into: cell.campaignImage)

                }
                let campaignTarget = myCampaign.target
                let amountRaised = myCampaign.amountReceived
            print("type: \(myCampaign.campaignType)")
                
            if myCampaign.campaignType == "perpetual" {
                cell.progressBar.isHidden = true
                cell.amountRaised.text = "\(publicGroup.countryId.currency)\(formatNumber(figure: amountRaised!))"
//                cell.totalAmount.text = "\(publicGroup.countryId.currency)\(campaignTarget!.formatPoints())"
                cell.raisedOut.isHidden = true
                cell.totalAmount.isHidden = true
                cell.daysLeft.isHidden = true
            }else {
                

                
            print("bar value: \(Float(myCampaign.amountReceived!/myCampaign.target!))")
            cell.progressBar.progress = Float(myCampaign.amountReceived!/myCampaign.target!)
                cell.amountRaised.text = "\(publicGroup.countryId.currency) \(amountRaised!.formatPoints())"
                cell.totalAmount.text = "\(publicGroup.countryId.currency)\(campaignTarget!.formatPoints())"
            }
            
                return cell
        }
    
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
                let parameter : CampaignImagesParameter = CampaignImagesParameter(id: campaignId)
                self.campaignImages(campaignImageParameter: parameter)
                
            let myCampaigns: GetGroupCampaignsResponse = self.campaigns[indexPath.row]

            if myCampaigns.status == "stop" {
                
                let alert = UIAlertController(title: "Campaign Alert", message: "This campaign has ended.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else if myCampaigns.status == "pause" {
             
                let alert = UIAlertController(title: "Campaign Alert", message: "This campaign has been paused.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
                
//                let vc: PublicCampaignTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publicdetailed") as! PublicCampaignTableViewController
                let vc: ContributeAndShareCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "conshare") as! ContributeAndShareCampaignVC
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                
                
                if myCampaigns.end == nil {
                    
                    vc.campaignEndDateLabel = ""
                    
                }else {
                    let formatters = DateFormatter()
                    formatters.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                    formatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let date = formatters.date(from: myCampaigns.end!)
    //                if let newDate = dateFormatterGet.date(from: myCampaigns.end!){
    //                    print("new date: \(dateFormatterPrint.string(from: newDate))")
    //                    print("end date: \(myCampaigns.end)")
                    formatters.dateStyle = DateFormatter.Style.medium
                    _ = formatters.string(from: date as! Date)
                    
                    
                    
                    
                    let dates = timeFromDate(date!)
    //                endDateFromNow = dates
                        vc.campaignEndDateLabel = dates
                    print("campaign end date label: \(dates)")
                    
                        
    //                }else {
    //                    print("There was an error decoding the string")
    //                }
                    
                    
                }
                
                if myCampaigns.created == nil {
                    
                    vc.dateCreated = ""
                    
                }else {
                    
                    let formatters = DateFormatter()
                    formatters.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                    formatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E, d MMM yyyy"
                    if let newDateString = formatters.date(from: myCampaigns.created){
                       let newDate = dateFormatter.string(from: newDateString)
                        print("new date: \(dateFormatter.string(from: newDateString))")
                        print("created date: \(myCampaigns.created)")
                        vc.dateCreated = newDate
                    }
                    
                }

                vc.campaignStatusLabel = myCampaigns.status!
                
                vc.targetAmount = myCampaigns.target!
                vc.publicGroupDescriptionLabel = publicGroup.description!
                vc.campaignId = myCampaigns.campaignId
                vc.groupId = publicGroup.groupId
                vc.campaignName = myCampaigns.campaignName
                vc.publicGroup = publicGroup
                vc.amountReceived = myCampaigns.amountReceived!
                vc.campaignDescription = myCampaigns.description!
                vc.campaignType = myCampaigns.campaignType
                vc.campaignExpiry = myCampaigns.end ?? ""
                vc.alias = myCampaigns.alias ?? ""
                vc.groupIconPath = myCampaigns.defaultCampaignIconPath ?? ""
                vc.currency = publicGroup.countryId.currency
                vc.maxContributionPerDay = maxContributionPerDay
                if let alias = myCampaigns.alias {
                    vc.campaignAlias = alias
            }
                
            self.navigationController?.pushViewController(vc, animated: true)
                }
        }
    
    
    //PUBLIC GROUP CAMPAIGNS
    func getGroupCampaign(groupCampaignsParameter: GetActivePausedCampaignsParameter) {
        AuthNetworkManager.getActivePausedCampaigns(parameter: groupCampaignsParameter) { (result) in
            self.parseGetGroupCampaignResponse(result: result)
        }
    }
    
    private func parseGetGroupCampaignResponse(result: DataResponse<[GetGroupCampaignsResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            for item in response {
                self.campaigns.append(item)
                
                if (self.campaigns.count > 0){
                    self.emptyView.isHidden = true
                    print("hidden")
                }else{
                    self.emptyView.isHidden = false
                    print("show")

                }
                print("resp: \(campaigns)")
                campaignId = item.campaignId
                self.campaignNames.append(item.campaignName)
                self.campaignIds.append(item.campaignId)

            }
            
            self.campaigns = self.campaigns.sorted(by: { $0.modified > $1.modified })
            print("campaigns: \(self.campaigns.count)")

            tableView.reloadData()

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
    
    //GROUP LIMITS
    func retrieveGroupLimits(groupLimitsParameter: GroupLimitsParamter) {
        AuthNetworkManager.retrieveGroupLimits(parameter: groupLimitsParameter) { (result) in
            self.parseGroupLimitsResponse(result: result)
        }
    }
    
    
    private func parseGroupLimitsResponse(result: DataResponse<GroupLimitsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            
//            maxCashoutLimit = response.mobileLimitPerCashout ?? 0.0
//            maxContributionLimit = response.maxContributionPerDay ?? 0.0
            maxContributionPerDay = Int(response.maxSingleContribution ?? 0.0)
            print("per day: \(response.maxSingleContribution)")
            
            
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
            
            maxContributionPerDay = response.maxPublicContribution!
            currency = response.currency!
            
        break
        case .failure(_ ):
            
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
    
    
    func campaignImages(campaignImageParameter: CampaignImagesParameter) {
        AuthNetworkManager.campaignImages(parameter: campaignImageParameter) { (result) in
    //            self.parseGetCampaignBalance(result: result)
            switch result.result {
            case .success(let response):
                            print(response)
    //            print("Result: \(result)")
                campaignImageArray = response
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
            vc.groupDescription = publicGroup.description!
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
                
                sessionTimeout()
                
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
}
