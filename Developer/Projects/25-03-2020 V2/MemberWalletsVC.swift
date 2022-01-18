//
//  MemberWalletsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 09/06/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import ESPullToRefresh

class MemberWalletsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var forMember: Int = 0
    var recipientNumber: String = ""
    var recipientName: String = ""
    var groupId: String = ""
    var network: String = ""
    var campaignId: String = ""
    var paymentOption: String = ""
    var voteId: String = ""
    var amount: String = ""
    var reason: String = ""
    
    var memberId: String = ""
    var memberWallets: [PaymentWallet] = []
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]
    let cell = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        
        FTIndicator.showProgress(withMessage: "loading wallets")
        let parameter: GetMemberWalletsParameter = GetMemberWalletsParameter(memberId: memberId)
        getMemberWallets(getMemberWalletsParameter: parameter)
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            let parameter: GetMemberWalletsParameter = GetMemberWalletsParameter(memberId: memberId)
            getMemberWallets(getMemberWalletsParameter: parameter)
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberWallets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 99.0
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wallet = memberWallets[indexPath.row]
        
            let cell: GroupsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            
            cell.memberCampaignCount.isHidden = true
            cell.groupType.isHidden = true
            if (wallet.channelId == "WALLET") || (wallet.channelId == "wallet") {
                cell.groupsImage.contentMode = .scaleAspectFit
                if wallet.destinationCode! == "MTN" {
                    cell.groupsImage.image = UIImage(named: "mtn_airtime")
                    cell.groupsImage.backgroundColor = UIColor(hexString: "#F3C743")
                    cell.groupsName.text = "MTN Mobile Money"
                }else if wallet.destinationCode! == "VODAFONE" {
                    cell.groupsImage.image = UIImage(named: "vodafoneicon")
                    cell.groupsImage.backgroundColor = UIColor(hexString: "#DB483C")
                    cell.groupsName.text = "Vodafone Cash"
                }else {
                    cell.groupsImage.image = UIImage(named: "airteltigoicon")
                    cell.groupsImage.backgroundColor = UIColor(hexString: "#315284")
                    cell.groupsName.text = "AirtelTigo Cash"
                }
                cell.memerCampaignLabel.text = "Mobile"
            }else {
                cell.groupsImage.image = UIImage(named: "banksicon")
                cell.memerCampaignLabel.text = wallet.destinationCode
                
                if wallet.nickName == "nil" || wallet.nickName == nil {
                    cell.groupsName.text = wallet.destinationCode
                    
                }else {
                    cell.groupsName.text = wallet.nickName
                }
            }
            
            var destinationString = wallet.paymentDestinationNumber
            
            let start = destinationString!.index(destinationString!.startIndex, offsetBy: 0);
            let end = destinationString!.index(destinationString!.endIndex, offsetBy: -4);
            destinationString!.replaceSubrange(start..<end, with: "xxxxxxxx")
            
            cell.groupsDate.text = destinationString
            cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wallet = memberWallets[indexPath.row]
        var destinationString = wallet.paymentDestinationNumber

        let vc: CashoutSummaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashoutsummary") as! CashoutSummaryVC
        
        let start = destinationString!.index(destinationString!.startIndex, offsetBy: 0);
        let end = destinationString!.index(destinationString!.endIndex, offsetBy: -4);
        destinationString!.replaceSubrange(start..<end, with: "xxxxxxxx")
        vc.maskedWallet = destinationString!
        
        vc.forMember = forMember
        vc.recipientNumber = wallet.paymentDestinationNumber!
        vc.recipientName = self.recipientName
        vc.groupId = self.groupId
        vc.network = self.network
        vc.campaignId = self.campaignId
        vc.cashoutDestinationCode = wallet.destinationCode!
        vc.nameOnWallet = wallet.nickName ?? ""
        if wallet.channelId == "bank" || wallet.channelId == "BANK" {
        vc.paymentOption = "bank"
        vc.bankName = wallet.destinationCode!
        }else {
        vc.paymentOption = "wallet"
        }
        vc.voteId = self.voteId
        vc.amount = self.amount
        vc.reason = self.reason
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getMemberWallets(getMemberWalletsParameter: GetMemberWalletsParameter) {
        AuthNetworkManager.getMemberWallets(parameter: getMemberWalletsParameter) { (result) in
            self.parseGetMemberWallets(result: result)
        }
    }
    
    private func parseGetMemberWallets(result: DataResponse<MemberWalletResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            memberWallets = []
            for item in response.paymentWallets {
                print("trannsaction")
                if !(item.channelId! == "card"){
                    if !(item.channelId! == "CARD"){
                        print("dont show cards")
                        memberWallets.append(item)
                    }
                }
            }
            if memberWallets.count < 0 || memberWallets.isEmpty {
                emptyView.isHidden = false
            }
            self.memberWallets = memberWallets.sorted(by: {$0.created > $1.created})
            
            self.tableView.reloadData()
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
    
}
