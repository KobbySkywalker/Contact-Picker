//
//  VoteViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 23/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import FirebaseAuth
import FirebaseDatabase
import PopupDialog
import ESPullToRefresh

class VoteViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var groupName: String = ""
    var groupIcon: String = ""
    var groupId: String = ""
    var voteId: String = ""
    var admin: Int = 0
    var adminVoteId: String = ""
    var makeAdminVoteId: String = ""
    var makeApproverVoteId: String = ""
    var approverVoteId: String = ""
    var dropVoteId:String = ""
    var cashoutVoteId: String = ""
    var approver: Int = 0
    var drop: Int = 0
    var pendingVotes: [PendingVotes] = []
    var memberTag: PendingVotes!
    var name: String = ""
    var memberId: String = ""
    var currency: String = ""
    
    var campaignBalance: String = ""
    var defaultCampaignId: String = ""
    
    var amount: String = ""
    var reason: String = ""
    var destination: String = ""
    var campaignName: String = ""
    var campaignId: String = ""
    var memberNetwork: String = ""
    
    var cashoutCampaignId: String = ""
    var voteType: String = ""
    
    var loanAmount: String = ""
    var loanReason: String = ""
    var loanDestination: String = ""
    var loanDestinationNumber: String = ""
    var loanCampaignName: String = ""
    var loanCampaignId: String = ""
    var loaner: String = ""
    var loanCampaignBalance: String = ""
    
    //cashout
    var cashoutMinVoteCount: Int = 0
    var cashoutMinAdminVoteCount: Int = 0
    var cashoutMinLoanerVoteCount: Int = 0
    var cashoutMinMemberVoteCount: Int = 0
    var cashoutVotesCompleted: Int = 0
    var cashoutVotesRemaining: Int = 0
    var cashoutDestinationNumber: String = ""
    var cashoutCampaignBalance: String = ""
    var cashoutRecipient: String = ""
    var cashoutDestinationCode: String = ""
    
    //loan
    var loanMinVoteCount: Int = 0
    var loanMinAdminVoteCount: Int = 0
    var loanMinLoanerVoteCount: Int = 0
    var loanMinMemberVoteCount: Int = 0
    var loanVotesCompleted: Int = 0
    var loanVotesRemaining: Int = 0
    var borrowMinVoteCount: String = ""
    
    //revokeAdmin
    var revokeAdminMinVoteCount: Int = 0
    var revokeAdminMinAdminVoteCount: Int = 0
    var revokeAdminMinLoanerVoteCount: Int = 0
    var revokeAdminMinMemberVoteCount: Int = 0
    var revokeAdminVotesCompleted: Int = 0
    var revokeAdminVotesRemaining: Int = 0
    
    //revokeApprover
    var revokeApproverMinVoteCount: Int = 0
    var revokeApproverMinAdminVoteCount: Int = 0
    var revokeApproverMinLoanerVoteCount: Int = 0
    var revokeApproverMinMemberVoteCount: Int = 0
    var revokeApproverVotesCompleted: Int = 0
    var revokeApproverVotesRemaining: Int = 0
    
    var revokeVotesCompleted: Int = 0
    var revokeVotesRemaining: Int = 0
    
    //dropMember
    var dropMemberMinVoteCount: Int = 0
    var dropMemberMinAdminVoteCount: Int = 0
    var dropMemberMinLoanerVoteCount: Int = 0
    var dropMemberMinMemberVoteCount: Int = 0
    var dropMemberVotesCompleted: Int = 0
    var dropMemberVotesRemaining: Int = 0
    
    var makeAdmin: Int = 0
    var makeAdminMinVoteCount: Int = 0
    var makeApproverMinVoteCount: Int = 0
    var makeApprover: Int = 0
    var loan: Int = 0
    var cashout: Int = 0
    var viewOnly: Bool = false
    
    
    //member tag variables
    var vCampaignName: String = ""
    var vCampaignBalance: String = ""
    var vCampaignId: String = ""
    var vDestination: String = ""
    var vDestinationCode: String = ""
    var vDestinationNumber: String = ""
    var vMemberId: String = ""
    var vMemberNetwork: String = ""
    var vVoteId: String = ""
    var vGroupId: String = ""
    var vReason: String = ""
    var vName: String = ""
    var vVoteType: String = ""
    var vAmount: String = ""
    
    var voteSelected: String = ""
    
    var totalToVote = 0.0
    var totalVoted = 0.0
    
    var roleVotingViewController: RoleVotingViewController!
    
    typealias FetchAllPendingVotesCompletionHandler = (_ votes: [PendingVotes]) -> Void
    typealias FetchAllMembersCompletionHandler = (_ groups: MembersRTDB ) -> Void
    typealias FetchBallotSummaryCompletionHandler = (_ groups: BallotSummaryRTDB ) -> Void
    
    var authProviderId: String = ""
    var voteCampaignId: String = ""
    var memberDeets: MembersRTDB!
    var ballotSummary: BallotSummaryRTDB!
    
    var memberVotedInGroup: [GetMemberVotedInGroupResponse] = []
    
    var refreshControl = UIRefreshControl()



    let cell = "cellId"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPendingVotes: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "VoteCell", bundle: nil), forCellReuseIdentifier: "VoteCell")
        self.tableView.tableFooterView = UIView()
        
        let param: GetMemberVotedInGroupParameter = GetMemberVotedInGroupParameter(groupId: groupId)
        self.getMemberVotedInGroup(getMemberVotedInGroupParameter: param)
        
        let paramter: GetCampaignBalanceParameter = GetCampaignBalanceParameter(campaignId: defaultCampaignId)
        getCampaignBalance(getCampaignBalanceParameter: paramter)
        
        
        let parameters: GetVoteSummaryParameter = GetVoteSummaryParameter(groupId: groupId)
        self.getVoteSummary(getVoteSummaryParameter: parameters)
        
        let ballotParameters: MinVotesAllBallotsParameter = MinVotesAllBallotsParameter(groupId: groupId)
        self.getMinVoteAllBallots(getMinVotesParameter: ballotParameters)


        refreshControl.attributedTitle = NSAttributedString(string: "loading pending votes")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.pendingVotes = []
        self.fetchAllPendingVotes { (result) in
            self.pendingVotes = result
            self.tableView.reloadData()
            print("result: \(self.pendingVotes), count: \(self.pendingVotes.count)")
        }
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("fetching from background")
//        FTIndicator.showProgress(withMessage: "loading votes")
        fetchAllPendingVotes { (result) in
            FTIndicator.dismissProgress()
            self.pendingVotes = []
            self.pendingVotes = result

            print("result: \(self.pendingVotes), count: \(self.pendingVotes.count)")
            self.tableView.reloadData()

            if self.pendingVotes.count > 0 {
                self.noPendingVotes.isHidden = true

            }
            else {
                self.noPendingVotes.isHidden = false
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func Cashout(button: UIButton) {

        cashout = 1
//        let vc: CashoutTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashoutvote") as! CashoutTableViewController
        
//        vc.cashoutAmount = amount
//        vc.cashoutReason = reason
//        vc.cashoutCampaignName = campaignName
//        vc.cashoutCampaignBalance = cashoutCampaignBalance
//        vc.campaignId = cashoutCampaignId
//        vc.cashoutDestination = destination
//        vc.memberId = memberId
//        vc.memberNetwork = memberNetwork
//        vc.cashoutDestinationNumber = cashoutDestinationNumber
//        print("cashout id: \(cashoutVoteId), groupId: \(groupId), campaignId: \(cashoutCampaignId), cashoutDestination: \(cashoutDestinationNumber), cashoutDestinationNumber: \(cashoutDestinationNumber), campaignBalance: \(cashoutCampaignBalance)")
//        vc.voteId = voteId
//        vc.groupId = groupId
//        vc.voteId = cashoutVoteId
//        vc.cashoutVotesCompleted = cashoutVotesCompleted
//        vc.cashoutVotesRemaining = cashoutVotesRemaining
        
        
        memberTag = pendingVotes[button.tag]
        
        vAmount = memberTag.amount
        vCampaignName = memberTag.campaignName
        vCampaignBalance = memberTag.campaignBalance
        vCampaignId = memberTag.campaignId
        vDestination = memberTag.cashoutDestination
        vMemberId = memberTag.membersRTDB.memberId
        vMemberNetwork = memberTag.network
        vDestinationNumber = memberTag.cashoutDestinationNumber
        vVoteId = memberTag.voteId
        vGroupId = memberTag.groupId
        vVoteType = "cashout"
        vName = memberTag.membersRTDB.name
        

        
//        let vc: RoleVotingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashoutvote") as! RoleVotingViewController
        
        
//        showRoleVoteDialog(animated: true, groupId: groupId, admin: 0, approver: 0, drop: 0, loan: 0, cashout: 1, makeApprover: 0, makeAdmin: 0)
        showRoleVoteDialog1(animated: true, groupId: groupId, voteType: "cashout")
    }
    
    
    @objc func Loan(button: UIButton) {
//        let vc: LoanerTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loaner") as! LoanerTableViewController
        
        loan = 1
//        print("table")
//        vc.campaignName = loanCampaignName
//        vc.campaignId = loanCampaignId
//        vc.loaner = loaner
//        vc.amount = loanAmount
//        vc.reason = loanReason
//        vc.loanDestination = loanDestination
//        vc.memberId = memberId
//        vc.voteId = voteId
//        vc.groupId = groupId
//        vc.campaignBalance = loanCampaignBalance
//        print("campaignBalance: \(loanCampaignBalance)")
//        vc.loanVotesCompleted = loanVotesCompleted
//        vc.loanVotesRemaining = loanVotesRemaining
//        vc.loanDestinationNumber = loanDestinationNumber
        
//        showRoleVoteDialog(animated: true, groupId: groupId, admin: 0, approver: 0, drop: 0, loan: 1, cashout: 0, makeApprover: 0, makeAdmin: 0)
        
        memberTag = pendingVotes[button.tag]
        
        vAmount = memberTag.amount
        vReason = memberTag.reason
        vCampaignName = memberTag.campaignName
        vCampaignBalance = memberTag.campaignBalance
        vCampaignId = memberTag.campaignId
        vDestination = memberTag.cashoutDestination
        vMemberId = memberTag.membersRTDB.memberId
        vMemberNetwork = memberTag.network
        vDestinationNumber = memberTag.cashoutDestinationNumber
        vVoteId = memberTag.voteId
        vGroupId = memberTag.groupId
        vName = memberTag.membersRTDB.name
        vVoteType = "loan"
        
        
        print("amount: \(vAmount)")
        

//
        showRoleVoteDialog1(animated: true, groupId: groupId, voteType: "loan")

    }
    
    
    @objc func RevokeAdmin(button: UIButton) {
        admin = 1
//        let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
        

//        vc.admin = admin
//        vc.groupName = groupName
//        vc.groupId = groupId
//        vc.pendingVotes = pendingVotes
//        vc.name = name
//        vc.voteId = adminVoteId
//        vc.campaignId = campaignId
//        vc.memberId = memberId
//        vc.revokeVotesCompleted = revokeAdminVotesCompleted
//        vc.revokeVotesRemaining = revokeAdminVotesRemaining
//        vName = memberTag.membersRTDB.name
        
//        showRoleVoteDialog(animated: true, groupId: groupId, admin: 1, approver: 0, drop: 0, loan: 0, cashout: 0, makeApprover: 0, makeAdmin: 0)
        memberTag = pendingVotes[button.tag]
        
        vGroupId = memberTag.groupId
        vMemberId = memberTag.memberId
        vVoteId = memberTag.voteId
        vName = memberTag.membersRTDB.name
        vVoteType = "revokeadmin"
        

        
        showRoleVoteDialog1(animated: true, groupId: groupId, voteType: "revokeadmin")

    }
    
    
    @objc func RevokeApprover(button: UIButton) {
        approver = 1
//        let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
//
//        vc.approver = approver
//        vc.groupName = groupName
//        vc.groupId = groupId
//        vc.pendingVotes = pendingVotes
//        vc.name = name
//        vc.voteId = approverVoteId
//        vc.campaignId = campaignId
//        vc.memberId = memberId
//        vc.revokeVotesCompleted = revokeApproverVotesCompleted
//        vc.revokeVotesRemaining = revokeApproverVotesRemaining
        
//        showRoleVoteDialog(animated: true, groupId: groupId, admin: 0, approver: 1, drop: 0, loan: 0, cashout: 0, makeApprover: 0, makeAdmin: 0)
        
        memberTag = pendingVotes[button.tag]
        
        vGroupId = memberTag.groupId
        vMemberId = memberTag.memberId
        vVoteId = memberTag.voteId
        vName = memberTag.membersRTDB.name
        vVoteType = "revokeadmin"
        

        
        
        showRoleVoteDialog1(animated: true, groupId: groupId, voteType: "revokeapprover")

    }
    
    
    @objc func DropMember(button: UIButton) {
        drop = 1
//        let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
        
        
//        vc.drop = drop
//        vc.groupName = groupName
//        vc.groupId = groupId
//        vc.pendingVotes = pendingVotes
//        vc.name = name
//        vc.voteId = dropVoteId
//        vc.campaignId = campaignId
//        vc.memberId = memberId
//        vc.revokeVotesCompleted = dropMemberVotesCompleted
//        vc.revokeVotesRemaining = dropMemberVotesRemaining
        
//        showRoleVoteDialog(animated: true, groupId: groupId, admin: 0, approver: 0, drop: 1, loan: 0, cashout: 0, makeApprover: 0, makeAdmin: 0)
        
        memberTag = pendingVotes[button.tag]
        
        vGroupId = memberTag.groupId
        vMemberId = memberTag.memberId
        vVoteId = memberTag.voteId
        vName = memberTag.membersRTDB.name
        vVoteType = "revokeadmin"
        
//        roleVotingViewController.groupId = vGroupId
//        roleVotingViewController.memberId = vMemberId
//        roleVotingViewController.voteId = vVoteId
//        roleVotingViewController.voteType = "revokeadmin"
        
        showRoleVoteDialog1(animated: true, groupId: groupId, voteType: "dropmember")

    }
    
    @objc func MakeAdmin(button: UIButton) {
        makeAdmin = 1
        
//    showRoleVoteDialog(animated: true, groupId: groupId, admin: 0, approver: 0, drop: 0, loan: 0, cashout: 0, makeApprover: 0, makeAdmin: 1)
        
        memberTag = pendingVotes[button.tag]
        
        vGroupId = memberTag.groupId
        vMemberId = memberTag.memberId
        vVoteId = memberTag.voteId
        vName = memberTag.membersRTDB.name
        vVoteType = "revokeadmin"
        
//        roleVotingViewController.groupId = vGroupId
//        roleVotingViewController.memberId = vMemberId
//        roleVotingViewController.voteId = vVoteId
//        roleVotingViewController.voteType = "revokeadmin"
        
        showRoleVoteDialog1(animated: true, groupId: groupId, voteType: "makeadmin")

    }
    
    @objc func MakeApprover(button: UIButton) {
        makeApprover = 1
        
//        showRoleVoteDialog(animated: true, groupId: groupId, admin: 0, approver: 0, drop: 0, loan: 0, cashout: 0, makeApprover: 1, makeAdmin: 0)
        
        memberTag = pendingVotes[button.tag]
        
        vGroupId = memberTag.groupId
        vMemberId = memberTag.memberId
        vVoteId = memberTag.voteId
        vName = memberTag.membersRTDB.name
        vVoteType = "revokeadmin"
        
//        roleVotingViewController.groupId = vGroupId
//        roleVotingViewController.memberId = vMemberId
//        roleVotingViewController.voteId = vVoteId
//        roleVotingViewController.voteType = "revokeadmin"
        
        showRoleVoteDialog1(animated: true, groupId: groupId, voteType: "makeapprover")

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pendingVotes.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: VoteCell = self.tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as! VoteCell
        cell.selectionStyle = .none
        
        let voteInfo = self.pendingVotes[indexPath.row]
//        let memberVoteInfo = self.memberVotedInGroup[indexPath.row]
        
        if UserDefaults.standard.bool(forKey: "dropmember\(campaignId)-\(voteId)") || UserDefaults.standard.bool(forKey: "makeadmin\(campaignId)-\(voteId)") ||  UserDefaults.standard.bool(forKey: "revokeapprover\(campaignId)-\(voteId)") || UserDefaults.standard.bool(forKey: "revokeadmin\(campaignId)-\(voteId)") || UserDefaults.standard.bool(forKey: "cashout\(campaignId)-\(voteId)") || UserDefaults.standard.bool(forKey: "borrow\(campaignId)-\(voteId)") {
            
            print("hide vote button")
            cell.voteButton.isHidden = true
        }
        

        if voteInfo.campaignName == ("Contributions") || (voteInfo.voteType.contains("Contributions")){
        cell.groupName.text = groupName
        campaignName = voteInfo.campaignName
        }else if voteInfo.campaignName == "" {
            if (voteInfo.voteType == "revokeapprover") || (voteInfo.voteType.contains("revokeapprover")){
                cell.groupName.text = "Revoke Approver"
                cell.voteIcon.image = UIImage(named: "get-money")

            }else if (voteInfo.voteType == "revokeadmin") || (voteInfo.voteType.contains("revokeadmin")){
                cell.groupName.text = "Revoke Admin"
                cell.voteIcon.image = UIImage(named: "man")

            }else if (voteInfo.voteType == "dropmember") || (voteInfo.voteType.contains("dropmember")) {
                cell.groupName.text = "Revoke Member"
                cell.voteIcon.image = UIImage(named: "revoke")

            }else if (voteInfo.voteType == "makeadmin") || (voteInfo.voteType.contains("makeadmin")) {
                cell.groupName.text  = "Make Group Admin"
                cell.voteIcon.image = UIImage(named: "man")
            }else if voteInfo.voteType == "makeapprover"{
                cell.groupName.text  = "Make Approver"
                cell.voteIcon.image = UIImage(named: "get_money")
            }
        }
        else {
//            cell.groupName.text = voteInfo.campaignName
            campaignName = voteInfo.campaignName
        }
        let user = Auth.auth().currentUser
        
        if (user!.displayName == voteInfo.membersRTDB.name) && (user!.uid == voteInfo.authProviderId) {
            cell.voteButton.isHidden = true
        }
        
        if voteInfo.voteType == "cashout" || voteInfo.voteType == "loan" {
        cell.memberName.text = "By \(voteInfo.membersRTDB.name)"
        }else {
            cell.memberName.text = voteInfo.membersRTDB.name
        }
        
        if voteInfo.voteCount == "No present votes" {
            cell.voteCount.text = "No present votes"
//            totalVoted = 0.0
//            totalToVote = 0.0
        }else {
        let voteCount    = voteInfo.voteCount
        let voteCountArr = voteCount.components(separatedBy: "/")

            cell.voteCount.text = "\(voteCountArr[0]) out of \(voteCountArr[1])"
//            totalVoted = Double(voteCountArr[0])!
//            totalToVote = Double(voteCountArr[1])!
//
        }

        name = voteInfo.membersRTDB.name
        memberId = voteInfo.memberId
        campaignId = voteInfo.campaignId
        
        if voteInfo.voteType == "cashout" {
            
            cashoutRecipient = voteInfo.nameOfMemberActionIsAbout
            reason = voteInfo.reason
            amount = voteInfo.amount
            destination = voteInfo.cashoutDestination
            cashoutDestinationNumber = voteInfo.cashoutDestinationNumber
            memberNetwork = voteInfo.network
            voteId = voteInfo.voteId
            cashoutCampaignId = voteInfo.campaignId
            cashoutDestinationCode = voteInfo.cashoutDestinationCode
            cell.groupName.text = "Allow Cashout"
            cashoutCampaignBalance = voteInfo.campaignBalance
            cell.voteIcon.image = UIImage(named: "my-euro")
            print(voteInfo.reason)
            print(voteInfo.cashoutDestinationNumber)
            cell.voteButton.addTarget(self, action: #selector(Cashout(button:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row


        }else if voteInfo.voteType == "loan" {

            loanReason = voteInfo.reason
            loanAmount = voteInfo.amount
            loanDestination = voteInfo.cashoutDestination
            loanCampaignId = voteInfo.campaignId
            loanDestinationNumber = voteInfo.cashoutDestinationNumber
            loanCampaignBalance = voteInfo.campaignBalance
            voteId = voteInfo.voteId
            cell.groupName.text = "Approve Borrowing"
            cell.voteIcon.image = UIImage(named: "my-loan")

            if voteInfo.campaignName == "Contributions" {
//            loanCampaignName = groupName
                loanCampaignName = voteInfo.campaignName
            } else {
                loanCampaignName = voteInfo.campaignName
            }
            
            loaner = voteInfo.nameOfMemberActionIsAbout
            
            if user?.displayName == voteInfo.membersRTDB.name {
                cell.voteButton.isEnabled = false
                cell.voteButton.backgroundColor = UIColor.gray
            }else {
        
            cell.voteButton.addTarget(self, action: #selector(Loan(button:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row
            }


        }else if (voteInfo.voteType == "revokeadmin") {
            
            cell.voteButton.addTarget(self, action: #selector(RevokeAdmin(button:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row
            
        }else if (voteInfo.voteType == "revokeapprover"){
            
            cell.voteButton.addTarget(self, action: #selector(RevokeApprover(button:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row

        }else if (voteInfo.voteType == "dropmember") {
            
            print("drop")
            cell.voteButton.addTarget(self, action: #selector(DropMember(button:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row

            
        }else if (voteInfo.voteType == "makeadmin"){
            
            print("make admin")
            cell.voteButton.addTarget(self, action: #selector(MakeAdmin(button:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row

        }else if (voteInfo.voteType == "makeapprover") {
            
            print("make approver")
            cell.voteButton.addTarget(self, action: #selector(MakeApprover(button:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row
        }
        
        for item in memberVotedInGroup {
            if item.voteId == voteInfo.voteId {
                if item.hasMemberVoted == true {
                    cell.voteButton.setTitle("View", for: .normal)
                    cell.voteButton.backgroundColor = UIColor(hexString: "#228CC7")
                }else {
                    
                }
            }
        }

        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let voteOption = self.pendingVotes[indexPath.row]
        
        let user = Auth.auth().currentUser

        if voteOption.voteCount == "No present votes" {
            totalVoted = 0.0
            totalToVote = 0.0
        }else {
        let voteCount    = voteOption.voteCount
        let voteCountArr = voteCount.components(separatedBy: "/")
            
            totalVoted = Double(voteCountArr[0])!
            totalToVote = Double(voteCountArr[1])!
        
        }
        

        
        if (voteOption.voteType == "revokeadmin") /*&& (user?.displayName != voteOption.membersRTDB.name)*/ {
            
            let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
            
            vc.admin = admin
            vc.groupName = groupName
            vc.groupId = groupId
            vc.pendingVotes = pendingVotes
            vc.name = voteOption.membersRTDB.name
            vc.voteId = voteOption.voteId
            vc.campaignId = campaignId
            vc.memberId = memberId
            vc.role = voteOption.role
            vc.voteType = voteOption.voteType
            vc.voteCount = totalVoted/totalToVote
            vc.authProviderId = voteOption.authProviderId
            vc.minVoteCount = "\(revokeAdminMinVoteCount)"
            for item in memberVotedInGroup {
                if item.voteId == voteOption.voteId {
                    if item.hasMemberVoted == true {
                        vc.viewOnly = true
                    }else {
                        vc.viewOnly = false
                    }
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)

            
        }else if (voteOption.voteType == "makeadmin") /*&& (user?.displayName != voteOption.membersRTDB.name)*/ {
            
            print("name:\(user?.displayName), member name: \(voteOption.authProviderId)")
            
//            voteType = voteOption.voteType
            let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
            
            vc.admin = admin
            vc.groupName = groupName
            vc.groupId = groupId
            vc.pendingVotes = pendingVotes
            vc.name = voteOption.membersRTDB.name
            vc.voteId = voteOption.voteId
            print("admin vote id: \(adminVoteId)")
            vc.campaignId = campaignId
            vc.memberId = memberId
            vc.role = voteOption.role
            vc.voteType = voteOption.voteType
            vc.voteCount = totalVoted/totalToVote
            vc.minVoteCount = "\(makeAdminMinVoteCount)"
            for item in memberVotedInGroup {
                if item.voteId == voteOption.voteId {
                    if item.hasMemberVoted == true {
                        vc.viewOnly = true
                    }else {
                        vc.viewOnly = false
                    }
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if (voteOption.voteType == "revokeapprover") /* && (user?.displayName != voteOption.membersRTDB.name)*/ {
            
            print("name:\(user?.displayName), member name: \(voteOption.membersRTDB.name)")
            
            voteType = voteOption.voteType

//            approver = 1
            let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
            
            
            
            vc.approver = approver
            vc.groupName = groupName
            vc.groupId = groupId
            vc.pendingVotes = pendingVotes
            vc.name = voteOption.membersRTDB.name
            vc.voteId = voteOption.voteId
            vc.campaignId = campaignId
            vc.voteType = voteOption.voteType
            vc.memberId = memberId
            vc.role = voteOption.role
            vc.voteCount = totalVoted/totalToVote
            vc.minVoteCount = "\(revokeApproverMinVoteCount)"
            for item in memberVotedInGroup {
                if item.voteId == voteOption.voteId {
                    if item.hasMemberVoted == true {
                        vc.viewOnly = true
                    }else {
                        vc.viewOnly = false
                    }
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if (voteOption.voteType == "makeapprover") /*&& (user?.displayName != voteOption.membersRTDB.name)*/ {
            
            let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
            
            
            
            vc.approver = approver
            vc.groupName = groupName
            vc.groupId = groupId
            vc.pendingVotes = pendingVotes
            vc.name = voteOption.membersRTDB.name
            vc.voteId = voteOption.voteId
            vc.campaignId = campaignId
            vc.voteType = voteOption.voteType
            vc.role = voteOption.role
            vc.memberId = memberId
            vc.voteCount = totalVoted/totalToVote
            vc.minVoteCount = "\(makeApproverMinVoteCount)"
            for item in memberVotedInGroup {
                if item.voteId == voteOption.voteId {
                    if item.hasMemberVoted == true {
                        vc.viewOnly = true
                    }else {
                        vc.viewOnly = false
                    }
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (voteOption.voteType == "dropmember") /* && (user?.displayName != voteOption.membersRTDB.name)*/ {
//            drop = 1
            let vc: RoleVoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "role") as! RoleVoteViewController
            
            
            vc.drop = drop
            vc.groupName = groupName
            vc.groupId = groupId
            vc.pendingVotes = pendingVotes
            vc.name = voteOption.membersRTDB.name
            vc.voteId = voteOption.voteId
            vc.campaignId = campaignId
            vc.memberId = memberId
            vc.role = voteOption.role
            vc.voteType = voteOption.voteType
            vc.voteCount = totalVoted/totalToVote
            vc.minVoteCount = "\(dropMemberMinVoteCount)"
            print("vote count: \(totalVoted): \(totalToVote)")
            for item in memberVotedInGroup {
                if item.voteId == voteOption.voteId {
                    if item.hasMemberVoted == true {
                        vc.viewOnly = true
                    }else {
                        vc.viewOnly = false
                    }
                }
            }
            
                    self.navigationController?.pushViewController(vc, animated: true)

        }else if (voteOption.voteType == "cashout") /*&& (user?.displayName != voteOption.membersRTDB.name)*/ {
//        let vc: CashoutTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashoutvote") as! CashoutTableViewController
        let vc: ApproveCashoutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "approvC") as! ApproveCashoutVC
            vc.cashoutAmount = amount
            vc.cashoutReason = reason
            vc.cashoutCampaignName = campaignName
            vc.cashoutCampaignBalance = cashoutCampaignBalance
            vc.campaignId = cashoutCampaignId
            vc.cashoutDestination = destination
            vc.memberId = memberId
            vc.memberNetwork = memberNetwork
            vc.cashoutDestinationNumber = cashoutDestinationNumber
            print("cashout id: \(cashoutVoteId), groupId: \(groupId), campaignId: \(cashoutCampaignId), cashoutDestination: \(cashoutDestinationNumber), cashoutDestinationNumber: \(cashoutDestinationNumber), campaignBalance: \(cashoutCampaignBalance)")
            vc.voteId = voteId
            vc.groupId = groupId
            vc.voteId = voteOption.voteId
            vc.cashoutVotesCompleted = cashoutVotesCompleted
            vc.cashoutVotesRemaining = cashoutVotesRemaining
            vc.cashoutRecipient = voteOption.membersRTDB.name
            vc.cashoutDestinationCode = voteOption.cashoutDestinationCode
            vc.currency = currency
            vc.recipient = cashoutRecipient
            vc.voteCount = totalVoted/totalToVote
            vc.minVoteCount = "\(cashoutMinVoteCount)"
            print("vote count: \(totalVoted): \(totalToVote)")
            vc.authProviderId = voteOption.authProviderId
            for item in memberVotedInGroup {
                if item.voteId == voteOption.voteId {
                    if item.hasMemberVoted == true {
                        vc.viewOnly = true
                    }else {
                        vc.viewOnly = false
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)

        }else if (voteOption.voteType == "loan") /*&& (user?.displayName != voteOption.membersRTDB.name)*/ {
//            let vc: LoanerTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loaner") as! LoanerTableViewController
            let vc: ApproveBorrowingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "approvB") as! ApproveBorrowingVC
            
            print("table")
            vc.campaignName = loanCampaignName
            vc.campaignId = loanCampaignId
            vc.loaner = loaner
            vc.amount = loanAmount
            vc.reason = loanReason
            vc.loanDestination = loanDestination
            vc.memberId = memberId
            vc.voteId = voteOption.voteId
            vc.groupId = groupId
            vc.campaignBalance = loanCampaignBalance
            print("campaignBalance: \(loanCampaignBalance)")
            vc.loanVotesCompleted = loanVotesCompleted
            vc.loanVotesRemaining = loanVotesRemaining
            print("votes rem: \(loanVotesRemaining)")
            vc.loanDestinationNumber = loanDestinationNumber
            vc.currency = currency
            vc.voteCount = totalVoted/totalToVote
            vc.minVoteCount = borrowMinVoteCount
            print("vote count: \(totalVoted/totalToVote)")
            for item in memberVotedInGroup {
                if item.voteId == voteOption.voteId {
                    if item.hasMemberVoted == true {
                        vc.viewOnly = true
                    }else {
                        vc.viewOnly = false
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }


    }
    
    
    
    func fetchBallotSummary(voteId: String, completionHandler: @escaping FetchBallotSummaryCompletionHandler){
        var ballots: BallotSummaryRTDB!
        let ballotsRef = Database.database().reference().child("ballot_summary").child("\(groupId)").child("\(voteId)")
        print("voteId \(voteId)")
        _ = ballotsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String:AnyObject]
            
            print("ballot dict: \(snapshot)")
            
            
            var grpId = ""
            if let groupId = snapshotValue["groupId"] as? String {
                print("groupId: \(groupId)")
                grpId = groupId
            }
            
            var minVoteCnt = 0
            if let minVoteCount = snapshotValue["minVoteCount"] as? Int {
                minVoteCnt = minVoteCount
                print("min vote count: \(minVoteCount)")
            }
            
            var votId = ""
            if let voteId = snapshotValue["voteId"] as? String {
                votId = voteId
                print("vote id: \(voteId)")
            }
            
            var votCompltd = 0
            if let votesCompleted = snapshotValue["votesCompleted"] as? Int {
                //                ballots.votesCompleted = votCompltd
                votCompltd = votesCompleted
                print("votes Completed: \(votesCompleted)")
                self.revokeVotesCompleted = Int(votesCompleted)
            }
            
            var votRemaining = 0
            if let votesRemaining = snapshotValue["votesRemaining"] as? Int {
                //                ballots.votesRemaining = votCompltd
                votRemaining = votesRemaining
                print("votes Remaining: \(votesRemaining)")
                self.revokeVotesRemaining = Int(votesRemaining)
            }
            
            let ballots = BallotSummaryRTDB(groupId_: grpId, minVoteCount_: minVoteCnt, voteId_: votId, votesCompleted_: votCompltd, votesRemaining_: votRemaining)
            
            self.ballotSummary = ballots
            
            
            print("vot comp: \(votCompltd), vot rem: \(votRemaining)")
            completionHandler(ballots)
            print("ballots: \(ballots.minVoteCount)")
        })
    }
    
    
    
    
    func getCampaignBalance(getCampaignBalanceParameter: GetCampaignBalanceParameter) {
        AuthNetworkManager.getCampaignBalance(parameter: getCampaignBalanceParameter) { (result) in
//            self.parseGetCampaignBalance(result: result)
            print(result)
            print("Result: \(result)")
            
            self.campaignBalance = result

            }

        }
    
    
    private func parseGetCampaignBalance(result: DataResponse<String, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                //                    let vc: MembersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "members") as! MembersViewController
                //
                //                    self.present(vc, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
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
    
    
    //VOTE SUMMARY
    func getVoteSummary(getVoteSummaryParameter: GetVoteSummaryParameter) {
        AuthNetworkManager.getVoteSummary(parameter: getVoteSummaryParameter) { (result) in
            self.parseGetVoteSummary(result: result)
        }
    }
    
    
    private func parseGetVoteSummary(result: DataResponse<[BallotSummary], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
//            for item in response {
//                if item.ballot == "revokeapprover"{
//                    print(item.ballot)
//                revokeApproverVotesRemaining = item.votesRemaining
//                revokeApproverVotesCompleted = item.votesCompleted
//
//                }else if item.ballot == "revokeadmin"{
//                revokeAdminVotesRemaining = item.votesRemaining
//                revokeAdminVotesCompleted = item.votesCompleted
//
//                }else if item.ballot == "cashout"{
//                cashoutVotesRemaining = item.votesRemaining
//                cashoutVotesCompleted = item.votesCompleted
//
//                }else if item.ballot == "dropmember"{
//                dropMemberVotesRemaining = item.votesRemaining
//                dropMemberVotesCompleted = item.votesCompleted
//
//                }else if item.ballot == "loan"{
//                loanVotesRemaining = item.votesRemaining
//                loanVotesCompleted = item.votesCompleted
//                }
//
//            }
            
            
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
    
    
    func showRoleVoteDialog(animated: Bool = true, groupId: String, admin: Int, approver: Int, drop: Int, loan: Int, cashout: Int, makeApprover: Int, makeAdmin: Int) {
        
        //create a custom view controller
        let voteVC = RoleVotingViewController(nibName: "RoleVotingViewController", bundle: nil)
        
//        roleVotingViewController.admin = admin
//        roleVotingViewController.groupId = groupId
        
        if admin == 1 {
            
            print("admin vote")
        voteVC.admin = admin
        voteVC.groupId = groupId
        voteVC.memberId = memberId
            
        }else if approver == 1 {
            print("approver vote")

            voteVC.groupId = groupId
            voteVC.approver = approver
            voteVC.memberId = memberId

        }else if drop == 1 {
            print("drop vote")

            voteVC.drop = drop
            voteVC.memberId = memberId
            voteVC.groupId = groupId

        }else if cashout == 1 {
            print("cashout vote")

            //cashout
            voteVC.cashoutAmount = amount
            voteVC.cashoutReason = reason
            voteVC.cashoutCampaignName = campaignName
            voteVC.cashoutCampaignBalance = cashoutCampaignBalance
            voteVC.campaignId = cashoutCampaignId
            voteVC.cashoutDestination = destination
            voteVC.memberId = memberId
            voteVC.memberNetwork = memberNetwork
            voteVC.cashoutDestinationNumber = cashoutDestinationNumber
            print("cashout id: \(cashoutVoteId), groupId: \(groupId), campaignId: \(cashoutCampaignId), cashoutDestination: \(cashoutDestinationNumber), cashoutDestinationNumber: \(cashoutDestinationNumber), campaignBalance: \(cashoutCampaignBalance)")
            voteVC.voteId = voteId
            voteVC.groupId = groupId
            voteVC.voteId = cashoutVoteId
            voteVC.cashoutVotesCompleted = cashoutVotesCompleted
            voteVC.cashoutVotesRemaining = cashoutVotesRemaining
            voteVC.cashout = cashout
            voteVC.memberNetwork = memberNetwork
            voteVC.currency = currency
        
        }else if loan == 1 {
            print("loan vote")

            //loan
            voteVC.campaignName = loanCampaignName
            voteVC.campaignId = loanCampaignId
            voteVC.loaner = loaner
            voteVC.amount = loanAmount
            voteVC.reason = loanReason
            voteVC.loanDestination = loanDestination
            voteVC.memberId = memberId
            voteVC.voteId = voteId
            voteVC.groupId = groupId
            voteVC.campaignBalance = loanCampaignBalance
            print("campaignBalance: \(loanCampaignBalance)")
            voteVC.loanVotesCompleted = loanVotesCompleted
            voteVC.loanVotesRemaining = loanVotesRemaining
            voteVC.loanDestinationNumber = loanDestinationNumber
            voteVC.loan = loan
            voteVC.memberNetwork = memberNetwork
            voteVC.currency = currency
            
        } else if makeApprover == 1 {
            
            voteVC.groupId = groupId
            voteVC.memberId = memberId
            voteVC.makeApprover = makeApprover
            
        } else if makeAdmin == 1 {
            
            voteVC.groupId = groupId
            voteVC.memberId = memberId
            voteVC.makeAdmin = makeAdmin
        }
        
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        //present dialog
        present(popup, animated: animated, completion: nil)
        
    }
    
    
    
    func showRoleVoteDialog1(animated: Bool = true, groupId: String, voteType: String) {
        
        //create a custom view controller
        let voteVC = RoleVotingViewController(nibName: "RoleVotingViewController", bundle: nil)
        let vc: ConfirmVoteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "confirm") as! ConfirmVoteVC
        
        //        roleVotingViewController.admin = admin
        //        roleVotingViewController.groupId = groupId
        
        vc.groupId = vGroupId
        vc.voteId = vVoteId
        vc.memberId = vMemberId
        vc.name = vName
        
        if voteType == "makeadmin"{

            voteVC.groupId = vGroupId
            voteVC.memberId = vMemberId
            voteVC.voteId = vVoteId
            voteVC.name = vName
            voteVC.voteType = "makeadmin"
            vc.voteType = "makeadmin"
            for item in memberVotedInGroup {
                if item.voteId == vVoteId {
                    if item.hasMemberVoted == true {
                        showAlert(title: "Make Admin", message: "You have already voted to make \(vName) an admin.")
                    }else {
                        
                    }
                }
            }

        }else if voteType == "makeapprover"{
            
            voteVC.groupId = vGroupId
            voteVC.memberId = vMemberId
            voteVC.voteId = vVoteId
            voteVC.name = vName
            voteVC.voteType = "makeapprover"
            vc.voteType = "makeapprover"
            for item in memberVotedInGroup {
                if item.voteId == vVoteId {
                    if item.hasMemberVoted == true {
                        showAlert(title: "Make Approver", message: "You have already voted to make \(vName) an approver.")
                    }else {
                        
                    }
                }
            }

        }else if voteType == "revokeadmin"{
            
            voteVC.groupId = vGroupId
            voteVC.memberId = vMemberId
            voteVC.voteId = vVoteId
            voteVC.name = vName
            voteVC.voteType = "revokeadmin"
            vc.voteType = "revokeadmin"
            for item in memberVotedInGroup {
                if item.voteId == vVoteId {
                    if item.hasMemberVoted == true {
                        showAlert(title: "Revoke Admin", message: "You have already voted to revoke \(vName)'s admin rights.")
                    }else {
                        
                    }
                }
            }

        }else if voteType == "revokeapprover"{
            
            voteVC.groupId = vGroupId
            voteVC.memberId = vMemberId
            voteVC.voteId = vVoteId
            voteVC.name = vName
            voteVC.voteType = "revokeapprover"
            vc.voteType = "revokeapprover"
            for item in memberVotedInGroup {
                if item.voteId == vVoteId {
                    if item.hasMemberVoted == true {
                        showAlert(title: "Revoke Approver", message: "You have already voted to revoke \(vName)'s approver rights.")
                    }else {
                        
                    }
                }
            }

        }else if voteType == "dropmember"{
            
            voteVC.groupId = vGroupId
            voteVC.memberId = vMemberId
            voteVC.voteId = vVoteId
            voteVC.name = vName
            voteVC.voteType = "dropmember"
            vc.voteType = "dropmember"
            for item in memberVotedInGroup {
                if item.voteId == vVoteId {
                    if item.hasMemberVoted == true {
                        showAlert(title: "Remove Member", message: "You have already voted to remove \(vName) from the group.")
                    }else {
                        
                    }
                }
            }

        }else if voteType == "cashout"{
            
            voteVC.cashoutAmount = vAmount
            voteVC.cashoutCampaignName = vCampaignName
            voteVC.cashoutCampaignBalance = vCampaignBalance
            voteVC.campaignId = vCampaignId
            voteVC.cashoutDestination = vDestination
            voteVC.memberId = vMemberId
            voteVC.memberNetwork = vMemberNetwork
            voteVC.cashoutDestinationNumber = vDestinationNumber
            voteVC.voteId = vVoteId
            voteVC.groupId = vGroupId
            voteVC.name = vName
            voteVC.voteType = vVoteType
            voteVC.currency = currency
            
            vc.amount  = vAmount
            vc.campaignName = vCampaignName
            vc.campaignBalance = vCampaignBalance
            vc.campaignId = vCampaignId
            vc.destination = vDestination
            vc.memberNetwork = vMemberNetwork
            vc.destinationNumber = vDestinationNumber
            vc.currency = currency
            vc.voteType = vVoteType
            vc.destinationCode = vDestinationCode
            for item in memberVotedInGroup {
                if item.voteId == vVoteId {
                    if item.hasMemberVoted == true {
                        showAlert(title: "Approve Cashout", message: "You have already voted on \(vName)'s cashout request.")
                    }else {
                        
                    }
                }
            }
            


        }else if voteType == "loan"{
            
            voteVC.amount = vAmount
            voteVC.reason = vReason
            voteVC.campaignName = vCampaignName
            voteVC.campaignBalance = vCampaignBalance
            voteVC.campaignId = vCampaignId
            voteVC.loanDestination = vDestination
            voteVC.memberId = vMemberId
            voteVC.memberNetwork = vMemberNetwork
            voteVC.loanDestinationNumber = vDestinationNumber
            voteVC.voteId = vVoteId
            voteVC.groupId = vGroupId
            voteVC.voteType = vVoteType
            voteVC.name = vName
            voteVC.currency = currency
            
            vc.amount  = vAmount
            vc.reason = vReason
            vc.campaignName = vCampaignName
            vc.campaignBalance = vCampaignBalance
            vc.campaignId = vCampaignId
            vc.destination = vDestination
            vc.memberNetwork = vMemberNetwork
            vc.destinationNumber = vDestinationNumber
            vc.currency = currency
            vc.voteType = vVoteType
            for item in memberVotedInGroup {
                if item.voteId == vVoteId {
                    if item.hasMemberVoted == true {
                        showAlert(title: "Approve Borrowing", message: "You have already voted on \(vName)'s borrow request.")
                    }else {
                        
                    }
                }
            }

        }
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        //present dialog
//        present(popup, animated: animated, completion: nil)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        
    }

    
    
    func fetchAllMembers(completionHandler: @escaping FetchAllMembersCompletionHandler){
        var members: MembersRTDB!
        let memberRef = Database.database().reference().child("users").child("\(authProviderId)")
        _ = memberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //                    if let dict = snapshot as? Dictionary<String, AnyObject> {
            if let snapshotValue = snapshot.value as? [String:AnyObject] {
            
            print("dict: \(snapshot)")
            
            members = MembersRTDB(email_: "", memberId_: "", msisdn_: "", name_: "")
            
            if let em = snapshotValue["email"] as? String {
                print(em)
                print(snapshotValue)
                members.email = em
            }
            if let memId = snapshotValue["memberId"] as? String {
                members.memberId = memId
            }
            if let msi = snapshotValue["msisdn"] as? String {
                members.msisdn = msi
            }
            if let nam = snapshotValue["name"] as? String {
                members.name = nam
            }
            
            
            //                    }
            completionHandler(members)
            print(members)
            }
        })
        
    }
    
    
    func fetchBallotSummary(completionHandler: @escaping FetchBallotSummaryCompletionHandler){
        var ballots: BallotSummaryRTDB!
        let ballotsRef = Database.database().reference().child("ballot_summary").child("\(groupId)")
        _ = ballotsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? [String:AnyObject] {
            
            print("ballot dict: \(snapshot)")
            
            ballots = BallotSummaryRTDB(groupId_: "", minVoteCount_: 0, voteId_: "", votesCompleted_: 0, votesRemaining_: 0)
            
            if let grpId = snapshotValue["groupId"] as? String {
                ballots.groupId = grpId
            }
            if let minVoteCnt = snapshotValue["minVoteCount"] as? Int {
                ballots.minVoteCount = minVoteCnt
            }
            if let votId = snapshotValue["voteId"] as? String {
                ballots.voteId = votId
            }
            if let votCompltd = snapshotValue["votesCompleted"] as? Int {
                ballots.votesCompleted = votCompltd
            }
            if let votRemaining = snapshotValue["voteRemaining"] as? Int {
                ballots.votesRemaining = votRemaining
            }
            
            completionHandler(ballots)
            print("ballots: \(ballots)")
            }
        })
    }

    
    
    
    //Retrieving pending votes from Firebase RealTime Database
    func fetchAllPendingVotes(completionHandler: @escaping FetchAllPendingVotesCompletionHandler) {
        
        var pendingVotes: [PendingVotes] = []
        
        let pendingVotesRef = Database.database().reference().child("votes").child("\(groupId)")
        _ = pendingVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                for snapDict in snapshotValue {
                    print("snapdict")
                    let dict = snapDict.value as! Dictionary<String, AnyObject>
                    print(dict)
                    if let votesArray = dict as? NSDictionary {
                        print("votesArray: \(votesArray)")
                        
                        var amt = ""
                        if let amount = votesArray.value(forKey: "amount") as? String {
                            amt = amount
                        }
                        
                        var cmgnId = ""
                        if let campaignId = votesArray.value(forKey: "campaignId") as? String {
                            cmgnId = campaignId
                        }
                        
                        var cmgnNm = ""
                        if let campaignName = votesArray.value(forKey: "campaignName") as? String {
                            cmgnNm = campaignName
                        }
                        
                        var campBal = ""
                        if let campaignBalance = votesArray.value(forKey: "campaignBalance") as? String {
                            campBal = campaignBalance
                        }
                        
                        var ntwrk = ""
                        if let network = votesArray.value(forKey: "network") as? String {
                            ntwrk = network
                        }
                        
                        var cshDst = ""
                        if let cashoutDestination = votesArray.value(forKey: "cashoutDestination") as? String {
                            cshDst = cashoutDestination
                        }
                        
                        var cshDstCd = ""
                        if let cashoutDestinationCode = votesArray.value(forKey: "cashoutDestinationCode") as? String {
                            cshDstCd = cashoutDestinationCode
                        }
                        
                        var cshDstNmbr = ""
                        if let cashoutDestinationNumber = votesArray.value(forKey: "cashoutDestinationNumber") as? String {
                            cshDstNmbr = cashoutDestinationNumber
                        }
                        
                        var rsn = ""
                        if let reason = votesArray.value(forKey: "reason") as? String {
                            rsn = reason
                        }
                        
                        var vtCnt = ""
                        if let voteCount = votesArray.value(forKey: "voteCount") as? String {
                            vtCnt = voteCount
                        }
                        
                        var rl = ""
                        if let role = votesArray.value(forKey: "role") as? String {
                            rl = role
                        }
                        
                        var mem = ""
                        if let memberId = votesArray.value(forKey: "memberId") as? String {
                            //                        print(self.memberId)
                            mem = memberId
                        }
                        
                        var nmeMem = ""
                        if let nameOfMemberActionIsAbout = votesArray.value(forKey: "nameOfMemberActionIsAbout") as? String {
                            nmeMem = nameOfMemberActionIsAbout
                        }
                        
                        var authProvId = ""
                        if let authProviderId = votesArray.value(forKey: "authProviderId") as? String {
                            authProvId = authProviderId
                        }
                        self.memberId = mem
                        self.authProviderId = authProvId
                        self.voteCampaignId = cmgnId
                        
                        if self.authProviderId == "" {
                            
                        }else {
                            self.fetchAllMembers { (result) in
                                self.memberDeets = result
                                print("mem: \(self.memberDeets.name)")
                                    
                                let votes = PendingVotes(amount_: amt, campaignId_: cmgnId, campaignName_: cmgnNm, campaignBalance_: campBal, groupId_: votesArray.value(forKey: "groupId") as! String, memberId_: votesArray.value(forKey: "memberId") as! String, nameOfMemberActionIsAbout_: nmeMem, authProviderId_: votesArray.value(forKey: "authProviderId") as! String, network_: ntwrk, voteId_: votesArray.value(forKey: "voteId") as! String, voteType_: votesArray.value(forKey: "voteType") as! String , cashoutDestination_: cshDst, cashoutDestinationCode_: cshDstCd, cashoutDestinationNumber_: cshDstNmbr, reason_: rsn, voteCount_: vtCnt, role_: rl, membersRTDB_: self.memberDeets/*, ballotSummary_: self.ballotSummary*/)
                                    
                                    pendingVotes.append(votes)
                                    print("votes votes: \(pendingVotes)")
                                    for item in pendingVotes {
                                        print("members: \(item.membersRTDB.name)")
                                    }
                                    completionHandler(pendingVotes)
                            }
                        }
                    }
                }
            }
            print("info: \(pendingVotes)")
            completionHandler(pendingVotes)
        })
    }
    
    
        //VOTE SUMMARY
        func getMemberVotedInGroup(getMemberVotedInGroupParameter: GetMemberVotedInGroupParameter) {
            AuthNetworkManager.getMemberVotedInGroup(parameter: getMemberVotedInGroupParameter) { (result) in
                self.parseGetMemberVotedInGroup(result: result)
            }
        }
        
        
        private func parseGetMemberVotedInGroup(result: DataResponse<[GetMemberVotedInGroupResponse], AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print("response: \(response)")
                
                memberVotedInGroup.append(response)
                
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
    
    //MIN VOTE REQUIRED
    func getMinVoteAllBallots(getMinVotesParameter: MinVotesAllBallotsParameter) {
        AuthNetworkManager.getMinVoteAllBallots(parameter: getMinVotesParameter) { (result) in
            self.parseGetMinVoteAllBallotsResponse(result: result)
        }
    }
    
    
    private func parseGetMinVoteAllBallotsResponse(result: DataResponse<[MinVoteRequiredAllBallots], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            for item in response {
                if item.ballotId == "cashout" {
                    cashoutMinVoteCount = item.minVoteRequired
                }
                if item.ballotId == "loan" {
                    borrowMinVoteCount = "\(item.minVoteRequired)"
                }
                if item.ballotId == "revokeadmin" {
                    revokeAdminMinVoteCount = item.minVoteRequired
                }
                if item.ballotId == "makeadmin" {
                    makeAdminMinVoteCount = item.minVoteRequired
                }
                if item.ballotId == "revokeapprover" {
                    revokeApproverMinVoteCount = item.minVoteRequired
                }
                if item.ballotId == "makeapprover" {
                    makeApproverMinVoteCount = item.minVoteRequired
                }
                if item.ballotId == "dropmember" {
                    dropMemberMinVoteCount = item.minVoteRequired
                }
                
            }
            
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
