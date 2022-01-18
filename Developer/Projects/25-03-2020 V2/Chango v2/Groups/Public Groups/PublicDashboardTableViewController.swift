//
//  PublicDashboardTableViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 30/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import FirebaseAuth

class PublicDashboardTableViewController: BaseTableViewController {

    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var campaignsTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var groupDescription: UILabel!
    let cell = "cellId"

    var publicGroup: GroupResponse!
    var campaigns: [GetGroupCampaignsResponse] = []
    var groupContributions: CampaignContributionResponse!
    var campaignContributions: CampaignContributionResponse!
    
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var campaignNames: [String] = []
    var campaignIds: [String] = []
    var campaignId: String = ""
    var campaignName: String = ""
    var endDateFromNow: String = ""
    var createdDaysAgo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        let user = Auth.auth().currentUser
        
        //GET PUBLIC GROUP CAMPAIGNS
        let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: publicGroup.groupId)
        getGroupCampaign(groupCampaignsParameter: parameter)
        FTIndicator.showProgress(withMessage: "Loading")

        self.campaignsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.campaignsTableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.campaignsTableView.register(UINib(nibName: "CampaignsTableViewCell", bundle: nil), forCellReuseIdentifier: "CampaignsTableViewCell")
        
        campaignsTableView.tableFooterView = UIView(frame: .zero)
        
        if (self.campaigns.count > 0){
            self.emptyView.isHidden = true
            print("hidden")
        }else{
            self.emptyView.isHidden = false
            print("show")
            
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == campaignsTableView {
        print(campaigns.count)
        return campaigns.count
        }
        return 0
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == campaignsTableView {
        return 338.0
        }else {
            
        }
        return 44.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CampaignsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CampaignsTableViewCell", for: indexPath) as! CampaignsTableViewCell
        
        if tableView == campaignsTableView {

        //        let cell: GroupsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell

        
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
            cell.endDate.isHidden = true
        }
        //        cell.groupsName.text = myCampaign.campaignName
        //
        //        cell.groupsDate.text = dates
        
        let formatters = DateFormatter()
        formatters.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if myCampaign.end == nil {
            
            cell.endDate.isHidden = true
            cell.dateModified.isHidden = true
            
        }else {
            let date = formatters.date(from: myCampaign.end!)
            
            
            formatters.dateStyle = DateFormatter.Style.medium
            _ = formatters.string(from: date as! Date)
            
            
            
            
            let dates = timeFromDate(date!)
            endDateFromNow = dates
            
            cell.dateModified.text = "Ends \(dates)"
        }
        
//        cell.shareButton.addTarget(self, action: #selector(shareButton(button:)), for: .touchUpInside)
        
        cell.campaignName.text = myCampaign.campaignName
        cell.campaignDescription.text = myCampaign.description
        cell.amountRaised.text = "\(myCampaign.amountReceived!) raised of \(myCampaign.target!)"
        
        print("bar value: \(Float(myCampaign.amountReceived!/myCampaign.target!))")
            cell.progressBar.progress = Float(myCampaign.amountReceived!/myCampaign.target!)
        
        return cell
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == campaignsTableView {

        
        let myCampaigns: GetGroupCampaignsResponse = self.campaigns[indexPath.row]
        
        //        let vc: DetailedCampaignViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedcampaign") as! DetailedCampaignViewController
        
        let vc: PublicCampaignTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publicdetailed") as! PublicCampaignTableViewController

        //        let formatters = DateFormatter()
        //        formatters.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //        formatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //
        //        formatters.dateStyle = DateFormatter.Style.medium
        //
        //        let dateCreated = formatters.date(from: myCampaigns.created)
        
        
        //        dateCreated?.dateString(ofStyle: .medium)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
            
        if myCampaigns.end == nil {
            
            vc.campaignEndDateLabel = ""
            
        }else {
            
            
            
            if let newDate = dateFormatterGet.date(from: myCampaigns.end!){
                print("new date: \(dateFormatterPrint.string(from: newDate))")
                
                vc.campaignEndDateLabel = endDateFromNow
                
            }else {
                print("There was an error decoding the string")
            }
            
                    }
        
        if myCampaigns.created == nil {
            
            vc.dateCreated = ""
            
        }else {
            
            let formatter = DateFormatter()
            let date = formatter.date(from: self.campaigns[indexPath.row].created)
            
            
            formatter.dateStyle = DateFormatter.Style.medium
            
            
            _ = formatter.string(from: date as! Date)
            
            
            let dates = timeAgoSinceDate(date!)

            
            if let createdDate = dateFormatterGet.date(from: myCampaigns.created){
                print("new date: \(dateFormatterPrint.string(from: createdDate))")
                
                createdDaysAgo = dates
                
                vc.dateCreated = createdDaysAgo
                
            }else {
                print("There was an error decoding the string")
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
        
        self.navigationController?.pushViewController(vc, animated: true)
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
            print("campaigns: \(self.campaigns.count)")
            
            tableView.reloadData()
            
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

}
