 //
//  MakeContributionsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 07/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import Nuke
import ESPullToRefresh

 class MakeContributionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, FZAccordionTableViewDelegate  {
    
    var campaign: GetGroupCampaignsResponse!
    var privateGroup: GroupResponse!
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var groupContributions: CampaignContributionResponse!
    var defaultContributions: DefaultCampaignResponse!
    var defaultContribution: ContributionsPage!
    var sections: [ContributionSection] = []
//    var contributions: [ContributionSection] = []
    var contribution: [ContributionSections] = []
    
    var campaignContribution: [GetCampaignContributionResponse] = []
    var campContri: Content!
    var campaignSections: [ContributionSection] = []
    var campContributions: [ContributionSection] = []
    var campContribution: [ContributionSection] = []
    
    var campaignsOnly: [String] = []
    var adminResponse: String = ""
    var group = ""
    var groupName = ""
    var currency = ""
    var groupNamed: String = ""
    var campaignId: String = ""
    var label = ""
    var dateExtract: [String] = []
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]
    
    var didSelectCheck: Int = 0
    
    
    @IBOutlet weak var contributeButton: UIBarButtonItem!
    @IBOutlet weak var defaultCampaignView: UIView!
    @IBOutlet weak var totalContribution: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var contributionLabel: UILabel!
    @IBOutlet weak var defaultTableView: FZAccordionTableView!
    @IBOutlet weak var emptyInfo: UILabel!
    
    var searchGroups: [GetGroupCampaignsResponse] = []
    var filtered_groups: [GetGroupCampaignsResponse] = []
    var filtered_contributors: [ContributionSections] = []
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var buttonDisappear: Int = 0
    var status: String = ""
    var members: [MemberResponse] = []
    var page: Int = 1
    
    let cell = "cellId"
    let cellReuseIdentifier = "MyCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
//        contributionLabel.text = "Total Contributions(\(privateGroup.countryId.currency))"
        print("currency: \(privateGroup.countryId.currency)")
        //        Default Contributions
        //        FTIndicator.showProgress(withMessage: "loading contributions", userInteractionEnable: false)
//        let parameterr: defaultCampaignParameter = defaultCampaignParameter(groupId: group)
//        self.defaultCampaign(defaultCampaignParameter: parameterr)
        
//        let parr: GroupContributionsParameter = GroupContributionsParameter(groupId: group, offset: "0", pageSize: "900")
//        self.groupContributions(groupContributionsParameter: parr)
        contributionLabel.text = "Total Contribution (\(privateGroup.countryId.currency))"
        FTIndicator.showProgress(withMessage: "loading")
        print("campaignId: \(privateGroup.defaultCampaignId) - \(campaignId)")
        let par: CampaignContributionParameter = CampaignContributionParameter(campaignId: campaignId ?? "")
        self.getCampaignContribution(campaignContributionParameter: par)
        print("start loading")

        
        defaultTableView.allowMultipleSectionsOpen = true
        
        defaultTableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier)
        
        defaultTableView.register(UINib(nibName: "DetailedContributionCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.defaultTableView.tableFooterView = UIView()
        
        defaultTableView.tableFooterView = UIView(frame: .zero)

        //Check if user is admin
        let parameter: IsAdminParameter = IsAdminParameter(groupId: group)
        isAdmin(isAdminParameter: parameter)
        //SearchBar
        //        searchController.searchBar.placeholder = "Search By Contributor"
        //        searchController.searchResultsUpdater = self
        //        searchController.dimsBackgroundDuringPresentation = false
        //        searchController.hidesNavigationBarDuringPresentation = false
        //        //        self.tableView.tableHeaderView = searchController.searchBar
        //        searchController.searchBar.isHidden = true
        //        self.definesPresentationContext = true
        //        searchController.delegate = self
        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        if #available(iOS 11.0, *) {
        //            navigationItem.searchController = searchController
        //        }
        
        //        defaultTableView.refreshControl = UIRefreshControl()
        //        defaultTableView.refreshControl?.attributedTitle = NSAttributedString(string: "loading")
        //        defaultTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        //
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh() {
//        let parameterr: defaultCampaignParameter = defaultCampaignParameter(groupId: self.group)
//        self.defaultCampaign(defaultCampaignParameter: parameterr)
        
        //            let parr: GroupContributionsParameter = GroupContributionsParameter(groupId: self.group, offset: "0", pageSize: "100")
        //            self.groupContributions(groupContributionsParameter: parr)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func setupContributions(){
        self.defaultTableView.reloadData()
    }
    
    
    func searchMethod(searchText: String){
        filtered_groups.removeAll()
        searchIndexes.removeAll()
        if(searchText.isEmpty){
            searched = false
            self.setupContributions()
            return
        }else if(searchController.isActive && !(searchText.isEmpty)){
            filtered_groups = campaignInfo.filter({ (member : GetGroupCampaignsResponse) -> Bool in
                
                return (member.campaignName.lowercased().contains(searchText.lowercased()))
                
            })
            searched = true
            self.setupContributions()
        }
        
        //contributors
        filtered_contributors.removeAll()
        searchIndexes.removeAll()
        if(searchText.isEmpty){
            searched = false
            self.setupContributions()
            return
        }else if(searchController.isActive && !(searchText.isEmpty)){
            filtered_contributors = contribution.filter({ (name: ContributionSections) -> Bool in
                
                return (name.firstName.lowercased().contains(searchText.lowercased())) && (name.lastName.lowercased().contains(searchText.lowercased()))
            })
            searched = true
            self.setupContributions()
        }
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filtered_groups.removeAll(keepingCapacity: false)
        let array = campaignInfo.filter ({
            $0.campaignName.localizedCaseInsensitiveContains(searchText)
        })
        filtered_groups = array
        
        //        self.campaignsTableView.reloadData()
        
        filtered_contributors.removeAll(keepingCapacity: false)
        let array2 = contribution.filter ({
            $0.firstName.localizedCaseInsensitiveContains(searchText) && $0.lastName.localizedCaseInsensitiveContains(searchText)
        })
        filtered_contributors = array2
        
        self.defaultTableView.reloadData()
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
        
        let vc: ContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contribute") as! ContributeViewController
        vc.defCont = 1
        vc.campaignDetails = campaign
        vc.defaultContributions = defaultContributions
        vc.groupNamed = groupName
        vc.currency = currency
        vc.campaignId = privateGroup.defaultCampaignId ?? ""
        vc.groupId = privateGroup.groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func addCampaignButtonAction(_ sender: UIButton) {
        
    }
    
    
    
    //GROUP CONTRIBUTIONS
    func getcampaignContributions(campaignContributionsParameter: CampaignContributionsParameter) {
        AuthNetworkManager.campaignContributions(parameter: campaignContributionsParameter) { (result) in
            self.parseCampaignContributionsResponse(result: result)
        }
    }
    
    private func parseCampaignContributionsResponse(result: DataResponse<CampaignContributionResponse, AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            self.groupContributions = response
            
            let vc: CampaignContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "camp") as! CampaignContributionsViewController
            vc.groupContributions = response
            vc.privateGroup = self.privateGroup
            vc.groupNamed = self.groupNamed
            vc.campaignId = self.campaignId
            vc.campaignStatus = self.status
            //            vc.campaignName = campaignInfo
            vc.campaignContributions = self.contribution
            vc.label = self.label
            print(self.status)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                self.sessionTimeout()
            }else {
                self.showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
                }
            }
    }
    
    
    //IS ADMIN
    func isAdmin(isAdminParameter: IsAdminParameter) {
        AuthNetworkManager.isAdmin(parameter: isAdminParameter) { (result) in
            print("result: \(result)")
            self.adminResponse = result
            FTIndicator.dismissProgress()
        }
    }
    
    private func parseIsAdmin(result: DataResponse<String, AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
//    func defaultCampaign(defaultCampaignParameter: defaultCampaignParameter){
//        AuthNetworkManager.defaultCampaign(parameter: defaultCampaignParameter) { (result) in
//            self.parseDefaultCampaignResponse(result: result)
//        }
//    }
    
//    private func parseDefaultCampaignResponse(result: DataResponse<DefaultCampaignResponse, AFError>){
//        switch result.result {
//        case .success(let response):
//            print(response)
//            defaultContributions = nil
//            defaultContributions = response
//            print("def: \(defaultContributions)")
//            FTIndicator.dismissProgress()
//            for i in 0 ..< defaultContributions.contributions.count {
//                let contributors = contributions.map { return $0.firstName }
//                let contributorsLast = contributions.map { return $0.lastName }
//
//                if (contributors.contains(defaultContributions.contributions[i].memberId.firstName) && contributorsLast.contains(defaultContributions.contributions[i].memberId.lastName)) {
//                    let filteredArray = contributions.filter { $0.firstName == defaultContributions.contributions[i].memberId.firstName && $0.lastName == defaultContributions.contributions[i].memberId.lastName}
//
//                    print("first name def: \(defaultContributions.contributions[i].memberId.firstName)")
//
//                    let item = filteredArray.first!
//                    item.contributions.append(defaultContributions.contributions[i])
//                    if (defaultContributions.contributions[i].memberId.memberIconPath) == nil {
//                        item.memberIconPath.append("")
//                    }else{
//                        item.memberIconPath = defaultContributions.contributions[i].memberId.memberIconPath!
//
//                    }
//                    var totalAmount: Double = 0.0
//                    for i in 0 ..< item.contributions.count {
//                        totalAmount = totalAmount + item.contributions[i].amount
//
//                    }
//                    item.totalAmount = totalAmount
//
//                    print("item: \(item)")
//                    print(label)
//
//                }else {
//                    var section = ContributionSection()
//
//                    section.firstName = defaultContributions.contributions[i].memberId.firstName
//                    section.lastName = defaultContributions.contributions[i].memberId.lastName
//                    section.contributions.append(defaultContributions.contributions[i])
//                    section.totalAmount = defaultContributions.contributions[i].amount
//                    if (defaultContributions.contributions[i].memberId.memberIconPath) == nil {
//                        section.memberIconPath = ""
//                    }else {
//                        section.memberIconPath = defaultContributions.contributions[i].memberId.memberIconPath!
//
//                    }
//
//                    contributions.append(section)
//                }
//                label = defaultContributions.contributions[i].currency
//                contributionLabel.text = "Total Contributions(\(privateGroup.countryId.currency))"
//            }
//
//            if defaultContributions.total == nil || defaultContributions.total == "0" {
//                totalContribution.text = "0.00"
//                self.emptyView.isHidden = false
//                self.emptyInfo.text = "No contribution."
//            }else {
//                print("am: \(defaultContributions.total)")
//                totalContribution.text = "\(defaultContributions.total!)"
//            }
//
//            defaultTableView.reloadData()
//
//
//            break
//        case .failure( _):
//            FTIndicator.dismissProgress()
//            if result.response?.statusCode == 400 {
//                sessionTimeout()
//            }else {
//                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
//            }
//        }
//    }
    
    
    func contributionComputation(defaultContribution: ContributionsPage) {
        for i in 0 ..< self.defaultContribution.content.count {
            let contributors = self.contribution.map { return $0.firstName }
            let contributorsLast = self.contribution.map { return $0.lastName }
            let memId = self.contribution.map { return $0.memberId }
            
            if (contributors.contains(self.defaultContribution.content[i].memberId.firstName) && contributorsLast.contains(self.defaultContribution.content[i].memberId.lastName) && memId.contains(self.defaultContribution.content[i].memberId.memberId!)) {
                let filteredArray = self.contribution.filter { $0.firstName == self.defaultContribution.content[i].memberId.firstName && $0.lastName == self.defaultContribution.content[i].memberId.lastName && $0.memberId == self.defaultContribution.content[i].memberId.memberId}
                
                print("first name: \(self.defaultContribution.content[i].memberId.firstName)")
                print("filtered array: \(filteredArray)")
                
                if (filteredArray.count != 0) {
                    let item = filteredArray.first!
                    item.contributions.append(self.defaultContribution.content[i])
                    print("amounts: \(self.defaultContribution.content[i].amount)")
                    if (self.defaultContribution.content[i].memberId.memberIconPath) == nil {
                        item.memberIconPath.append("")
                    }else{
                        item.memberIconPath = (self.defaultContribution.content[i].memberId.memberIconPath!)
                    }
                    var totalAmount: Double = 0.0
                    for i in 0 ..< item.contributions.count {
                        
                        totalAmount = totalAmount + item.contributions[i].amount
                        
                    }
                    item.totalAmount = totalAmount
                    
                    print("itemsss: \(item)")
                }
            }else {
                let section = ContributionSections()
                
                section.firstName = self.defaultContribution.content[i].memberId.firstName
                print("first name only: \(self.defaultContribution.content[i].memberId.firstName)")
                section.lastName = self.defaultContribution.content[i].memberId.lastName
                section.memberId = self.defaultContribution.content[i].memberId.memberId!
                section.contributions.append(self.defaultContribution.content[i])
                section.totalAmount = self.defaultContribution.content[i].amount
                if (self.defaultContribution.content[i].memberId.memberIconPath) == nil {
                    section.memberIconPath = ""
                }else {
                    section.memberIconPath = (self.defaultContribution.content[i].memberId.memberIconPath!)
                }
                self.contribution.append(section)
            }
        }
    
    var summy: Double = 0.0
    for i in 0 ..< self.contribution.count {
        summy = summy + self.contribution[i].totalAmount
        print("sum: \(summy)")
    }
    let twoDeciSum = String(format: "%.2f", summy)
        self.totalContribution.text = "\(twoDeciSum)"
        
        self.defaultTableView.reloadData()
    }
    
    
    
    func campaignContributionComputation(campaignContribution: [GetCampaignContributionResponse]) {
        for i in 0 ..< self.campaignContribution.count {
            let contributors = self.contribution.map { return $0.firstName }
            let contributorsLast = self.contribution.map { return $0.lastName }
            let memId = self.contribution.map { return $0.memberId }
            
            if (contributors.contains(self.campaignContribution[i].memberId.firstName) && contributorsLast.contains(self.campaignContribution[i].memberId.lastName) && memId.contains(self.campaignContribution[i].memberId.memberId!)) {
                let filteredArray = self.contribution.filter { $0.firstName == self.campaignContribution[i].memberId.firstName && $0.lastName == self.campaignContribution[i].memberId.lastName && $0.memberId == self.campaignContribution[i].memberId.memberId}
                
                print("first name: \(self.campaignContribution[i].memberId.firstName)")
                print("filtered array: \(filteredArray)")
                
                if (filteredArray.count != 0) {
                    let item = filteredArray.first!
                    item.contribution.append(self.campaignContribution[i])
                    print("amounts: \(self.campaignContribution[i].amount)")
                    if (self.campaignContribution[i].memberId.memberIconPath) == nil {
                        item.memberIconPath.append("")
                    }else{
                        item.memberIconPath = (self.campaignContribution[i].memberId.memberIconPath!)
                    }
                    var totalAmount: Double = 0.0
                    for i in 0 ..< item.contribution.count {
                        
                        totalAmount = totalAmount + item.contribution[i].amount
                        
                    }
                    item.totalAmount = totalAmount
                    
                    print("itemsss: \(item)")
                }
            }else {
                let section = ContributionSections()
                
                section.firstName = self.campaignContribution[i].memberId.firstName
                print("first name only: \(self.campaignContribution[i].memberId.firstName)")
                section.lastName = self.campaignContribution[i].memberId.lastName
                section.memberId = self.campaignContribution[i].memberId.memberId!
                section.contribution.append(self.campaignContribution[i])
                section.totalAmount = self.campaignContribution[i].amount
                if (self.campaignContribution[i].memberId.memberIconPath) == nil {
                    section.memberIconPath = ""
                }else {
                    section.memberIconPath = (self.campaignContribution[i].memberId.memberIconPath!)
                }
                self.contribution.append(section)
            }
        }
    
    var summy: Double = 0.0
    for i in 0 ..< self.contribution.count {
        summy = summy + self.contribution[i].totalAmount
        print("sum: \(summy)")
    }
//    let twoDeciSum = String(format: "%.2f", summy)
        
        let largeNumber = summy
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
        self.totalContribution.text = "\(formattedNumber!)"
        
        self.defaultTableView.reloadData()
        FTIndicator.dismissProgress()
        print("function dismiss")

    }
    
    
    //new
    func groupContributions(groupContributionsParameter: GroupContributionsParameter){
        AuthNetworkManager.contributionsPage(parameter: groupContributionsParameter) { (result) in
            self.parseGroupContributionsResponse(result: result)
        }
    }
    
    
    private func parseGroupContributionsResponse(result: DataResponse<ContributionsPage, AFError>){
//        self.defaultTableView.es.addInfiniteScrolling {
//            [unowned self] in
//            let parr: GroupContributionsParameter = GroupContributionsParameter(groupId: self.group, offset: "0", pageSize: "\(self.page)")
//        self.groupContributions(groupContributionsParameter: parr)
            FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            FTIndicator.dismissProgress()
            
            self.defaultContribution = response
            print("deffff: \(self.defaultContribution)")
            
            self.contributionComputation(defaultContribution: self.defaultContribution)

            
            
//            self.page = self.page + 1
//
//            if response.last == true {
//                self.defaultTableView.es.stopLoadingMore()
//            }
            break
        case .failure(_ ):
            FTIndicator.dismissProgress()
            if result.response?.statusCode == 400 {
                self.sessionTimeout()
            }else {
                self.showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
                }
            }
//        }
    }
    
    //updated-list
    func getCampaignContribution(campaignContributionParameter: CampaignContributionParameter){
        AuthNetworkManager.campaignContribution(parameter: campaignContributionParameter) { (result) in
            self.parseCampaignContributionResponse(result: result)
        }
    }
    
    private func parseCampaignContributionResponse(result: DataResponse<[GetCampaignContributionResponse], AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            
            if (didSelectCheck == 1) {
                let vc: CampaignContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "camp") as! CampaignContributionsViewController
                vc.campaignContribution = response
                vc.privateGroup = self.privateGroup
                vc.groupNamed = self.groupNamed
                vc.campaignId = self.campaignId
                vc.campaignStatus = self.status
                //            vc.campaignName = campaignInfo
                vc.campaignContributions = self.contribution
                vc.label = self.label
                print(self.status)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.campaignContribution = response
            print("deffff: \(self.campaignContribution)")
            
            self.campaignContributionComputation(campaignContribution: self.campaignContribution)
            FTIndicator.dismissProgress()
            print("response dismiss")
            break
        case .failure(_ ):
            FTIndicator.dismissProgress()
            if result.response?.statusCode == 400 {
                self.sessionTimeout()
            }else {
                self.showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
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
            if (searched) && (tableView == defaultTableView) {
                return self.filtered_contributors.count
                }else {
                    return contribution[section].contribution.count
                }
            }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == defaultTableView) {
            return contribution.count
        }else {
            return filtered_contributors.count
        }
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
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if (searched){
                filtered_contributors[indexPath.section].contribution = filtered_contributors[indexPath.section].contribution.sorted(by: {$0.created > $1.created})
                let date = formatter.date(from: self.filtered_contributors[indexPath.section].contribution[indexPath.row].created)
//                let dates = timeAgoSinceDate(date!)
                let dates = dayDifference(from: date!)
                formatter.dateStyle = DateFormatter.Style.medium
                let cell: DetailedContributionCell = self.defaultTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DetailedContributionCell
                
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.white
                cell.amount.text = "\(filtered_contributors[indexPath.section].contribution[indexPath.row].amount)"
                cell.date.text = dates
                
                return cell
            }
            contribution[indexPath.section].contribution = contribution[indexPath.section].contribution.sorted(by: {$0.created > $1.created})
            let date = formatter.date(from: self.contribution[indexPath.section].contribution[indexPath.row].created)
            let dates = dayDifference(from: date!)
            
            //dropdown
            let cell: DetailedContributionCell = self.defaultTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DetailedContributionCell
            cell.selectionStyle = .none
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            
            cell.amount.text = "\(contribution[indexPath.section].contribution[indexPath.row].amount)"
            print("expand amount: \(contribution[indexPath.section].contribution[indexPath.row].amount)")
            
            contribution[indexPath.section].contribution = contribution[indexPath.section].contribution.sorted(by: {$0.created > $1.created})
            cell.date.text = dates
            return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (searched){
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
            
            let url = URL(string: filtered_contributors[section].memberIconPath)
            
            print("first name: \(filtered_contributors[section].firstName) \(filtered_contributors[section].lastName)")
            sectionHeader.sectionTitleLabel.text = "\(filtered_contributors[section].firstName) \(filtered_contributors[section].lastName)"
            
            if(filtered_contributors[section].memberIconPath == "nil"){
                if(filtered_contributors[section].memberIconPath == ""){
                    print("ha")
                    print(filtered_contributors[section].memberIconPath+" : No Image")
                    sectionHeader.img.image = UIImage(named: "individual")
                }
            }else {
                if contribution[section].firstName == "ANONYMOUS" {
                    sectionHeader.img.image = UIImage(named: "anonymous")
                    
                }else if url == nil {
                    sectionHeader.img.image = UIImage(named: "individual")
                }else{
                    Nuke.loadImage(with: url!, into: sectionHeader.img)
                    print("url: \(url!)")
                }
            }
            
            sectionHeader.amount.text = String(format: "%0.2f", filtered_contributors[section].totalAmount)
            
            
            
        }
        
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
        let url = URL(string: contribution[section].memberIconPath)
        let user: String! = UserDefaults.standard.string(forKey: "users")
        sectionHeader.sectionTitleLabel.text = "\(contribution[section].firstName) \(contribution[section].lastName)"
        if(contribution[section].memberIconPath == "nil"){
            if(contribution[section].memberIconPath == ""){
                print("ha")
                print(contribution[section].memberIconPath+" : No Image")
                sectionHeader.img.image = UIImage(named: "individual")
            }
        }else {
            if contribution[section].firstName == "ANONYMOUS" {
                sectionHeader.img.image = UIImage(named: "anonymous")
                
            }else if url == nil {
                sectionHeader.img.image = UIImage(named: "individual")
            }else{
                Nuke.loadImage(with: url!, into: sectionHeader.img)
                print("url: \(url!)")
            }
        }
        sectionHeader.amount.text = String(format: "%0.2f", contribution[section].totalAmount)
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

//        dateExtract = [campaignInfo[0].modified!]
//        
//        let date = formatter.date(from: self.dateExtract[section])
//        formatter.dateStyle = DateFormatter.Style.medium
//        _ = formatter.string(from: date as! Date)
//
//
//
//        let dates = timeAgoSinceDate(date!)
//        sectionHeader.destinationNumber.text = dates
        
        return sectionHeader
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("tapped")
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
 }


// MARK: - <FZAccordionTableViewDelegate> -

extension ViewController : FZAccordionTableViewDelegate {
    
    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("open section")
    }
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("close section")
    }
    
    func tableView(_ tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
}

