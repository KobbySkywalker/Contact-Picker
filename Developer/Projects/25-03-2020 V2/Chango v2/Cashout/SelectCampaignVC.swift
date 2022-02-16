//
//  SelectCampaignVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FTIndicator
import Nuke

class SelectCampaignVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let cell = "cellId"
    
    var privateGroup: GroupResponse!
    var campaignNameArray : [GetGroupCampaignsResponse] = []
    var groupName: String = ""
    var groupCampaignBalance: String = ""
    var groupId: String = ""
    var groupCampaignId: String = ""
    var campaignName: String = ""
    var campaignIdd: String = ""
    var campaignId: [String] = []
    var campaignStatus: [String] = []
    var campaignBal : [Double] = []
    var campBal: Double = 0.0
    var status: String = ""
    var voteId: String = ""
    var network: String = ""
    var cashoutVotesRequired: Double = 0.0
    var contribute: Int = 0
    var currency: String = ""
    var minVote: Double = 0.0
    var groupSize: Int = 0
    var groupIcon: String = ""
    var countryId: String = ""
    var campaignBalances: [GroupBalance] = []
    var maxCashoutLimitPerDay: Double = 0.0
    var maxContributionLimitPerDay: Double = 0.0
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]
// campaign contribution variables
    var campaignDetails: [GetGroupCampaignsResponse] = []
    var defaultContributions: DefaultCampaignResponse!
    var activeCampaignResponse: [GetGroupCampaignsResponse] = []
    var tableViewBalances: [Double] = []


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        self.title = "Select Campaign"
        
//        let parameter: CreatedVoteParameter = CreatedVoteParameter(groupId: groupId)
//        self.createdVotes(getCreatedVotes: parameter)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
//        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        
        self.tableView.register(UINib(nibName: "GroupCampaignsCell", bundle: nil), forCellReuseIdentifier: "GroupCampaignsCell")
        self.tableView.register(UINib(nibName: "GroupsViewController", bundle: nil), forCellReuseIdentifier: "GroupsViewController")
        
        campaignBal = []
        campaignStatus = []
        for item in campaignNameArray {
            self.campaignName.append(item.campaignName)
            self.campaignId.append(item.campaignId ?? "")
            self.campaignStatus.append(item.status!)
            self.campaignBal.append(item.amountReceived!)
            print("campaign names: \(campaignName)")
            print("id: \(campaignId)")
            print("campaign balance: \(campaignBal)")
        }
        
        print("groupIcon: \(groupIcon)")
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaignNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell: GroupCampaignsCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCampaignsCell", for: indexPath) as! GroupCampaignsCell
        
        cell.selectionStyle = .none
        
            let groups = self.campaignNameArray[indexPath.row]
            let campaignBalance = self.campaignBal[indexPath.row]
        
        for item in campaignBalances {
            if item.campaignId == campaignNameArray[indexPath.row].campaignId {
                print("\(item.campaignId) -- \(campaignNameArray[indexPath.row].campaignId)")
                cell.amountRaised.text = "\(currency)\(formatNumber(figure: item.balance))"
                
                print("balance: \(item.balance)")
            }
        }
        
        cell.campaignName.text = groups.campaignName

        cell.campaignDate.text = "Created on \(dateConversion(dateValue: groups.created))"
        print("date: \(groups.created)")
        if groups.description != "" {
        cell.campaignDescription.text = groups.description
        }
        //first campaign which is default campaign
        if indexPath.row == 0 {
            cell.raisedOut.isHidden = true
            cell.totalAmount.isHidden = true
            cell.progressBar.isHidden = true
            print("icon: \(groups.groupId.groupIconPath)")
            if (groups.groupId.groupIconPath == nil) || (groups.groupId.groupIconPath == "") {
                cell.campaignImage.image = UIImage(named: "defaultgroupicon")

            }else{
                Nuke.loadImage(with: URL(string: groups.groupId.groupIconPath!)!, into: cell.campaignImage)
            }

        }else {
            cell.daysLeft.text = groups.campaignType
            cell.raisedOut.text = "  raised out of"
            cell.totalAmount.text = "  \(groups.target!)"
            cell.progressBar.progress = Float(groups.amountReceived!/groups.target!)
            cell.campaignImage.image = UIImage(named: "defaultgroupicon")
        }
        cell.rectangleView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groups = self.campaignNameArray[indexPath.row]
        let campaignBalance = self.campaignBal[indexPath.row]

        if contribute == 1 {
            
            if groups.status == "stop" {
                let alert = UIAlertController(title: "Contribute", message: "This campaign has been stopped.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }else if groups.status == "pause" {
                
                let alert = UIAlertController(title: "Contribute", message: "This campaign has been paused.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }else {
                
//            let vc: ContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contribute") as! ContributeViewController
            
            let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC
                
            print("end: \(groups.end)")
                vc.campaignId = groups.campaignId ?? ""
            vc.groupId = groupId
            vc.voteId = voteId
            vc.network = network
            vc.countryId = countryId
            vc.groupNamed = groups.campaignName
            vc.currency = currency
            vc.campaignExpiry = groups.end ?? "nil"
            vc.maxSingleContributionLimit = maxContributionLimitPerDay
            vc.currency = currency
            vc.groupIconPath = groupIcon
            vc.contribution = true
            vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
            
        }else if contribute == 4 {

            let vc: MakeContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "make") as! MakeContributionsViewController

            for item in activeCampaignResponse {
                self.campaignDetails.append(item)
                vc.campaign = item
//                vc.campaignId = item.campaignId
                vc.groupName = item.groupId.groupName
                vc.privateGroup = GroupResponse(countryId_: item.groupId.countryId, groupId_: item.groupId.groupId, groupName_: item.groupId.groupName, groupType_: "", loanFlag_: 0, groupIconPath_: "", tnc_: "", status_: "", created_: "", defaultCampaignId_: item.groupId.defaultCampaignId, modified_: "", description_: "", approve_: "", creatorId_: "", creatorName_: "", isUsingGroupLimits_: "", campaignCount_: 0, groupMemberCount_: 0)
                vc.group = item.groupId.groupId
                vc.currency = item.groupId.countryId.currency
            }

//            vc.groupName = privateGroup.groupName
//            vc.currency = privateGroup.countryId.currency
            vc.campaignInfo = campaignDetails
            vc.campaignId = groups.campaignId ?? ""
//            vc.group = privateGroup.groupId
//            vc.privateGroup = privateGroup
            vc.defaultContributions = defaultContributions

            UserDefaults.standard.set(0, forKey: "contributionsBadge")
            FTIndicator.dismissProgress()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
        
        let vc: CashoutTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashouttype") as! CashoutTypeVC

        
        vc.groupId = groupId
        vc.campaignId = groups.campaignId ?? ""
        vc.voteId = voteId
        vc.network = network
        vc.groupBalance = "\(campaignBalance)"
        vc.groupSize = groupSize
        vc.minVote = minVote
        vc.campaignBalances = campaignBalances
        vc.maxCashoutLimitPerDay = maxCashoutLimitPerDay
        vc.currency = currency
            vc.countryId = groups.groupId.countryId.countryId!
            print("min vote count: \(minVote)")
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184.0
    }

}
