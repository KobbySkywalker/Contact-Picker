//
//  CashoutTypeVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import FirebaseDatabase
import FirebaseAuth

class CashoutTypeVC: BaseViewController {
    
    @IBOutlet weak var amount: ACFloatingTextfield!
    @IBOutlet weak var reason: ACFloatingTextfield!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var minVoteCountLabel: UILabel!
    @IBOutlet weak var groupBalanceLabel: UILabel!
    @IBOutlet weak var maxCashoutLimit: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var ballotSummary: BallotSummaryRTDB!
    typealias FetchBallotSummaryCompletionHandler = (_ groups: BallotSummaryRTDB ) -> Void
    
    var members: [MemberResponse] = []
    var groupId: String = ""
    var voteId: String = ""
    var campaignId: String = ""
    var network: String = ""
    var minVoteCount: Int = 0
    var groupBalance: String = ""
    var minVote: Double = 0.0
    var groupSize: Int = 0
    var campaignBalances: [GroupBalance] = []
    var maxCashoutLimitPerDay: Double = 0.0
    var cashoutVotesCompleted: Int = 0
    var cashoutVotesRemaining: Int = 0
    var currency: String = ""
    var countryId: String = ""
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        
        self.title = "Cashout"
        
        
        //        self.fetchBallotSummary{ [self] (result) in
        //            print("result: \(result)")
        //            print("ball: \(result.minVoteCount), \(result.votesRemaining), \(result.votesCompleted)")
        //
        //            print("min vote count: \(self.minVoteCount)")
        //            minVoteCount = result.minVoteCount
        //            if minVoteCount == 0 {
        //            minVoteCountLabel.text = "The number of people required to vote for Cashout is \(self.minVote)"
        //
        //            }else {
        //            minVoteCountLabel.text = "The number of people required to vote for Cashout is \(self.minVoteCount)"
        //            }
        //
        //
        //        }
        let parameter: MinVotesAllBallotsParameter = MinVotesAllBallotsParameter(groupId: groupId)
        getMinVoteAllBallots(getMinVotesParameter: parameter)
        
        let parameters: GetMemberParameter = GetMemberParameter(groupId: groupId)
        getMembers(getMembersParameter: parameters)
        
        balanceLabel.text = "Balance (\(currency))"
        for item in campaignBalances {
            if item.campaignId == campaignId {
                groupBalanceLabel.text = "\(formatNumber(figure: item.balance))"
            }
        }
        
        let largeNumber = maxCashoutLimitPerDay
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
        
        maxCashoutLimit.text = "Max. cashout per destination is \(currency)\(formattedNumber!)"
        //        maxCashoutLimit.isHidden = true
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selfButtonAction(_ sender: UIButton) {
        
        let validAmountCheck = amount.text?.components(separatedBy: ".")
        
        if amount.text!.isEmpty {
            let alert = UIAlertController(title: "Cashout", message: "Please enter an amount before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if validAmountCheck?.count > 2 {
            
            let alert = UIAlertController(title: "Cashout", message: "Please enter a valid amount.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if amount.text == "." {
            
            let alert = UIAlertController(title: "Cashout", message: "Please enter a valid amount.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if reason.text!.isEmpty {
            let alert = UIAlertController(title: "Cashout", message: "Please enter a reason before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            
            let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC
            
            vc.groupId = self.groupId
            vc.campaignId = self.campaignId
            vc.voteId = self.voteId
            vc.network = self.network
            vc.reason = self.reason.text!
            vc.cashoutAmount = self.amount.text!
            vc.recipientName = (self.user?.displayName!)!
            vc.forSelf = 1
            vc.paymentOption = "wallet"
            vc.transactionType = 1
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @IBAction func memberButtonAction(_ sender: UIButton) {
        
        let validAmountCheck = amount.text?.components(separatedBy: ".")
        
        if amount.text!.isEmpty {
            let alert = UIAlertController(title: "Cashout", message: "Please enter an amount before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if validAmountCheck?.count > 2 {
            
            let alert = UIAlertController(title: "Cashout", message: "Please enter a valid amount.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if amount.text == "." {
            
            let alert = UIAlertController(title: "Cashout", message: "Please enter a valid amount.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if reason.text!.isEmpty {
            let alert = UIAlertController(title: "Cashout", message: "Please enter a reason before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            let vc: MemberSearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "membersearch") as! MemberSearchViewController
            
            vc.members = members
            vc.cashout = 1
            vc.groupId = groupId
            vc.campaignId = campaignId
            vc.voteId = voteId
            vc.network = network
            vc.reason = reason.text!
            vc.amount = Double(amount.text!)!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func otherButtonAction(_ sender: UIButton) {
        
        let validAmountCheck = amount.text?.components(separatedBy: ".")
        
        if amount.text!.isEmpty {
            let alert = UIAlertController(title: "Cashout", message: "Please enter an amount before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if validAmountCheck?.count > 2 {
            
            let alert = UIAlertController(title: "Cashout", message: "Please enter a valid amount.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if amount.text == "." {
            
            let alert = UIAlertController(title: "Cashout", message: "Please enter a valid amount.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if reason.text!.isEmpty {
            let alert = UIAlertController(title: "Cashout", message: "Please enter a reason before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            
            let vc: CashoutOtherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashoutother") as! CashoutOtherVC
            
            vc.reason = self.reason.text!
            vc.amount = self.amount.text!
            vc.groupId = self.groupId
            vc.campaignId = self.campaignId
            vc.voteId = self.voteId
            vc.network = self.network
            vc.countryId = countryId
            //                vc.paymentOption = "bank"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    func getMembers(getMembersParameter: GetMemberParameter) {
        AuthNetworkManager.getMembers(parameter: getMembersParameter) { (result) in
            self.parseGetMembersResponse(result: result)
        }
    }
    
    private func parseGetMembersResponse(result: DataResponse<[MemberResponse], AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            for item in response {
                members.append(item)
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
        if voteId == "" {
            print("There's no vote id")
            
        }else {
            
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
                        self.cashoutVotesCompleted = Int(votesCompleted)
                    }
                    
                    var votRemaining = 0
                    if let votesRemaining = snapshotValue["votesRemaining"] as? Int {
                        //                ballots.votesRemaining = votCompltd
                        votRemaining = votesRemaining
                        print("votes Remaining: \(votesRemaining)")
                        self.cashoutVotesRemaining = Int(votesRemaining)
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
                if item.ballotId == "cashout"{
                    minVoteCountLabel.text = "The number of people required to vote for Cashout is \(item.minVoteRequired)"
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
