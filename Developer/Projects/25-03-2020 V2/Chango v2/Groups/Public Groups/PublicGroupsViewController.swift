//
//  PublicGroupsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 05/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import FTIndicator
import ESPullToRefresh

class PublicGroupsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var allGroupsTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyViewText: UILabel!
    @IBOutlet weak var menuIcon: UIButton!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchNotFoundView: UIView!
    
    var publicGroups: [GroupResponse] = []
    var myPublicGroups: [GroupResponse] = []
    let cell = "cellId"
    
    var searchGroups: [GroupResponse] = []
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filtered_groups: [GroupResponse] = []
    var myFiltered_groups: [GroupResponse] = []
    var data = [""]
    let textField = UITextField()
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]
    var newUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        view.addSubview(textField)
        
        getPublicGroups()
        FTIndicator.showProgress(withMessage: "Getting public groups")
        
        //SearchBar
        searchController.searchBar.placeholder = "Search Group"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        searchController.delegate = self
        searchBarItem.delegate = self
        self.searchBarItem.backgroundColor = UIColor.clear
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        
        self.allGroupsTableView.register(UINib(nibName: "PublicGroupsViewController", bundle: nil), forCellReuseIdentifier: "PublicGroupsViewController")
        self.allGroupsTableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.allGroupsTableView.tableFooterView = UIView()
        self.allGroupsTableView.reloadData()
        self.allGroupsTableView.es.addPullToRefresh {
            [unowned self] in
            //Do anything you want...
            self.getPublicGroups()
            self.allGroupsTableView.es.stopPullToRefresh()
            self.allGroupsTableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        self.allGroupsTableView.es.addPullToRefresh {
            [unowned self] in
            //Do anything you want...
            self.getPublicGroups()
            self.allGroupsTableView.es.stopPullToRefresh()
            self.allGroupsTableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if newUser == true {
            menuIcon.setImage(UIImage(named: "icons-dark-back"), for: .normal)
        }
    }
    
    @IBAction func leftMenuButtonAction(_ sender: Any) {
        if newUser == true {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
        }
    }
    
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
    func setupGroups() {
        self.allGroupsTableView.reloadData()
    }
    
    func searchMethod(searchText: String, tableView: UITableView){
        filtered_groups.removeAll()
        searchIndexes.removeAll()
        if(searchText.isEmpty){
            searched = false
            self.setupGroups()
            return
        }else if(!(searchText.isEmpty)){
            filtered_groups = publicGroups.filter({ (group : GroupResponse) -> Bool in
                return (group.groupName.lowercased().contains(searchText.lowercased()))
            })
            searched = true
            if filtered_groups.isEmpty {
                searchNotFoundView.isHidden = false
            }else {
                searchNotFoundView.isHidden = true
            }
            self.setupGroups()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filtered_groups.removeAll(keepingCapacity: false)
        let array = publicGroups.filter ({
            $0.groupName.localizedCaseInsensitiveContains(searchText)
        })
        filtered_groups = array
        self.allGroupsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMethod(searchText: searchBar.text!, tableView: allGroupsTableView)
        print("text: \(searchBar.text!)")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
        searchMethod(searchText: searchController.searchBar.text!, tableView: allGroupsTableView)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
        searchMethod(searchText: searchText, tableView: allGroupsTableView)
    }
    
    //DATE FORMATTER
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
        if (searched) && (tableView == allGroupsTableView) {
            return self.filtered_groups.count
        }
        return publicGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (searched) && (tableView == allGroupsTableView) {
            //if all groups
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            var dates = ""
            if let date = formatter.date(from: self.filtered_groups[indexPath.row].created) {
            formatter.dateStyle = DateFormatter.Style.medium
            _ = formatter.string(from: date as! Date)
            dates = timeAgoSinceDate(date)
            }
            let cell: GroupsTableViewCell = self.allGroupsTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            //configure the search cell
            let pubGroup: GroupResponse = self.filtered_groups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "people")
            cell.groupType.text = "Public"
            let url = URL(string: pubGroup.groupIconPath!)
            if(pubGroup.groupIconPath == "<null>") || (pubGroup.groupIconPath == nil) || (pubGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "people")
                cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
                cell.groupsDate.text = dates
                cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            }else {
                Nuke.loadImage(with: url!, into: cell.groupsImage)
                cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
                cell.groupsDate.text = dates
                cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            }
            return cell
        }else {
            let cell: GroupsTableViewCell = self.allGroupsTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            var dates = ""
            if let date = formatter.date(from: self.publicGroups[indexPath.row].created) {
            formatter.dateStyle = DateFormatter.Style.medium
            _ = formatter.string(from: date as! Date)
            dates = timeAgoSinceDate(date)
            }
            let pubGroup: GroupResponse = self.publicGroups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "defaultgroupicon")
            cell.groupType.text = "Public"
            let url = URL(string: pubGroup.groupIconPath!)
            if(pubGroup.groupIconPath == "<null>") || (pubGroup.groupIconPath == nil) || (pubGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                cell.groupsName.text = self.publicGroups[indexPath.row].groupName
                cell.groupsDate.text = dates
                print(self.publicGroups[indexPath.row].groupName)
                cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            }else {
                cell.groupsImage.contentMode = .scaleAspectFill
                Nuke.loadImage(with: url!, into: cell.groupsImage)
                cell.groupsName.text = self.publicGroups[indexPath.row].groupName
                cell.groupsDate.text = dates
                cell.memberCampaignCount.text = "\(self.publicGroups[indexPath.row].campaignCount!)"
                cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: PublicGroupDashboardVC = storyboard.instantiateViewController(withIdentifier: "publicdash") as! PublicGroupDashboardVC
        switch UIDevice.current.screenType {
        
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE:
            
            if (searched) {
                let group = filtered_groups[indexPath.row]
                
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let group = publicGroups[indexPath.row]
                
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
                searchController.dismiss(animated: true, completion: nil)
            }
        case UIDevice.ScreenType.iPhones_6_6s_7_8:
            if (searched) {
                let group = filtered_groups[indexPath.row]
                
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
                searchController.dismiss(animated: true, completion: nil)
            }else{
                let group = publicGroups[indexPath.row]
                
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        case UIDevice.ScreenType.iPhones_6Plus_6sPlus_7Plus_8Plus:
            if (searched) {
                let group = filtered_groups[indexPath.row]
                
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
                searchController.dismiss(animated: true, completion: nil)
            }else{
                let group = publicGroups[indexPath.row]
                
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        case UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XR_11:
            
            if (searched) {
                let group = filtered_groups[indexPath.row]
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
                searchController.dismiss(animated: true, completion: nil)
            }else{
                let group = publicGroups[indexPath.row]
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        case UIDevice.ScreenType.iPhone_XSMax_ProMax:
            
            if (searched) {
                let group = filtered_groups[indexPath.row]
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
                searchController.dismiss(animated: true, completion: nil)
            }else{
                let group = publicGroups[indexPath.row]
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        default:
            
            if (searched) {
                let group = filtered_groups[indexPath.row]
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
                searchController.dismiss(animated: true, completion: nil)
            }else{
                let group = publicGroups[indexPath.row]
                controller.publicGroup = group
                print(group.groupName)
                print(group.groupId)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func getPublicGroups(){
        AuthNetworkManager.getPublicGroups { (result) in
            self.parseGetPublicGroupsResponse(result: result)
        }
    }
    
    private func parseGetPublicGroupsResponse(result: DataResponse<[GroupResponse], AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print(response)
            self.publicGroups.removeAll()
            for item in response {
                print("\(item.defaultCampaignId),\(item.groupName)")
                self.publicGroups.append(item)
            }
            self.publicGroups = publicGroups.sorted(by: {$0.groupName < $1.groupName})
            print(self.publicGroups)
            self.allGroupsTableView.reloadData()
            break
        case .failure(let _):
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
    
    
    //MY PUBLIC GROUPS
    func getContributionPublicGroups(){
        AuthNetworkManager.getContributionPublicGroups { (result) in
            self.parseGetContributionPublicGroupsResponse(result: result)
        }
    }
    
    private func parseGetContributionPublicGroupsResponse(result: DataResponse<[GroupResponse], AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("pub contri: \(response)")
            self.myPublicGroups.removeAll()
            for item in response {
                self.myPublicGroups.append(item)
            }
            print(self.myPublicGroups)
            if (self.myPublicGroups.count > 0){
                self.emptyView.isHidden = true
                print("hidden")
            }else {
                //                if (publicGroups.count > 0) {
                //                self.emptyView.isHidden = false
                //                }else {
                
                //                self.emptyView.isHidden = true
                //                    getPublicGroups()
                //                segmentedControl.selectedSegmentIndex = 1
                //                self.allGroupsTableView.reloadData()
                
                //                print("show")
                //                }
                print("show empty view")
                self.emptyView.isHidden = false
            }
            print("my public groups count \(myPublicGroups.count)")
            break
        case .failure( _):
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
