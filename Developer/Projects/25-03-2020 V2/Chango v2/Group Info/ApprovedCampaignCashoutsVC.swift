//
//  ApprovedCampaignCashoutsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 02/07/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import FTIndicator

class ApprovedCampaignCashoutsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, FZAccordionTableViewDelegate {
    
    @IBOutlet weak var tableView: FZAccordionTableView!
    @IBOutlet weak var totalContributionsLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var creatorInfoLabel: UILabel!
    
    var campaign: GetGroupCampaignsResponse!
    var groupContributions: CampaignContributionResponse!
    var groupContribution: [Content] = []
    var privateGroup: GroupResponse!
    var searchGroups: [CampaignContributionResponse] = []
    var filtered_groups: [Content] = []
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    let cell = "cellId"
    var label = ""
    var groupId: String = ""
    var groupNamed: String = ""
    var campaignId: String = ""
    var campaignStatus: String = ""
    var campaignDetails: [GetGroupCampaignsResponse] = []
    var defaultCashouts: ApprovedCashoutResponse!
    var cashoutModel: [CashoutModel] = []
    var creatorInfo: String = ""
    
    let cellReuseIdentifier = "MyCell"
    let bankCell = "bankCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()

        groupNameLabel.text = privateGroup.groupName
        creatorInfoLabel.text = creatorInfo
        if (privateGroup.groupIconPath == "<null>") || (privateGroup.groupIconPath == ""){
            groupImageView.image = UIImage(named: "defaultgroupicon")
                    print(privateGroup.groupIconPath)
            groupImageView.contentMode = .scaleAspectFit
            
        }else {
            groupImageView.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: privateGroup.groupIconPath!)!, into: groupImageView)
            
        }
        
        
        tableView.allowMultipleSectionsOpen = true
        tableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "DetailedContributionCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(UINib(nibName: "BankAddressCell", bundle: nil), forCellReuseIdentifier: bankCell)
        self.tableView.tableFooterView = UIView()
        
        print("status: \(campaignStatus)")
        
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let parameter: ApprovedCashoutParameter = ApprovedCashoutParameter(campaignId: campaignId, offset: 0, pageSize: 100)
        approvedCashouts(approvedCashoutParameter: parameter)

        print("for loop end")
        //SearchBar
        searchController.searchBar.placeholder = "Search Contributor"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupGroups(){
        self.tableView.reloadData()
    }
    
    func searchMethod(searchText: String){
        filtered_groups.removeAll()
        searchIndexes.removeAll()
        if(searchText.isEmpty){
            searched = false
            self.setupGroups()
            return
        }else if(searchController.isActive && !(searchText.isEmpty)){
            filtered_groups = groupContribution.filter({ (group : Content) -> Bool in
                
                return ((group.memberId.firstName.lowercased().contains(searchText.lowercased())))
                
            })
            searched = true
            self.setupGroups()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filtered_groups.removeAll(keepingCapacity: false)
        let array = groupContribution.filter ({
            ($0.memberId.firstName.localizedCaseInsensitiveContains(searchText))
        })
        filtered_groups = array
        
        self.tableView.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
        searchMethod(searchText: searchController.searchBar.text!)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
        searchMethod(searchText: searchText)
    }
    
    
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: date)
        
        dateFormatter1.dateFormat = "MMM dd"
        dateFormatter1.timeZone = TimeZone.autoupdatingCurrent
        let timeStamp = dateFormatter1.string(from: date!)
        print(timeStamp)
        return timeStamp
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
            
            
            if defaultCashouts.empty == true {
                print("show empty")
                self.emptyView.isHidden = false
            }
            
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
                totalContributionsLabel.text = "\(privateGroup.countryId.currency)\(finalTotal)"
            }
            
            tableView.reloadData()
            
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cashoutModel[section].contents.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
                return cashoutModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cashoutModel[indexPath.section].cashoutDestination == "bank"{
            return 70.0
        }else {
        return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MenuSectionHeaderView.kDefaultAccordionHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white

        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        cashoutModel[indexPath.section].contents = cashoutModel[indexPath.section].contents.sorted(by: {$0.created > $1.created})
        let date = formatter.date(from: self.cashoutModel[indexPath.section].contents[indexPath.row].created)
        let dates = timeAgoSinceDate(date!)
        formatter.dateStyle = DateFormatter.Style.medium
        
        if cashoutModel[indexPath.section].cashoutDestination == "bank"{
            let cell: BankAddressCell = self.tableView.dequeueReusableCell(withIdentifier: bankCell) as! BankAddressCell

            cell.bankName.text = getBankNameFromCode(bankCode: cashoutModel[indexPath.section].contents[indexPath.row].cashoutDestinationCode)
            cell.bankAccount.text = "\(cashoutModel[indexPath.section].contents[indexPath.row].destinationNumber)"
            cell.amount.text = "\(privateGroup.countryId.currency)\(cashoutModel[indexPath.section].contents[indexPath.row].amount)"
            cell.date.text = dates

            return cell
        }else {
            
        let cell: DetailedContributionCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DetailedContributionCell
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        cashoutModel[indexPath.section].contents = cashoutModel[indexPath.section].contents.sorted(by: {$0.created > $1.created})
        let date = formatter.date(from: self.cashoutModel[indexPath.section].contents[indexPath.row].created)
        let dates = timeAgoSinceDate(date!)
        formatter.dateStyle = DateFormatter.Style.medium
        
        cell.amount.text = dates
        print("expand amount: \(cashoutModel[indexPath.section].contents[indexPath.row].amount)")
        cell.date.text = "\(privateGroup.countryId.currency)\(cashoutModel[indexPath.section].contents[indexPath.row].amount)"
        
        return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
        
        let user: String! = UserDefaults.standard.string(forKey: "users")
        sectionHeader.destinationNumber.isHidden = false
        sectionHeader.sectionTitleLabel.text = "\(cashoutModel[section].destinationAccountName)"
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
        
//        sectionHeader.amount.text = "8000"
//        sectionHeader.img.image = UIImage(named: "individual")
//        sectionHeader.sectionTitleLabel.text = "100"
        
        print("arrow changed")
        return sectionHeader
    }
}

