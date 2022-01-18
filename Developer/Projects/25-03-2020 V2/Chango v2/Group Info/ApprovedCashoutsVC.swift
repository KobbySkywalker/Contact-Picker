//
//  ApprovedCashoutsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 15/06/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import Nuke

class ApprovedCashoutsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FZAccordionTableViewDelegate {
    
    @IBOutlet weak var cashoutTableView: FZAccordionTableView!
    @IBOutlet weak var campaignsTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var defaultCashoutView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var totalCashouts: UILabel!
    @IBOutlet weak var emptyViewString: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var campaignsButtonTitle: UIButton!
    @IBOutlet weak var cashoutButtonTitle: UIButton!
    
    
    var campaignId: String = ""
    var groupId: String = ""
    var campaignDetails: [GetGroupCampaignsResponse] = []
    var defaultCashouts: ApprovedCashoutResponse!
    var cashoutModel: [CashoutModel] = []
    var privateGroup: GroupResponse!
    var groupNamed: String = ""
    var status: String = ""
    var created: String = ""
    
    var names: [String] = ["A","B","C","D"]
    var amounts: [String] = ["20","30","40","50"]
    var totalAmounts: [String] = ["100","150","170","190"]
    
    let cell = "cellId"
    let cellReuseIdentifier = "MyCell"
    let bankCell = "bankCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        cashoutTableView.allowMultipleSectionsOpen = true
        
        cashoutTableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier)
        
        cashoutTableView.register(UINib(nibName: "DetailedContributionCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        cashoutTableView.register(UINib(nibName: "BankAddressCell", bundle: nil), forCellReuseIdentifier: bankCell)
        self.cashoutTableView.tableFooterView = UIView()
        
        cashoutTableView.tableFooterView = UIView(frame: .zero)

        self.campaignsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.campaignsTableView.register(UINib(nibName: "GroupCampaignsCell", bundle: nil), forCellReuseIdentifier: "GroupCampaignsCell")
        self.campaignsTableView.tableFooterView = UIView()
        
        let parameter: ApprovedCashoutParameter = ApprovedCashoutParameter(campaignId: campaignId, offset: 0, pageSize: 100)
        approvedCashouts(approvedCashoutParameter: parameter)
        
         let param: GroupCampaignsParameter = GroupCampaignsParameter(groupId: groupId)
         self.getGroupCampaign(groupCampaignsParameter: param)
        
        self.title = "Approved Cashouts"
        
        if (privateGroup.groupIconPath == "<null>") || (privateGroup.groupIconPath == ""){
            groupIcon.image = UIImage(named: "defaultgroupicon")
                    print(privateGroup.groupIconPath)
            groupIcon.contentMode = .scaleAspectFit
            
        }else {
            groupIcon.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: privateGroup.groupIconPath!)!, into: groupIcon)
            
        }
        
        groupNameLabel.text = privateGroup.groupName
        createdLabel.text = "\(created)"
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cashoutButtonAction(_ sender: Any) {
        cashoutButtonTitle.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        campaignsButtonTitle.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        defaultCashoutView.isHidden = false
        campaignsTableView.isHidden = true
    }
    
    
    @IBAction func campaignsButtonAction(_ sender: Any) {
        campaignsButtonTitle.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        cashoutButtonTitle.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        defaultCashoutView.isHidden = true
        campaignsTableView.isHidden = false
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            defaultCashoutView.isHidden = false
//            campaignsView.isHidden = true
            print("default: \(self.defaultCashouts)")
            if self.defaultCashouts.empty == true {
                self.emptyView.isHidden = false
                self.emptyViewString.text = "No Approved Cashouts"
                print("hidden")
                //                }
            }else{
                self.emptyView.isHidden = true
                print("show")
                
            }
            
            break
        case 1:
            defaultCashoutView.isHidden = true
//            campaignsView.isHidden = false
            //            campaignsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            if (self.campaignDetails.count > 0){
                self.emptyView.isHidden = true
                print("hide empty view")
            }else{
                self.emptyView.isHidden = false
                self.emptyViewString.text = "There are no available campaigns for this group"
//                self.emptyInfo.text = "No campaigns."
            }
            
            break
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == cashoutTableView) {
            return cashoutModel.count
//            return names.count
        }else if (tableView == campaignsTableView){
            return 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cashoutTableView {
            if (defaultCashouts == nil) {
                return 0
            }else {
                return cashoutModel[section].contents.count
//                return 0
            }
        }else {
            return campaignDetails.count
        }
    }
    
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if (tableView == cashoutTableView) {
                if cashoutModel[indexPath.section].cashoutDestination == "bank" {
                    return 70.0
                }else {
                return 40.0
                }
            }else {
                return 184.0
            }
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if (tableView == cashoutTableView) {
                return MenuSectionHeaderView.kDefaultAccordionHeaderViewHeight
            }else {
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            if (tableView == cashoutTableView) {
                return self.tableView(tableView, heightForRowAt: indexPath)
                
            }else {
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            if (tableView == cashoutTableView) {
                return self.tableView(tableView, heightForHeaderInSection:section)
            }else {
                return 0
            }
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            if (tableView == cashoutTableView) {

                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                cashoutModel[indexPath.section].contents = cashoutModel[indexPath.section].contents.sorted(by: {$0.created > $1.created})
                let date = formatter.date(from: self.cashoutModel[indexPath.section].contents[indexPath.row].created)
                let dates = timeAgoSinceDate(date!)
                formatter.dateStyle = DateFormatter.Style.medium
                
                if cashoutModel[indexPath.section].cashoutDestination == "bank"{
                    print("bank account")
                    let cell: BankAddressCell = self.cashoutTableView.dequeueReusableCell(withIdentifier: bankCell) as! BankAddressCell
                    cell.bankName.text = getBankNameFromCode(bankCode: cashoutModel[indexPath.section].contents[indexPath.row].cashoutDestinationCode)
//                    "\(cashoutModel[indexPath.section].contents[indexPath.row].cashoutDestinationCode)"
                    cell.bankAccount.text = "\(cashoutModel[indexPath.section].contents[indexPath.row].destinationNumber)"
                    cell.amount.text = "\(privateGroup.countryId.currency) \(cashoutModel[indexPath.section].contents[indexPath.row].amount)"
                    cell.date.text = dates

                    return cell
                }else {
                    print(cashoutModel[indexPath.section].cashoutDestination)
                    
                    //dropdown
                    let cell: DetailedContributionCell = self.cashoutTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DetailedContributionCell
                    cell.selectionStyle = .none
                    let backgroundView = UIView()
                    backgroundView.backgroundColor = UIColor.white
                    
                    cell.amount.text = dates
                    print("expand amount: \(cashoutModel[indexPath.section].contents[indexPath.row].amount)")
                    cashoutModel[indexPath.section].contents = cashoutModel[indexPath.section].contents.sorted(by: {$0.created > $1.created})
                    cell.date.text = "\(privateGroup.countryId.currency)\(cashoutModel[indexPath.section].contents[indexPath.row].amount)"
                    return cell
                }
//                cell.amount.text = amounts[indexPath.section]
//                cell.date.text = totalAmounts[indexPath.section]
                
            }else{
                let cell: GroupCampaignsCell = self.campaignsTableView.dequeueReusableCell(withIdentifier: "GroupCampaignsCell", for: indexPath) as! GroupCampaignsCell
                cell.selectionStyle = .none
                
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let date = formatter.date(from: self.campaignDetails[indexPath.row].modified!)
                
                formatter.dateStyle = DateFormatter.Style.medium
                _ = formatter.string(from: date as! Date)
                
                var dayLeft = Date()
                var endDate = Date()
                if campaignDetails[indexPath.row].campaignType == "temporary" {
                    if (Date() > endDate) && (campaignDetails[indexPath.row].status == "running") && (campaignDetails[indexPath.row].campaignType == "temporary"){
                        cell.daysLeft.text = "No days left"
                        
                    }else if (campaignDetails[indexPath.row].end! == nil) || (campaignDetails[indexPath.row].end! == "") || (campaignDetails[indexPath.row].end! == "nil") {
                        
                    }
//                    else {
//                        print("end:\(self.campaignDetails[indexPath.row].end!)")
//                        dayLeft = formatter.date(from: self.campaignDetails[indexPath.row].end!)!
//                        _ = formatter.string(from: dayLeft as! Date)
//                        formatter.dateStyle = DateFormatter.Style.medium
//                        _ = formatter.string(from: date as! Date)
//
//                        let daysLeftNow = daysLeft(dayLeft)
//                        print("days left: \(daysLeft)")
//                        cell.daysLeft.text = daysLeftNow
//                    }
                }
                else {
                    cell.daysLeft.text =  "Perpetual"
                }
                
                
                let dates = timeAgoSinceDate(date!)
                
                let myCampaigns: GetGroupCampaignsResponse = self.campaignDetails[indexPath.row]
                cell.campaignName.text = myCampaigns.campaignName
                print("campaignName: \(myCampaigns.campaignName)")
                cell.campaignImage.image = UIImage(named: "defaultgroupicon")
                cell.campaignDate.text = "Created on \(dateConversion(dateValue: myCampaigns.created))"
                cell.campaignDescription.text = myCampaigns.description
                
                cell.amountRaised.text = "\(privateGroup.countryId.currency)\(myCampaigns.amountReceived!)"
                cell.totalAmount.text = "\(privateGroup.countryId.currency)\(myCampaigns.target!)"
                cell.progressBar.progress = Float(myCampaigns.amountReceived!/myCampaigns.target!)
                
                campaignDetails = campaignDetails.sorted(by: { $0.modified > $1.modified})
                return cell
            }
            
        }
        
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
//            let url = URL(string: cashoutModel[section].groupIconPath)
            let user: String! = UserDefaults.standard.string(forKey: "users")
            sectionHeader.destinationNumber.isHidden = false
            sectionHeader.sectionTitleLabel.text = "\(cashoutModel[section].destinationAccountName.localizedCapitalized)"
//            if(cashoutModel[section].groupIconPath == "nil"){
//                if(cashoutModel[section].groupIconPath == ""){
//                    print("ha")
//                    print(cashoutModel[section].groupIconPath+" : No Image")
//                    sectionHeader.img.image = UIImage(named: "individual")
//                }
//            }else {
//                if url == nil {
//                    sectionHeader.img.image = UIImage(named: "individual")
//                }else{
//                    Nuke.loadImage(with: url!, into: sectionHeader.img)
//                    print("url: \(url!)")
//                }
//            }
            sectionHeader.amount.text = "\(privateGroup.countryId.currency)\(String(format: "%0.2f", cashoutModel[section].totalAmount))"
//            sectionHeader.sectionTitleLabel.text = "\(names[section])"
//            sectionHeader.amount.text = String(format: "%0.2f", totalAmounts[section])
            sectionHeader.img.image = UIImage(named: "budget")
            sectionHeader.destinationNumber.text = "\(cashoutModel[section].destinationNumber)"
            
            return sectionHeader
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if (tableView == cashoutTableView) {
                print("tapped")
            }else{
                    let vc: ApprovedCampaignCashoutsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "approvecamp") as! ApprovedCampaignCashoutsVC

                    let myCampaigns: GetGroupCampaignsResponse = self.campaignDetails[indexPath.row]

                    groupNamed = myCampaigns.campaignName
                    campaignId = myCampaigns.campaignId
                    status = myCampaigns.status!
                
                vc.campaignId = myCampaigns.campaignId
                vc.creatorInfo = created
                vc.privateGroup = privateGroup
                
                self.navigationController?.pushViewController(vc, animated: true)

                
            }
        }
        
        func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
            print("will close")
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
            
            sectionHeader.arrowImageView.image = UIImage(named: "closeup")
        }
        
        func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
            print("open section")
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
        }
     
    
    
    //APPROVED CASHOUTS
    func approvedCashouts(approvedCashoutParameter: ApprovedCashoutParameter){
        AuthNetworkManager.approvedCashout(parameter: approvedCashoutParameter) { (result) in
            self.parseApprovedCashoutsResponse(result: result)
        }
    }
    
    private func parseApprovedCashoutsResponse(result: DataResponse<ApprovedCashoutResponse, AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            FTIndicator.dismissProgress()
            
            defaultCashouts = response
            
            for i in 0 ..< defaultCashouts.content.count {
                let recipientFirstName = cashoutModel.map { return $0.destinationAccountName }
                let destinationAccountNumber = cashoutModel.map { return $0.destinationNumber}
                
                if (recipientFirstName.contains(defaultCashouts.content[i].destinationAccountName) && (destinationAccountNumber.contains(defaultCashouts.content[i].destinationNumber))) {
                    let filteredArray = cashoutModel.filter { $0.destinationAccountName == defaultCashouts.content[i].destinationAccountName && $0.destinationNumber == defaultCashouts.content[i].destinationNumber
                }
                    if (filteredArray.count != 0)
                    {
                        let item = filteredArray.first!
                        item.contents.append(defaultCashouts.content[i])
                        
                        var totalAmount: Double = 0.0
                        for i in 0 ..< item.contents.count {
                            
                            totalAmount = totalAmount + item.contents[i].amount
                        }
                        item.totalAmount = totalAmount
                    }
                }else {
                    let section = CashoutModel()
                    
                    section.destinationAccountName = defaultCashouts.content[i].destinationAccountName
                    section.destinationNumber = defaultCashouts.content[i].destinationNumber
                    section.contents.append(defaultCashouts.content[i])
                    section.totalAmount = defaultCashouts.content[i].amount
                    section.cashoutDestination = defaultCashouts.content[i].cashoutDestination
                    section.cashoutDestinationCode = defaultCashouts.content[i].cashoutDestinationCode
                    cashoutModel.append(section)
                }
                var sumTotal: Double = 0.0
                for i in 0 ..< cashoutModel.count {
                    sumTotal = sumTotal + cashoutModel[i].totalAmount
                }
                let finalTotal = String(format: "%.2f", sumTotal)
                totalCashouts.text = "\(finalTotal)"
            }
            
            cashoutTableView.reloadData()
            
            if defaultCashouts.empty == true {
                self.emptyView.isHidden = false
            }else {
            }
            
            break
        case .failure(let error):
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
    
        //GROUP CAMPAIGN CASHOUTS
        func getGroupCampaign(groupCampaignsParameter: GroupCampaignsParameter) {
            AuthNetworkManager.getGroupCampaign(parameter: groupCampaignsParameter) { (result) in
                self.parseGetGroupCampaignResponse(result: result)
            }
        }
        
        private func parseGetGroupCampaignResponse(result: DataResponse<[GetGroupCampaignsResponse], AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                campaignDetails.removeAll()
                print("response: \(response)")
                    
                    for item in response {
                        self.campaignDetails.append(item)
                    }
                campaignsTableView.reloadData()
                
                if campaignDetails.count < 0 {
                    print("show no campaigns")
                    self.emptyView.isHidden = false
                    self.emptyViewString.text = "There are no available campaigns for this group"
                }
                    
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


func getBankNameFromCode(bankCode: String) -> String {
    switch bankCode {
    case "SCB":
        return "Standard Chartered Bank"
    case "EBG":
        return "Ecobank"
    case "CAL":
        return "CAL Bank"
    case "GCB":
        return "Ghana Commercial Bank"
    case "NIB":
        return "National Investment Bank"
    case "UMB":
        return "Universal Merchant Bank"
    case "HFC":
        return "Republic Bank"
    case "ADB":
        return "Agricultural Development Bank"
    case "BBG":
        return "Barclays Bank"
    case "ZBL":
        return "Zenith Bank"
    case "PBL":
        return "Prudential Bank"
    case "SBG":
        return "Stanbic Bank"
    case "GTB":
        return "GT Bank"
    case "UBA":
        return "United Bank of Africa"
    case "FNB":
        return "First National Bank"
    case "ABN":
        return "Access Bank"
    case "FBL":
        return "Fidelity Bank"
    case "CBG":
        return "Consolidated Bank"
    case "BOA":
        return "Bank of Afica"
    case "FBN":
        return "First Bank of Nigeria"
    case "FSL":
        return "First Allied Savings & Loans"
    case "BOB":
        return "Bank of Baroda"
    case "ARB":
        return "ARB Apex Bank Limited"
    case "GHL":
        return "GHL Bank"
    case "FAB":
        return "First Atlantic Bank"
    case "BOG":
        return "Bank of Ghana"
    case "SSB":
        return "Sahel Sahara Bank (BSIC)"
    case "GMY":
        return "G-Money"
    default:
        return bankCode
    }
}
