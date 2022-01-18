//
//  PublicGroupContributionsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire

class PublicGroupContributionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contributionsTableView: UITableView!
    @IBOutlet weak var contributionView: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var contributionLabel: UILabel!
    @IBOutlet weak var contributionsView: UIView!
    @IBOutlet weak var campaignsView: UIView!
    @IBOutlet weak var campaignsTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contributeButton: UIBarButtonItem!
    
    var publicGroup: GroupResponse!
    var publicContributions: DefaultCampaignResponse!
    var publicGroupContrbutions : [Content] = []
    var campaigns: [GetGroupCampaignsResponse] = []
    var groupContributions: CampaignContributionResponse!
    var campaignName: String = ""

//    var contributions: [ContributionSection] = []
    var campaignId: String = ""
    
    let cell = "cellId"
    let cellReuseIdentifier = "MyCell"
    var contribution: [String] = ["GHS100", "GHS 90"]
    var dates: [String] = ["30mins ago","24th Feb"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        self.contributionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.contributionsTableView.register(UINib(nibName: "ContributionsCell", bundle: nil), forCellReuseIdentifier: "ContributionsCell")
        
        self.campaignsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.campaignsTableView.register(UINib(nibName: "CampaignViewCell", bundle: nil), forCellReuseIdentifier: "CampaignViewCell")
//        self.campaignsTableView.register(UINib(nibName: "CampaignViewCell", bundle: nil), forCellReuseIdentifier: "CampaignViewCell")
        
        contributionsTableView.tableFooterView = UIView(frame: .zero)
        campaignsTableView.tableFooterView = UIView(frame: .zero)
        
        contributionView.layer.cornerRadius = 10
        contributionView.layer.shadowColor = UIColor.black.cgColor
        contributionView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contributionView.layer.shadowRadius = 8
        contributionView.layer.shadowOpacity = 0.2
        
//        if publicContributions.total == "0" {
//            totalAmount.text = "0.00"
//        }else {
//        totalAmount.text = publicContributions.total
//        }

        //GET PUBLIC GROUP CAMPAIGNS
        let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: publicGroup.groupId)
        getGroupCampaign(groupCampaignsParameter: parameter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = publicGroup.groupName
        self.navigationItem.titleView?.tintColor = UIColor.white
        print(publicGroup.groupName)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            contributionsView.isHidden = false
            campaignsView.isHidden = true
            contributeButton.isEnabled = false
            break
        case 1:
            contributionsView.isHidden = true
            campaignsView.isHidden = false
            contributeButton.isEnabled = false
            emptyView.isHidden = true
            break
        default:
            break
            
        }
    }
    
    @IBAction func contributeButtonAction(_ sender: UIBarButtonItem) {
        let vc: PublicContributionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publiccontribute") as! PublicContributionViewController
        
        vc.publicGroup = publicGroup
        vc.campaignId = campaignId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return publicContributions.contributions.count
        if (tableView == contributionsTableView) {
        return publicGroupContrbutions.count
        }else if (tableView == campaignsTableView) {
            return campaigns.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (tableView == contributionsTableView) {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
//        let date = formatter.date(from: self.publicContributions.contributions[indexPath.row].created)
        let date = formatter.date(from: self.publicGroupContrbutions[indexPath.row].created)

        
        
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        _ = formatter.string(from: date as! Date)
        
        let dates = timeAgoSinceDate(date!)
        
        let cell: ContributionsCell = self.contributionsTableView.dequeueReusableCell(withIdentifier: "ContributionsCell", for: indexPath) as! ContributionsCell
        cell.selectionStyle = .none
        
//        cell.amount.text = "\(self.publicContributions.contributions[indexPath.row].currency) \(self.publicContributions.contributions[indexPath.row].amount)"
        
                cell.amount.text = "\(self.publicGroupContrbutions[indexPath.row].currency) \(self.publicGroupContrbutions[indexPath.row].amount)"
        cell.date.text = dates
        
        contributionLabel.text = "My Total Contributions (\(publicGroupContrbutions[indexPath.row].currency))"
        
        return cell
            
        }else if (tableView == campaignsTableView) {
            print("campaign")
            let cell: CampaignViewCell = self.campaignsTableView.dequeueReusableCell(withIdentifier: "CampaignViewCell", for: indexPath) as! CampaignViewCell
            cell.selectionStyle = .none

            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white

            let myCampaign = self.campaigns[indexPath.row]
            
            
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            
            let date = formatter.date(from: self.campaigns[indexPath.row].modified!)
            
            
            formatter.dateStyle = DateFormatter.Style.medium
            
            _ = formatter.string(from: date as! Date)
            let dates = timeAgoSinceDate(date!)
            
            
            cell.campaignName.text = myCampaign.campaignName
            print(myCampaign.campaignName)
            //            cell.date.text = "\(date[indexPath.section])"
            cell.date.text = dates
            
            return cell
        }else {
            let cell: GroupsTableViewCell = self.contributionsTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == campaignsTableView){
        let myCampaigns: GetGroupCampaignsResponse = self.campaigns[indexPath.row]
        let parameter: CampaignContributionsParameter = CampaignContributionsParameter(campaignId: myCampaigns.campaignId, offset: "0", pageSize: "50")
        print("id: \(myCampaigns.campaignId), \(myCampaigns.campaignName)")
        
        campaignId = myCampaigns.campaignId
        campaignName = myCampaigns.campaignName
        self.getcampaignContributions(campaignContributionsParameter: parameter)
        }
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
            
            publicContributions = response
            print("def: \(publicContributions)")

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
                print("resp: \(campaigns)")
                campaignId = item.campaignId
//                self.campaignNames.append(item.campaignName)
//                self.campaignIds.append(item.campaignId)
                
            }
//            print("names: \(campaignNames)")
//            print("ids: \(campaignIds)")
            
            
            campaignsTableView.reloadData()
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

}
