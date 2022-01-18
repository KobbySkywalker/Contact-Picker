//
//  ApproveBorrowingVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 05/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import MultiProgressView
import FirebaseDatabase
import PopupDialog
import FirebaseAuth
import Nuke

class ApproveBorrowingVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var voteSummaryButton: UIButton!
    @IBOutlet weak var votersButton: UIButton!
    @IBOutlet weak var circularProgress: CircularProgressBar!
    @IBOutlet weak var groupBalance: UILabel!
    @IBOutlet weak var requiredVotes: UILabel!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var borrowerLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var destinationAccountLabel: UILabel!
    
    //voters view
    @IBOutlet weak var votersView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var votedTableView: UITableView!
    @IBOutlet weak var notVotedTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var yesVoteStack: UIStackView!
    @IBOutlet weak var noVoteStack: UIStackView!
    
    
    var campaignName: String = ""
    var campaignId: String = ""
    var loaner: String = ""
    var reason: String = ""
    var amount: String = ""
    var loanDestination: String = ""
    var memberId: String = ""
    var voteId: String = ""
    var groupId: String = ""
    var campaignBalance: String = ""
    var loanVotesCompleted: Int = 0
    var loanVotesRemaining: Int = 0
    var loanDestinationNumber: String = ""
    var currency: String = ""
    var voteCount: Double = 0.0
    
    var finalComp: Double = 0.0
    var finalRem: Double = 0.0
    
    var votescompleted: String = ""
    var votesRequired: String = ""
    var minVoteCount: String = ""
    
    var ballotSummary: BallotSummaryRTDB!
    typealias FetchBallotSummaryCompletionHandler = (_ groups: BallotSummaryRTDB ) -> Void
    
    //voters view
    var votedMembers: [Member] = []
    var notVotedMembers: [Member] = []
    let cell = "cellId"
    var viewOnly: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showChatController()
        disableDarkMode()
        
        groupBalance.text = "\(currency)\(campaignBalance)"
        campaignNameLabel.text = campaignName
        borrowerLabel.text = loaner
        reasonLabel.text = reason
        amountLabel.text = amount
        destinationAccountLabel.text = loanDestinationNumber

        if viewOnly == true {
            noVoteStack.isHidden = true
            yesVoteStack.isHidden = true
        }
        
        self.requiredVotes.text = "Total number of required votes: \(self.minVoteCount)"

        var i_progress = voteCount
        self.circularProgress.showProgressText = true
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {_ in
//            i_progress = 0.5

            self.circularProgress.innerProgress = CGFloat(i_progress)
            self.circularProgress.progress = CGFloat(i_progress)
        })
        
        
        //voters view

               let parameter: GetVotedParameter = GetVotedParameter(groupId: groupId, voteId: voteId)
               self.getVotedMembers(getVotedMembersParameter: parameter)
               
               let parameters: GetNotVotedParameter = GetNotVotedParameter(groupId: groupId, voteId: voteId)
               self.getNotVotedMembers(getNotVotedMembersParameter: parameters)
                
                self.votedTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
                self.votedTableView.register(UINib(nibName: "VoteCell", bundle: nil), forCellReuseIdentifier: "VoteCell")

                
                self.notVotedTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
                self.notVotedTableView.register(UINib(nibName: "VoteCell", bundle: nil), forCellReuseIdentifier: "VoteCell")
    }
    
    @IBAction func voteSummaryButtonAction(_ sender: Any) {
        voteSummaryButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        votersButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        votersView.isHidden = true

    }
    
    @IBAction func votersButtonAction(_ sender: Any) {
        votersButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        voteSummaryButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        votersView.isHidden = false

    }
    
    @IBAction func yesButtonAction(_ sender: Any) {
//        self.showVoteYes(amount: self.amount, campaignId: self.campaignId, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.loanDestinationNumber, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "1", voteId: self.voteId)
        let vc: VoteCompletionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "completevote") as! VoteCompletionVC
        vc.voteType = "borrow"
        vc.voteOption = "yes"
        vc.votePreference = "approve"
        vc.amount = amount
        vc.campaignId = campaignId
        vc.destination = loanDestination
        vc.destinationCode = ""
        vc.destinationNumber = loanDestinationNumber
        vc.groupId = groupId
        vc.memberId = memberId
        vc.voteId = voteId
        vc.reason = reason
        vc.currency = currency

        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func noButtonAction(_ sender: Any) {
//        self.showVoteNo(amount: self.amount, campaignId: self.campaignId, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.loanDestinationNumber, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "0", voteId: self.voteId)
        let vc: VoteCompletionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "completevote") as! VoteCompletionVC
        vc.voteType = "borrow"
        vc.voteOption = "no"
        vc.votePreference = "disapprove"
        vc.amount = amount
        vc.campaignId = campaignId
        vc.destination = loanDestination
        vc.destinationCode = ""
        vc.destinationNumber = loanDestinationNumber
        vc.groupId = groupId
        vc.memberId = memberId
        vc.voteId = voteId
        vc.reason = reason
        vc.currency = currency
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            votedTableView.isHidden = false
            notVotedTableView.isHidden = true

            print("count: \(votedMembers.count)")
            if (self.votedMembers.count > 0){
                self.emptyView.isHidden = true
                print("segmented voted hidden")
            }else {
                self.emptyView.isHidden = false
                print("segmented not hidden for not voted")
            }
            
            break
        case 1:
            notVotedTableView.isHidden = false
            votedTableView.isHidden = true

            if (self.notVotedMembers.count > 0){
                self.emptyView.isHidden = true
                print("segmented not voted hidden")
            }else {
                self.emptyView.isHidden = false
                print("segmented not hidden for not voted")
            }
            break
        default:
            break
        }
    }
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if (tableView == votedTableView){
            return votedMembers.count
        }else {
            return notVotedMembers.count
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if (tableView == votedTableView){
                let cell: VoteCell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as! VoteCell
                cell.selectionStyle = .none
                cell.voteButton.isHidden = true
                cell.memberName.isHidden = true
                
                let members: Member = self.votedMembers[indexPath.row]
                
                cell.groupName.text = "\(members.firstName) \(members.lastName)"
                cell.voteIcon.image = nil
                cell.voteIcon.image = UIImage(named: "defaulticon")
                if(members.memberIconPath == "<null>") || (members.memberIconPath == nil) || (members.memberIconPath == "") {
                    cell.voteIcon.image = UIImage(named: "defaulticon")
                    
                }else {
                    let url = URL(string: members.memberIconPath!)
                    
                    Nuke.loadImage(with: url!, into: cell.voteIcon)
                }
    //            cell.memberStatus.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1)
                
                return cell
            } else if (tableView == notVotedTableView){
                
                let cell: VoteCell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as! VoteCell
                cell.selectionStyle = .none
                cell.voteButton.isHidden = true
                cell.memberName.isHidden = true
                
                let members: Member = self.notVotedMembers[indexPath.row]
                
                cell.groupName.text = "\(members.firstName) \(members.lastName)"
                cell.voteIcon.image = nil
                cell.voteIcon.image = UIImage(named: "defaulticon")
                if(members.memberIconPath == "<null>") || (members.memberIconPath == nil) || (members.memberIconPath == "") {
                    cell.voteIcon.image = UIImage(named: "defaulticon")
                    
                }else {
                    let url = URL(string: members.memberIconPath!)
                    
                    Nuke.loadImage(with: url!, into: cell.voteIcon)
                }
    //            cell.memberStatus.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1)
                return cell
            }else {
                let cell: MemberCell = self.notVotedTableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
                cell.selectionStyle = .none
                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    
        
        func getVotedMembers(getVotedMembersParameter: GetVotedParameter) {
            AuthNetworkManager.getVotedMembers(parameter: getVotedMembersParameter) { (result) in
                self.parseGetVotedMembersResponse(result: result)
            }
        }
        
        
        private func parseGetVotedMembersResponse(result: DataResponse<[Member], AFError>){
            switch result.result {
            case .success(let response):
                print("response: \(response)")
                for item in response {
                    self.votedMembers.append(item)
                    print(response.count)
                

                }
                self.votedTableView.reloadData()
                print("member count: \(self.votedMembers.count)")
                if (self.votedMembers.count > 0){
                    self.emptyView.isHidden = true
                    print("hidden")
                }else {
                    self.emptyView.isHidden = false
                    print("not hidden for voted")
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
        
        
        func getNotVotedMembers(getNotVotedMembersParameter: GetNotVotedParameter) {
            AuthNetworkManager.getNotVotedMembers(parameter: getNotVotedMembersParameter) { (result) in
                self.parseGetNotVotedMembersResponse(result: result)
            }
        }
        
        
        private func parseGetNotVotedMembersResponse(result: DataResponse<[Member], AFError>){
            switch result.result {
            case .success(let response):
                print("response: \(response)")
                
                for item in response {
                    self.notVotedMembers.append(item)
                }
                
                self.notVotedTableView.reloadData()
                if (self.notVotedMembers.count > 0){
                    self.emptyView.isHidden = true
                    print("hidden")
                }else {
                    self.emptyView.isHidden = false
                    print("not hidden for not voted")
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
    
    
    
    
    func fetchBallotSummary(completionHandler: @escaping FetchBallotSummaryCompletionHandler){
        var ballots: BallotSummaryRTDB!
        
        let ballotsRef = Database.database().reference().child("ballot_summary").child("\(groupId)").child("\(voteId)")
        print("voteId \(voteId)")
        _ = ballotsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? [String:AnyObject] {
            
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
                self.loanVotesCompleted = Int(votesCompleted)
            }
            
            var votRemaining = 0
            if let votesRemaining = snapshotValue["votesRemaining"] as? Int {
                //                ballots.votesRemaining = votCompltd
                votRemaining = votesRemaining
                print("votes Remaining: \(votesRemaining)")
                self.loanVotesRemaining = Int(votesRemaining)
            }
            
            let ballots = BallotSummaryRTDB(groupId_: grpId, minVoteCount_: minVoteCnt, voteId_: votId, votesCompleted_: votCompltd, votesRemaining_: votRemaining)
            
            self.ballotSummary = ballots
            
            
            print("vot comp: \(votCompltd), vot rem: \(votRemaining)")
            completionHandler(ballots)
            print("ballots: \(ballots.minVoteCount)")
            }else {
                
                let ballots = BallotSummaryRTDB(groupId_: "", minVoteCount_: 0, voteId_: "", votesCompleted_: 0, votesRemaining_: 0)
                completionHandler(ballots)
            }
        })
            
    }
    
    //GRANT LOAN
    func grantLoan(grantLoanParameter: GrantLoanParameter) {
        AuthNetworkManager.grantLoan(parameter: grantLoanParameter) { (result) in
            //self.parseAddMemberResponse(result: result)
            print(result)
            FTIndicator.dismissProgress()
            
            let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            

        }
    }
    
    
    func executeLoan(executeLoanParameter: ExecuteLoanParameter) {
        AuthNetworkManager.executeLoan(parameter: executeLoanParameter) { (result) in
            self.parseExecuteLoan(result: result)
        }
    }
    
    private func parseExecuteLoan(result: DataResponse<RegularResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            break
        case .failure(_):
            FTIndicator.dismissProgress()
            
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
    
    
        //POP UP DIALOG
        func showVoteYes(animated: Bool = true, amount: String, campaignId: String, cashoutDestination: String, cashoutDestinationCode: String, cashoutDestinationNumber: String, groupId: String, memberId: String, reason: String, status: String, voteId: String) {
            
            //create a custom view controller
            let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
            
            //create the dialog
            let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            
            voteVC.voteTitle.text = "Vote"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to approve borrowing request of")
            formattedString.bold(" \(currency) \(amount)")
            formattedString.normal(" from")
            formattedString.bold(" \(cashoutDestinationNumber)")
            formattedString.normal(" ?")
            
            voteVC.voteDescription.attributedText = formattedString
            //                "Are you sure you want to vote to make \(name) an admin? This action cannot be undone."
            
            //create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
                
    //            self.dismiss(animated: true, completion: nil)
    //            popup.dismiss(animated: true, completion: nil)


            }
            DefaultButton.appearance().titleColor = .gray
            //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
            CancelButton.appearance().titleColor = .gray
            
            
            //create second button
            let buttonTwo = DefaultButton(title: "YES", height: 60) {
                
                popup.dismiss(animated: true, completion: nil)
//                let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.loanDestinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "1", voteId: self.voteId)
//
//                self.grantLoan(grantLoanParameter: parameter)
                
                let parameter: ExecuteLoanParameter = ExecuteLoanParameter(campaignId: self.campaignId, status: "1", voteId: self.voteId)
                self.executeLoan(executeLoanParameter: parameter)
                FTIndicator.showProgress(withMessage: "voting")
                
    //            self.dismiss(animated: true, completion: nil)

            }
            
            buttonTwo.tintColor = UIColor.green
            //Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            //Present dialog
            present(popup, animated: animated, completion: nil)
            
        }
        
        
        
        func showVoteNo(animated: Bool = true, amount: String, campaignId: String, cashoutDestination: String, cashoutDestinationCode: String, cashoutDestinationNumber: String, groupId: String, memberId: String, reason: String, status: String, voteId: String) {
            
            //create a custom view controller
            let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
            
            //create the dialog
            let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            
            
            
            voteVC.voteTitle.text = "Vote"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to deny borrowing request of")
            formattedString.bold(" \(currency) \(amount)")
            formattedString.normal(" from")
            formattedString.bold(" \(campaignName)")
            formattedString.normal(" to this number ")
            formattedString.bold(" \(cashoutDestinationNumber)")
            formattedString.normal(" ?")
            
            voteVC.voteDescription.attributedText = formattedString
            
            
            //create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
                
    //            self.dismiss(animated: true, completion: nil)

                
            }
            DefaultButton.appearance().titleColor = .gray
            //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
            CancelButton.appearance().titleColor = .gray
            
            
            //create second button
            
            let buttonTwo = DefaultButton(title: "YES", height: 60) {
                
                popup.dismiss(animated: true, completion: nil)
//                let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.loanDestinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "0", voteId: self.voteId)
//
//                self.grantLoan(grantLoanParameter: parameter)
                
                let parameter: ExecuteLoanParameter = ExecuteLoanParameter(campaignId: self.campaignId, status: "0", voteId: self.voteId)
                self.executeLoan(executeLoanParameter: parameter)
                
                FTIndicator.showProgress(withMessage: "voting")
                
            }
            
            buttonTwo.tintColor = UIColor.green
            //Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            //Present dialog
            present(popup, animated: animated, completion: nil)
            
        }
    
}
