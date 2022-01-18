//
//  CampaignContributionsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 11/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Nuke

class CampaignContributionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, FZAccordionTableViewDelegate {
    
    //    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: FZAccordionTableView!
    @IBOutlet weak var totalContributions: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var contributionLabel: UILabel!
    @IBOutlet weak var contributionView: UIView!
    
    var campaign: GetGroupCampaignsResponse!
    var groupContributions: CampaignContributionResponse!
    var otherCampaignContributions: [GetCampaignContributionResponse] = []
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
    var campaignContributions: [ContributionSections] = []
    var campaignContribution: [GetCampaignContributionResponse] = []
    var contributions: [ContributionSections] = []
    
    let cellReuseIdentifier = "MyCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()

        tableView.allowMultipleSectionsOpen = true
        tableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "DetailedContributionCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        button.frame = CGRect(x: 0, y: 0, width: 31, height: 31)
        button.setImage(UIImage(named: "dona"), for: .normal)
        button.addTarget(self, action: #selector(self.makeContributionButtonAction(_:)), for: .touchUpInside)
        
        contributionLabel.text = "Total Contributions (\(privateGroup.countryId.currency))"
        print("status: \(campaignStatus)")
        print("contributions: \(campaignContributions)")
        
        campaignComputation(campaignContribution: campaignContribution)
//        for i in 0 ..< groupContributions.content.count {
//            let contributorsFirstName = contributions.map { return $0.firstName }
//            let contributorsLastName = contributions.map { return $0.lastName }
//            let memId = contributions.map { return $0.memberId }
//
//
//            print(contributorsLastName)
//            print(contributorsFirstName)
//
//            if (contributorsFirstName.contains(groupContributions.content[i].memberId.firstName) && contributorsLastName.contains(groupContributions.content[i].memberId.lastName ?? "null") && memId.contains(groupContributions.content[i].memberId.memberId!)) {
//                let filteredArray = contributions.filter { $0.firstName  == groupContributions.content[i].memberId.firstName && $0.lastName == groupContributions.content[i].memberId.lastName && $0.memberId == groupContributions.content[i].memberId.memberId!}
//
//                if (filteredArray.count != 0) {
//                    let item = filteredArray.first!
//                    item.contributions.append(groupContributions.content[i])
//                    if (groupContributions.content[i].memberId.memberIconPath) == nil {
//                        item.memberIconPath.append("")
//                    }else {
//                        item.memberIconPath = (groupContributions.content[i].memberId.memberIconPath!)
//                    }
//                    var totalAmount: Double = 0.0
//                    for i in 0 ..< item.contributions.count {
//                        totalAmount = totalAmount + item.contributions[i].amount
//                    }
//                    item.totalAmount = totalAmount
//                    print("C C: \(item)")
//                    print(totalAmount)
//                }
//            }else {
//                let section = ContributionSections()
//                section.firstName = groupContributions.content[i].memberId.firstName
//                section.lastName = groupContributions.content[i].memberId.lastName ?? "null"
//                section.memberId = groupContributions.content[i].memberId.memberId!
//                section.contributions.append(groupContributions.content[i])
//                section.totalAmount = groupContributions.content[i].amount
//                if (groupContributions.content[i].memberId.memberIconPath) == nil {
//                    section.memberIconPath = ""
//                }else {
//                    section.memberIconPath = (groupContributions.content[i].memberId.memberIconPath!)
//                }
//                contributions.append(section)
//                print("campaignContributions: \(contributions)")
//            }
//            if groupContributions.content[i].campaignId.amountReceived == nil {
//                totalContributions.text = "GHS 0.00"
//                emptyView.isHidden = false
//            }else {
//                totalContributions.text = String(format:"%.2f",  groupContributions.content[i].campaignId.amountReceived!)
//            }
//        }
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
    
    func campaignComputation(campaignContribution: [GetCampaignContributionResponse]){
        for i in 0 ..< campaignContribution.count {
            let contributorsFirstName = contributions.map { return $0.firstName }
            let contributorsLastName = contributions.map { return $0.lastName }
            let memId = contributions.map { return $0.memberId }

            
            print(contributorsLastName)
            print(contributorsFirstName)
            
            if (contributorsFirstName.contains(campaignContribution[i].memberId.firstName) && contributorsLastName.contains(campaignContribution[i].memberId.lastName ?? "null") && memId.contains(campaignContribution[i].memberId.memberId!)) {
                let filteredArray = contributions.filter { $0.firstName  == campaignContribution[i].memberId.firstName && $0.lastName == campaignContribution[i].memberId.lastName && $0.memberId == campaignContribution[i].memberId.memberId!}
                
                if (filteredArray.count != 0) {
                    let item = filteredArray.first!
                    item.contribution.append(campaignContribution[i])
                    if (campaignContribution[i].memberId.memberIconPath) == nil {
                        item.memberIconPath.append("")
                    }else {
                        item.memberIconPath = (campaignContribution[i].memberId.memberIconPath!)
                    }
                    var totalAmount: Double = 0.0
                    for i in 0 ..< item.contribution.count {
                        totalAmount = totalAmount + item.contribution[i].amount
                    }
                    item.totalAmount = totalAmount
                    print("C C: \(item)")
                    print(totalAmount)
                }
            }else {
                let section = ContributionSections()
                section.firstName = campaignContribution[i].memberId.firstName
                section.lastName = campaignContribution[i].memberId.lastName ?? "null"
                section.memberId = campaignContribution[i].memberId.memberId!
                section.contribution.append(campaignContribution[i])
                section.totalAmount = campaignContribution[i].amount
                if (campaignContribution[i].memberId.memberIconPath) == nil {
                    section.memberIconPath = ""
                }else {
                    section.memberIconPath = (campaignContribution[i].memberId.memberIconPath!)
                }
                contributions.append(section)
                print("campaignContributions: \(contributions)")
            }
            if campaignContribution[i].campaignId.amountReceived == nil {
                totalContributions.text = "0.00"
                emptyView.isHidden = false
            }else {
                totalContributions.text = "\(formatNumber(figure: campaignContribution[i].campaignId.amountReceived!))"
            }
        }
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
    
    
    
    
    @IBAction func makeContributionButtonAction(_ sender: UIBarButtonItem) {
        
        if (campaignStatus == "pause") {
            showAlert(title: "Alert", message: "This campaign has been paused.")
        }else if campaignStatus == "stop"{
            showAlert(title: "Alert", message: "This campaign has been stopped.")
        }else {
            let vc: ContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contribute") as! ContributeViewController
            vc.defCont = 0
            vc.campaignDetails = campaign
            vc.groupNamed = groupNamed
            vc.campaignId = campaignId
            //vc.campaignName = campaign.campaignName
            vc.groupId = privateGroup.groupId
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributions[section].contribution.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contributions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
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
        let cell: DetailedContributionCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DetailedContributionCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        
        cell.amount.text = "\(contributions[indexPath.section].contribution[indexPath.row].amount)"
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date = formatter.date(from: self.contributions[indexPath.section].contribution[indexPath.row].created)
        
        let dates = timeAgoSinceDate(date!)
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        cell.date.text = dates
                
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
        
        let url = URL(string: contributions[section].memberIconPath)
        print("url: \(String(describing: url))")
        sectionHeader.img.image = nil
        if(contributions[section].memberIconPath == "nil"){
            if(contributions[section].memberIconPath == ""){
                print("ha")
                print(contributions[section].memberIconPath+" : No Image")
                sectionHeader.img.image = UIImage(named: "individual")
            }
        }else {
            if url == nil {
                sectionHeader.img.image = UIImage(named: "individual")
            }else {
                Nuke.loadImage(with: url!, into: sectionHeader.img)
                print("url: \(url!)")
            }
        }
        let user: String! = UserDefaults.standard.string(forKey: "users")
        if user == "\(contributions[section].firstName) \(contributions[section].lastName)" {
            sectionHeader.sectionTitleLabel.text = "You"
        }else {
            sectionHeader.sectionTitleLabel.text = "\(contributions[section].firstName) \(contributions[section].lastName)"
        }
        sectionHeader.amount.text = String(format: "%0.2f", contributions[section].totalAmount)
        print("arrow changed")
        return sectionHeader
    }
}
