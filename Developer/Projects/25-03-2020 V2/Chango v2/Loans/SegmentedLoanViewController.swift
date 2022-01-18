//
//  SegmentedLoanViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FTIndicator
import Alamofire
import Nuke

class SegmentedLoanViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var groupLoans: [GroupLoanResponse] = []
    
    let cell = "cellId"
    var privateGroup: GroupResponse!
    var groupId: String = ""
    var campaignId: String = ""
    var memberId: String = ""
    var voteId: String = ""
    var loanVoteId: String = ""
    var campaignBalance: String = ""
    var cashoutCampaigns: [GetGroupCampaignsResponse] = []
    var campaigns: [GetGroupCampaignsResponse] = []
    var campaignBalances: [GroupBalance] = []
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        self.memberTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.memberTableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.memberTableView.tableFooterView = UIView()
        
//        self.groupTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
//        self.groupTableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        
        print(cashoutCampaigns)
        print(campaignId)
        print(voteId)
        print(loanVoteId)
        
        let parameter: GetGroupLoanParameter = GetGroupLoanParameter(groupId: groupId)
        getGroupLoan(getGroupLoanParameter: parameter)
        FTIndicator.showProgress(withMessage: "loading")
        
        if (self.groupLoans.count > 0){
                emptyView.isHidden = true
        }else {
            emptyView.isHidden = false
        }
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //    @IBAction func indexChanged(_ sender: UISegmentedControl) {
//       switch segmentedControl.selectedSegmentIndex {
//       case 0:
//            groupTableView.isHidden = true
//            memberTableView.isHidden = false
//            break
//       case 1:
//            groupTableView.isHidden = false
//            memberTableView.isHidden = true
//            break
//       default:
//            break
//
//        }
//    }
    
    @IBAction func RequestLoanButtonAction(_ sender: UIButton) {
//        let vc: LoanAmountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "request") as! LoanAmountViewController
        
        let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC
        vc.transactionType = 1
        vc.borrowCheck = true
        vc.groupId = groupId
//        vc.campaignId = campaignId
        vc.currency = currency
        vc.voteId = loanVoteId
        print("lon: \(loanVoteId), vid: \(voteId)")
        vc.campaignNames = cashoutCampaigns
        vc.campaignBalance = campaignBalance
        vc.campaignBalances = campaignBalances
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if (tableView == memberTableView) {
            print("count: \(groupLoans.count)")
            return groupLoans.count
//        }
//        else if (tableView == groupTableView){
//            return 2
//        }else {
//            return 0
//        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if (tableView == memberTableView) {
        
            let cell: GroupsTableViewCell = self.memberTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            
            let myLoans: GroupLoanResponse = self.groupLoans[indexPath.row]
            
            
            cell.groupsName.text = "\(myLoans.memberId.firstName) && \(myLoans.memberId.lastName)"
            cell.memerCampaignLabel.isHidden = true
            cell.memberCampaignCount.isHidden = true
            
            let user: String! = UserDefaults.standard.string(forKey: "users")

            if user == "\(myLoans.memberId.firstName) \(myLoans.memberId.lastName)" {
                cell.groupsName.text = "You"
            }else {
                cell.groupsName.text = "\(myLoans.memberId.firstName) \(myLoans.memberId.lastName)"
            }
            
            let users = Auth.auth().currentUser
            
            
            if (myLoans.memberId.memberIconPath != nil){
                print("not null: \(myLoans.memberId.memberIconPath)")
                Nuke.loadImage(with: URL(string: "\(myLoans.memberId.memberIconPath!)")!, into: cell.groupsImage)
            }else {
                print("default")
            }
            
            if (myLoans.status == "") {
                cell.groupType.isHidden = true
            }else {
                cell.groupType.isHidden = false
                cell.groupType.text = myLoans.status
            }
        cell.groupsDate.text = String(format: "%.2f", myLoans.amount)

//            String(format: "%.2f", myLoans.amount)
        
        
            
            return cell
//        }
//        else if (tableView == groupTableView){
//            let cell: GroupsTableViewCell = self.memberTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
//            cell.selectionStyle = .none
//
//
//            return cell
//        }else {
        
//            let cell: GroupsTableViewCell = self.memberTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
//            cell.selectionStyle = .none
        
            
//            return cell        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if (tableView == memberTableView) {
//
//        }
//        else if (tableView == groupTableView){
//
//        }
    }

    
    //GROUP LOANS
    func getGroupLoan(getGroupLoanParameter: GetGroupLoanParameter) {
        AuthNetworkManager.getGroupLoan(parameter: getGroupLoanParameter) { (result) in
            self.parseGetGroupLoanParameter(result: result)
        }
    }
    
    
    private func parseGetGroupLoanParameter(result: DataResponse<[GroupLoanResponse], AFError>){
        FTIndicator.dismissProgress()
        print("get group loans")
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            self.groupLoans.removeAll()
            for item in response {
                self.groupLoans.append(item)
                if (self.groupLoans.count > 0){
                    emptyView.isHidden = true
                    
                }else {
                    emptyView.isHidden = false
                }
            }
            print(self.groupLoans)
            self.memberTableView.reloadData()
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
