//
//  PublicCampaignsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import FirebaseAuth
import Nuke

var campaignImageArray: [String] = []

class PublicCampaignsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

//    @IBOutlet weak var tableView: FZAccordionTableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    
    let cell = "cellId"
    let cellReuseIdentifier = "MyCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"
    
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
    var groupIconPath: String = ""
    var createdDaysAgo: String = ""
    
    //SectionView
    let simpleTableIdentifier: String = "SimpleTableItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.allowMultipleSectionsOpen = true
        showChatController()
        disableDarkMode()
        
        let user = Auth.auth().currentUser
        
        self.title = publicGroup.groupName
        groupNameLabel.text = publicGroup.groupName
        groupDescriptionLabel.text = publicGroup.description
        
        //GET PUBLIC GROUP CAMPAIGNS
        let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: publicGroup.groupId)
        getGroupCampaign(groupCampaignsParameter: parameter)
        FTIndicator.showProgress(withMessage: "Loading")

        print("campaigns")
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: simpleTableIdentifier)
        self.tableView.register(UINib(nibName: "PublicGroupHeaderCell", bundle: nil), forCellReuseIdentifier: "PublicGroupHeaderCell")
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.tableView.register(UINib(nibName: "CampaignsTableViewCell", bundle: nil), forCellReuseIdentifier: "CampaignsTableViewCell")
        self.tableView.tableFooterView = UIView()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        if (self.campaigns.count > 0){
            self.emptyView.isHidden = true
            print("hidden")
        }else{
            self.emptyView.isHidden = false
            print("show")

        }
        
        if (publicGroup.groupIconPath == "<null>") || (publicGroup.groupIconPath == nil) || (publicGroup.groupIconPath == ""){
            groupImageView.image = UIImage(named: "people")
            groupImageView.contentMode = .scaleAspectFit
            
        }else {
            Nuke.loadImage(with: URL(string: publicGroup.groupIconPath!)!, into: groupImageView)
            groupImageView.contentMode = .scaleAspectFill
            
        }
        
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ⓘ", style: .plain, target: self, action: #selector(clickOnButton))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = publicGroup.groupName
        self.navigationItem.titleView?.tintColor = UIColor.white
        print(publicGroup.groupName)

    }
    
    
    @objc func clickOnButton() {
        
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let param: PublicContactParameter = PublicContactParameter(groupId: publicGroup.groupId)
        self.publicContact(publicContactParameter: param)
    }
    
    
    @IBAction func contribute(_ sender: UIBarButtonItem) {
        let vc: CampaignContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigncontribute") as! CampaignContributeViewController
        
        vc.campaignNames = campaignNames
        vc.campaignIds = campaignIds
        vc.publicGroup = publicGroup
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func shareButton(button: UIButton) {
        
        print("share button")
        
        let shareText = "Share this campaign with your friends"
        let secondActivityItem : NSURL = NSURL(string: "http//:google.com")!
        
//        if let image = UIImage(named: "myImage") {
            let vc = UIActivityViewController(activityItems: [shareText, secondActivityItem], applicationActivities: [])
            vc.popoverPresentationController?.sourceView = (button as! UIButton)
            self.present(vc, animated: true)
//        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return 1
        default:
            return campaigns.count
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section) {
        case 0:
            return 270.0
        default:
            return 331.0

        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Campaigns"
        default: return nil
        }
    }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//        if (section == 1) {
//            headerView.backgroundColor = UIColor.white
//        } else {
//            headerView.backgroundColor = UIColor.clear
//        }
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            if (section == 1) {
                headerView.backgroundView?.backgroundColor = UIColor.white
                headerView.textLabel?.textColor = .black
            } else {
                headerView.backgroundColor = UIColor.clear
            }
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
                let cell: PublicGroupHeaderCell = self.tableView.dequeueReusableCell(withIdentifier: "PublicGroupHeaderCell", for: indexPath) as! PublicGroupHeaderCell
                cell.selectionStyle = .none
            
            if (publicGroup.groupIconPath == "<null>") || (publicGroup.groupIconPath == nil) || (publicGroup.groupIconPath == "") {
                
                cell.groupImage.image = UIImage(named: "people")
                groupImageView.contentMode = .scaleAspectFit

            }else {
                
                Nuke.loadImage(with: URL(string: publicGroup.groupIconPath!)!, into: cell.groupImage)
                groupImageView.contentMode = .scaleAspectFill

            }
                cell.groupName.text = publicGroup.groupName
                cell.groupDescription.text = publicGroup.description
                
                return cell
        }else {
        let cell: CampaignsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CampaignsTableViewCell", for: indexPath) as! CampaignsTableViewCell

        cell.selectionStyle = .none
            
//            let backgroundView = UIView()
//            backgroundView.backgroundColor = UIColor.white

        let myCampaign = self.campaigns[indexPath.row]
            
        
            print("amt received: \(myCampaign.amountReceived), target: \(myCampaign.target)")
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if self.campaigns[indexPath.row].modified == nil {
            
            cell.dateModified.isHidden = true
        }else {
        
        let date = formatter.date(from: self.campaigns[indexPath.row].modified!)
        
        
        formatter.dateStyle = DateFormatter.Style.medium
            
        
        _ = formatter.string(from: date as! Date)
            
            
        let dates = timeAgoSinceDate(date!)
        
//            cell.dateModified.text = dates
            cell.dateModified.isHidden = true
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
            cell.dateModified.isHidden = true

        }else {
            let date = formatters.date(from: myCampaign.end!)


            formatters.dateStyle = DateFormatter.Style.medium
            _ = formatters.string(from: date as! Date)




            let dates = timeFromDate(date!)
            endDateFromNow = dates
            
            print("date: \(date!) \(dates)")

            cell.dateModified.text = "Ends \(dates)"
        }
        
//        cell.shareButton.addTarget(self, action: #selector(shareButton(button:)), for: .touchUpInside)
        
        cell.campaignName.text = myCampaign.campaignName
        cell.campaignDescription.text = myCampaign.description
            
            if(myCampaign.defaultCampaignIconPath == "null") || (myCampaign.defaultCampaignIconPath == nil) || (myCampaign.defaultCampaignIconPath == "") {
                cell.campaignImage.image = UIImage(named: "people")
            }else {
                let url = URL(string: myCampaign.defaultCampaignIconPath!)

                Nuke.loadImage(with: url!, into: cell.campaignImage)

            }
            let campaignTarget = myCampaign.target
            let amountRaised = myCampaign.amountReceived
            
        if myCampaign.campaignType == "perpetual" {
            cell.progressBar.isHidden = true
            cell.amountRaised.text = "\(publicGroup.countryId.currency) \(amountRaised!.formatPoints()) raised"
            
        }else {
            

            
        print("bar value: \(Float(myCampaign.amountReceived!/myCampaign.target!))")
        cell.progressBar.progress = Float(myCampaign.amountReceived!/myCampaign.target!)
            cell.amountRaised.text = "\(publicGroup.countryId.currency) \(amountRaised!.formatPoints()) of \(publicGroup.countryId.currency) \(campaignTarget!.formatPoints()) raised"
        }
        
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
            }
        }else {
        
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
            
            let vc: PublicCampaignTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publicdetailed") as! PublicCampaignTableViewController
//            let vc: ContributeAndShareCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "conshare") as! ContributeAndShareCampaignVC
            
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
            

            
        self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    //PUBLIC GROUP CAMPAIGNS
    func getGroupCampaign(groupCampaignsParameter: GroupCampaignsParameter) {
        AuthNetworkManager.getGroupCampaign(parameter: groupCampaignsParameter) { (result) in
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
    
    
    //GROUP CONTRIBUTIONS
    func getcampaignContributions(campaignContributionsParameter: CampaignContributionsParameter) {
        AuthNetworkManager.campaignContributions(parameter: campaignContributionsParameter) { (result) in
            self.parseCampaignContributionsResponse(result: result)
        }
    }
    
    private func parseCampaignContributionsResponse(result: DataResponse<CampaignContributionResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            //            for item in response {
            //                self.groupContributions.append(item)
            //             }
            groupContributions = response
            let vc: PublicCampaignContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publiccampaign") as! PublicCampaignContributionsViewController
            
            vc.groupContributions = response
            vc.campaignId = campaignId
            vc.publicGroup = publicGroup
            vc.campaignName = campaignName
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
    


}



extension Double {
    func formatUsingAbbrevations () -> String {
        let numFormatter = NumberFormatter()
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        return numFormatter.string(from: NSNumber (value:value))!
    }
}


extension Double {
    
    // Formatting double value to k and M
    // 1000 = 1k
    // 1100 = 1.1k
    // 15000 = 15k
    // 115000 = 115k
    // 1000000 = 1m
    func formatPoints() -> String{
        let thousandNum = self/1000
        let millionNum = self/1000000
        if self >= 1000 && self < 1000000{
            if(floor(thousandNum) == thousandNum){
                return ("\(Int(thousandNum))k").replacingOccurrences(of: ".0", with: "")
            }
            return("\(thousandNum.roundTo(places: 1))k").replacingOccurrences(of: ".0", with: "")
        }
        if self > 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k").replacingOccurrences(of: ".0", with: "")
            }
            return ("\(millionNum.roundTo(places: 1))M").replacingOccurrences(of: ".0", with: "")
        }
        else{
            if(floor(self) == self){
                return ("\(Int(self))")
            }
            return ("\(self)")
        }
    }
    
    /// Returns rounded value for passed places
    ///
    /// - parameter places: Pass number of digit for rounded value off after decimal
    ///
    /// - returns: Returns rounded value with passed places
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
