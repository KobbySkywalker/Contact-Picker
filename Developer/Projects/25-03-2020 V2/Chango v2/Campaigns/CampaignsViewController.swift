//
//  CampaignsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire

class CampaignsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var activeTableView: UITableView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var createCampaignButton: UIButton!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filtered_groups: [GetGroupCampaignsResponse] = []
    
    var campaign: GetGroupCampaignsResponse!
    var group = ""
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var archivedCampaigns: [GetGroupCampaignsResponse] = []
    let cell = "cellId"
    var adminResponse: String = ""
    var endDate = Date()
    var dateExtended: Bool = false
    var mainViewController: MainMenuTableViewController!
    var groupCreated: Bool = false
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]
    var currency: String = ""
    var expiredCampaign: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        print("view did load")
        self.activeTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.activeTableView.register(UINib(nibName: "GroupCampaignsCell", bundle: nil), forCellReuseIdentifier: "GroupCampaignsCell")
        self.activeTableView.tableFooterView = UIView()
        
        self.historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.historyTableView.register(UINib(nibName: "GroupCampaignsCell", bundle: nil), forCellReuseIdentifier: "GroupCampaignsCell")
        self.historyTableView.tableFooterView = UIView()
        
        if (self.adminResponse == "false") {
            self.createCampaignButton.isHidden = true
        }else if (self.adminResponse == "true") {
            self.createCampaignButton.isHidden = false
        }else {
            self.createCampaignButton.isHidden = true
        }
        
        //Check if user is admin
        
        let parameterr: GetActivePausedCampaignsParameter = GetActivePausedCampaignsParameter(groupId: group)
        getActivePausedCampaigns(groupCampaignsParameter: parameterr)
        

        //SearchBar
        //        searchController.searchBar.placeholder = "Search Group"
        //        searchController.searchResultsUpdater = self
        //        searchController.dimsBackgroundDuringPresentation = false
        //        searchController.hidesNavigationBarDuringPresentation = false
        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        //        if #available(iOS 11.0, *) {
        //            navigationItem.searchController = searchController
        //        }
        searchBarItem.delegate = self
    }
    
    @IBAction func activeCampaignsButtonAction(_ sender: Any) {
        activeButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        historyButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        activeTableView.isHidden = false
        historyTableView.isHidden = true
        print("camp count: \(campaignInfo.count)")
        if (self.campaignInfo.count > 0){
            self.emptyView.isHidden = true
            print("hidden")
        }else{
            self.emptyView.isHidden = false
            print("show")
            
        }
    }
    
    @IBAction func HistoryButtonAction(_ sender: Any) {
        historyButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        activeButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        let parameterrr: GetArchivedCampaignsParameter = GetArchivedCampaignsParameter(groupId: group)
        getArchivedCampaigns(archivedCampaignsParameter: parameterrr)
        activeTableView.isHidden = true
        historyTableView.isHidden = false
        if (self.archivedCampaigns.count > 0){
            self.emptyView.isHidden = true
            print("hidden")
        }else{
            self.emptyView.isHidden = false
            print("show")
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        FTIndicator.showProgress(withMessage: "loading campaigns", userInteractionEnable: false)
        //        print("view did load")
        
        print(groupCreated)
        if (groupCreated) {
            print("group was just created")
            let parameter: IsAdminParameter = IsAdminParameter(groupId: group)
            isAdmin(isAdminParameter: parameter)
            
            let parameterr: GetActivePausedCampaignsParameter = GetActivePausedCampaignsParameter(groupId: group)
            getActivePausedCampaigns(groupCampaignsParameter: parameterr)
            
//            let parameterrr: GetArchivedCampaignsParameter = GetArchivedCampaignsParameter(groupId: group)
//            getArchivedCampaigns(archivedCampaignsParameter: parameterrr)
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupGroups(){
        self.activeTableView.reloadData()
    }
    
    func searchMethod(searchText: String){
        filtered_groups.removeAll()
        searchIndexes.removeAll()
        if(searchText.isEmpty){
            searched = false
            self.setupGroups()
            return
        }else if(!(searchText.isEmpty)){
            filtered_groups = campaignInfo.filter({ (campaign : GetGroupCampaignsResponse) -> Bool in
                
                return (campaign.campaignName.lowercased().contains(searchText.lowercased()))
                
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
        let array = campaignInfo.filter ({
            $0.campaignName.localizedCaseInsensitiveContains(searchText)
        })
        filtered_groups = array
        
        self.activeTableView.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
        searchMethod(searchText: searchController.searchBar.text!)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
        searchMethod(searchText: searchText)
    }
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchMethod(searchText: searchBar.text!)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    @IBAction func addCampaignButtonAction(_ sender: UIButton) {
        
        if adminResponse == "false"{
            showAlert(title: "Campaigns", message: "Only admins of this group can create campaigns.")
        }else {
        let vc: NewCampaignViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newcamp") as! NewCampaignViewController
        vc.campaignInfo = campaignInfo
        vc.campaign = campaign
        vc.group = group
        vc.mainViewController = mainViewController
        vc.currency = currency
        print("currency: \(currency)")
        print(group)
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //IS ADMIN
    func isAdmin(isAdminParameter: IsAdminParameter) {
        AuthNetworkManager.isAdmin(parameter: isAdminParameter) { (result) in
            print("result: \(result)")
            FTIndicator.dismissProgress()
            self.adminResponse = result
            
            if (self.adminResponse == "false") {
                self.createCampaignButton.isHidden = true
            }else if (self.adminResponse == "true") {
                self.createCampaignButton.isHidden = false
            }else {
                self.createCampaignButton.isHidden = true
            }
            
        }
    }
    
    private func parseIsAdmin(result: DataResponse<String, AFError>){
        
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            
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
    
    
    //GROUP CAMPAIGN
    func getActivePausedCampaigns(groupCampaignsParameter: GetActivePausedCampaignsParameter) {
        AuthNetworkManager.getActivePausedCampaigns(parameter: groupCampaignsParameter) { (result) in
            self.parseGetActivePausedCampaignResponse(result: result)
        }
    }
    
    private func parseGetActivePausedCampaignResponse(result: DataResponse<[GetGroupCampaignsResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            campaignInfo.removeAll()
            print("response: \(response)")
            
            for item in response {
                self.campaignInfo.append(item)
            }
            
            if (self.campaignInfo.count > 0){
                self.emptyView.isHidden = true
                print("hidden")
            }else{
                self.emptyView.isHidden = false
                print("show")
                
            }
            
            activeTableView.reloadData()
            
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
    
    
    //ARCHIVED CAMPAIGNS
    func getArchivedCampaigns(archivedCampaignsParameter: GetArchivedCampaignsParameter) {
        AuthNetworkManager.getArchivedCampaigns(parameter: archivedCampaignsParameter) { (result) in
            self.parseGetArchivedCampaignResponse(result: result)
        }
    }
    
    private func parseGetArchivedCampaignResponse(result: DataResponse<[GetGroupCampaignsResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            archivedCampaigns.removeAll()
            print("response: \(response)")
            
            for item in response {
                self.archivedCampaigns.append(item)
            }
            if (self.archivedCampaigns.count > 0){
                self.emptyView.isHidden = true
                print("hidden")
            }else{
                self.emptyView.isHidden = false
                print("show")
                
            }
            
            historyTableView.reloadData()
            
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
    
    
    
    func dateConversion(dateValue: String) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        _ = formatter.string(from: Date())
        
        let date = formatter.date(from: dateValue)
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        let newDate = formatter.string(from: date!)
        print(newDate)
        
        return newDate
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searched) {
            return self.filtered_groups.count
        }else if tableView == activeTableView {
        return campaignInfo.count
        }else if tableView == historyTableView {
            return archivedCampaigns.count
        }else {
            return campaignInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (searched) {
            
            let cell: GroupCampaignsCell = self.activeTableView.dequeueReusableCell(withIdentifier: "GroupCampaignsCell", for: indexPath) as! GroupCampaignsCell
            cell.selectionStyle = .none
            
            self.campaignInfo = self.campaignInfo.sorted(by: {$0.modified > $1.modified})
            
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let date = formatter.date(from: self.filtered_groups[indexPath.row].modified!)
            
            
            formatter.dateStyle = DateFormatter.Style.medium
            _ = formatter.string(from: date as! Date)
                        
            let dates = timeAgoSinceDate(date!)
            
            let myCampaigns: GetGroupCampaignsResponse = self.filtered_groups[indexPath.row]
            cell.campaignName.text = myCampaigns.campaignName
            cell.campaignImage.image = UIImage(named: "defaultgroupicon")
            cell.campaignDate.text = "Created on \(dateConversion(dateValue: myCampaigns.created))"
            cell.campaignDescription.text = myCampaigns.description
//            cell.campaignStatus.isHidden = false
            
            var endDate = Date()
            if myCampaigns.end != nil {
                
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                endDate = formatter.date(from: self.filtered_groups[indexPath.row].end!)!
                
                
                formatter.dateStyle = DateFormatter.Style.medium
                _ = formatter.string(from: endDate as! Date)
                
                
            }
            cell.rectangleView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            
//            if myCampaigns.status == "stop" {
//                cell.campaignStatus.text = "inactive"
//                cell.campaignStatus.backgroundColor = UIColor.red
//            }else if (Date() > endDate) && (myCampaigns.status == "running") {
//                cell.campaignStatus.text = "ended"
//                cell.campaignStatus.backgroundColor = UIColor.red
//            }else if (Date() < endDate) && (myCampaigns.status == "running") {
//                cell.campaignStatus.text = "active"
//                cell.campaignStatus.backgroundColor = UIColor(red: 0/255, green: 82/255, blue: 0/255, alpha: 1)
//            }
//
            return cell
            
        }else {
            
            if tableView == activeTableView {
            let cell: GroupCampaignsCell = self.activeTableView.dequeueReusableCell(withIdentifier: "GroupCampaignsCell", for: indexPath) as! GroupCampaignsCell
            cell.selectionStyle = .none
            
            self.campaignInfo = self.campaignInfo.sorted(by: {$0.modified > $1.modified})
            let myCampaigns: GetGroupCampaignsResponse = self.campaignInfo[indexPath.row]

            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let date = formatter.date(from: self.campaignInfo[indexPath.row].modified!)
            var dayLeft = Date()
            
            var endDate = Date()
            if myCampaigns.end != nil {
                
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                endDate = formatter.date(from: self.campaignInfo[indexPath.row].end!)!
                
                
                formatter.dateStyle = DateFormatter.Style.medium
                _ = formatter.string(from: endDate as! Date)
            }
            if campaignInfo[indexPath.row].campaignType == "temporary" {
                if (Date() > endDate) && (campaignInfo[indexPath.row].status == "running") && (campaignInfo[indexPath.row].campaignType == "temporary"){
                    cell.daysLeft.text = "No days left"
                    
                }else if campaignInfo[indexPath.row].end == nil {
                    
                }else {
                dayLeft = formatter.date(from: self.campaignInfo[indexPath.row].end!)!
                _ = formatter.string(from: dayLeft as! Date)
                formatter.dateStyle = DateFormatter.Style.medium
                _ = formatter.string(from: date as! Date)
                    
                let daysLeftNow = daysLeft(dayLeft)
                print("days left: \(daysLeft)")
                cell.daysLeft.text = "\(daysLeftNow) left"
                }
            }else {
            }

            
            cell.campaignName.text = myCampaigns.campaignName
            cell.campaignImage.image = UIImage(named: "defaultgroupicon")
            cell.campaignDate.text = "Created on \(dateConversion(dateValue: myCampaigns.created))"
            cell.campaignDescription.text = myCampaigns.description
                cell.amountRaised.text = "\(currency)\(formatNumber(figure: myCampaigns.amountReceived!))"
            cell.totalAmount.text = "\((currency))\(formatNumber(figure: myCampaigns.target!))"
            cell.progressBar.progress = Float(myCampaigns.amountReceived!/myCampaigns.target!)

            
            cell.rectangleView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])

            print("\(myCampaigns.campaignName), \(myCampaigns.status), \(date)")
                
                print("amoount R: \(myCampaigns.amountReceived!)")

            
            return cell
            }else {
                let cell: GroupCampaignsCell = self.historyTableView.dequeueReusableCell(withIdentifier: "GroupCampaignsCell", for: indexPath) as! GroupCampaignsCell
                cell.selectionStyle = .none
                
                self.archivedCampaigns = self.archivedCampaigns.sorted(by: {$0.modified > $1.modified})
                let myCampaigns: GetGroupCampaignsResponse = self.archivedCampaigns[indexPath.row]    

                if (myCampaigns.end == nil) {
                    cell.daysLeft.text = "null"
                } else if (myCampaigns.end == "nil") {
                    cell.daysLeft.text = "null"
                }else if (myCampaigns.end == "null") {
                    cell.daysLeft.text = "null"
                }else {
                    cell.daysLeft.text = "Ended on \(dateConversion(dateValue: myCampaigns.end!))"
                }
                cell.campaignName.text = myCampaigns.campaignName
                cell.campaignImage.image = UIImage(named: "defaultgroupicon")
                cell.campaignDate.text = "Created on \(dateConversion(dateValue: myCampaigns.created))"
                cell.campaignDescription.text = myCampaigns.description
                cell.amountRaised.text = "\(currency)\(formatNumber(figure: myCampaigns.amountReceived!))"
                cell.totalAmount.text = "\((currency))\(formatNumber(figure: myCampaigns.target!))"
                cell.progressBar.progress = Float(myCampaigns.amountReceived!/myCampaigns.target!)

                
                cell.rectangleView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])

                print("\(myCampaigns.campaignName), \(myCampaigns.status)")
                print("hist amoount R: \(myCampaigns.amountReceived!)")

                
                return cell
                }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (searched) {
            
            let vc: CampaignOptionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "options") as! CampaignOptionsViewController
            
            let myCampaigns: GetGroupCampaignsResponse = self.filtered_groups[indexPath.row]
            
            vc.campaignName = myCampaigns.campaignName
            vc.campaignId = myCampaigns.campaignId ?? ""
            vc.campaignStatus = myCampaigns.status!
            vc.campaignType = myCampaigns.campaignType
            vc.isAdmin = adminResponse
            vc.groupId = group
            
            var endDate = Date()
            if myCampaigns.end != nil {
                
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                endDate = formatter.date(from: self.campaignInfo[indexPath.row].end!)!
                
                
                formatter.dateStyle = DateFormatter.Style.medium
                _ = formatter.string(from: endDate as! Date)
                
                
                
                let dates = timeFromDate(endDate)
                print("end: \(myCampaigns.end!)")
                print("ending: \(dates)")
                vc.campaignEnd = dates
            }
            if myCampaigns.description == nil {
                vc.campaignDesc = "null"
            }else {
                vc.campaignDesc = myCampaigns.description!
            }
            if myCampaigns.status == "stop" {
                showAlert(title: "Campaign Alert", message: "This campaign has been stopped.")
            }else if (Date() > endDate) && (myCampaigns.status == "running") && (myCampaigns.campaignType != "perpetual") {
                showAlert(title: "Campaign Alert", message: "This campaign has ended.")
            }else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            


            if tableView == activeTableView {
                let myCampaigns: GetGroupCampaignsResponse = self.campaignInfo[indexPath.row]

                    var endDate = Date()
                    if myCampaigns.end != nil {
                        
                        let formatter = DateFormatter()
                        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        endDate = formatter.date(from: self.campaignInfo[indexPath.row].end!)!
                        
                        
                        formatter.dateStyle = DateFormatter.Style.medium
                        _ = formatter.string(from: endDate as! Date)

                    }
                expiredCampaign = false
            if adminResponse == "true" {
                FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)

                let par: CampaignContributionParameter = CampaignContributionParameter(campaignId: myCampaigns.campaignId ?? "")
                self.getCampaignContribution(campaignContributionParameter: par, campaignData: myCampaigns)
                print("id: \(myCampaigns.campaignId)")
            }else {
                if myCampaigns.status == "stop" {
                    showAlert(withTitle: "Campaign Alert", message: "This campaign has been stopped.")
                }else if (Date() > endDate) && (myCampaigns.status == "running") && (myCampaigns.campaignType != "perpetual") {
                    print(myCampaigns.end)
                    print(Date())
                    print("end: \(endDate)")
                    print(myCampaigns.status)
                    showAlert(title: "Campaign Alert", message: "This campaign has ended.")
                }else {
                    FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)

                    let par: CampaignContributionParameter = CampaignContributionParameter(campaignId: myCampaigns.campaignId ?? "")
            self.getCampaignContribution(campaignContributionParameter: par, campaignData: myCampaigns)
            print("id: \(myCampaigns.campaignId)")
                    }
                }
            }else {
                let myExpiredCampaigns: GetGroupCampaignsResponse = self.archivedCampaigns[indexPath.row]

                    var endDate = Date()
                    if myExpiredCampaigns.end != nil {
                        
                        let formatter = DateFormatter()
                        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        endDate = formatter.date(from: self.archivedCampaigns[indexPath.row].end!)!
                        
                        
                        formatter.dateStyle = DateFormatter.Style.medium
                        _ = formatter.string(from: endDate as! Date)

                    }
                    expiredCampaign = true
                if adminResponse == "true" {
                    FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)

                    let par: CampaignContributionParameter = CampaignContributionParameter(campaignId: myExpiredCampaigns.campaignId ?? "")
                    self.getCampaignContribution(campaignContributionParameter: par, campaignData: myExpiredCampaigns)
                    print("id: \(myExpiredCampaigns.campaignId)")
                }else {
                    if myExpiredCampaigns.status == "stop" {
                        showAlert(withTitle: "Campaign Alert", message: "This campaign has been stopped.")
                    }else if (Date() > endDate) && (myExpiredCampaigns.status == "running") && (myExpiredCampaigns.campaignType != "perpetual") {
                        print(myExpiredCampaigns.end)
                        print(Date())
                        print("end: \(endDate)")
                        print(myExpiredCampaigns.status)
                        showAlert(title: "Campaign Alert", message: "This campaign has ended.")
                    }else {
                        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)

                        let par: CampaignContributionParameter = CampaignContributionParameter(campaignId: myExpiredCampaigns.campaignId ?? "")
                self.getCampaignContribution(campaignContributionParameter: par, campaignData: myExpiredCampaigns)
                print("id: \(myExpiredCampaigns.campaignId)")
                        }
                    }
            }
    
        }

    }
    
        //updated-list
        func getCampaignContribution(campaignContributionParameter: CampaignContributionParameter, campaignData: GetGroupCampaignsResponse){
            AuthNetworkManager.campaignContribution(parameter: campaignContributionParameter) { (result) in
                self.parseCampaignContributionResponse(result: result, campaignData: campaignData)
            }
        }
        
    private func parseCampaignContributionResponse(result: DataResponse<[GetCampaignContributionResponse], AFError>, campaignData: GetGroupCampaignsResponse){
        switch result.result {
        case .success(let response):
            print(response)
            FTIndicator.dismissProgress()

            if adminResponse == "true" {
                let vc: AdminCampaignDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "adminCampaign") as! AdminCampaignDetailVC
                
                vc.campaignInfo = campaignData
                vc.campaignContribution = response
                vc.campaignName = campaignData.campaignName
                vc.currency = currency
                vc.groupId = group
                if expiredCampaign == true {
                    vc.expiredCampaign = true
                }else {
                    vc.expiredCampaign = false
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                

                let vc: CampaignOptionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "options") as! CampaignOptionsViewController
                
                vc.campaignInfo = campaignData
                vc.campaignContribution = response
                vc.campaignName = campaignData.campaignName
                vc.currency = currency
                vc.groupId = group
                if expiredCampaign == true {
                    vc.expiredCampaign = true
                }else {
                    vc.expiredCampaign = false
                }
                print("segue: \(campaignData.target),\(response),\(campaignData.campaignName)")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
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
    
}


func formatNumber(figure: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = 2
    let formattedNumber = numberFormatter.string(from: NSNumber(value:figure))
    return formattedNumber!
}

func timeFromDate(_ date:Date, numericDates:Bool = true) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
    
    if (components.year! >= 2) {
        return "\(components.year!) years from now"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year from now"
        } else {
            return "next year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months from now"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month from now"
        } else {
            return "next month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks from now"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week from now"
        } else {
            return "next week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days from now"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day from now"
        } else {
            return "tomorrow at \(date.getTimeStringFromUTC())"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours from now"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour from now"
        } else {
            return "an hour from now"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes from now"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute from now"
        } else {
            return "a minute from now"
        }
    } else if (components.second! >= 3) {
        return "just now"//"\(components.second!) seconds ago"
    } else {
        return "just now"
    }
}
