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

class PublicGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    

    @IBOutlet weak var tableView: UITableView!
    
    var publicGroups: [PublicGroupResponse] = []
    let cell = "cellId"
    
    var searchGroups: [PublicGroupResponse] = []
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filtered_groups: [PublicGroupResponse] = []
    var data = [""]
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        
        
        view.addSubview(textField)
        
        getPublicGroups()
        FTIndicator.showProgress(withMessage: "Getting public groups")
        
        //SearchBar
        searchController.searchBar.placeholder = "Search Group"
        searchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        self.tableView.register(UINib(nibName: "PublicGroupsViewController", bundle: nil), forCellReuseIdentifier: "PublicGroupsViewController")
        
        self.tableView.reloadData()
        
        
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
            filtered_groups = publicGroups.filter({ (group : PublicGroupResponse) -> Bool in
                
                return (group.groupName.lowercased().contains(searchText.lowercased()))
                
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
        let array = publicGroups.filter ({
            $0.groupName.localizedCaseInsensitiveContains(searchText)
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
    
    
    
    //DATE FORMATTER
    func convertDateFormatter(date: String) -> String
    {

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
        
        if (searched) {
            return self.filtered_groups.count
        }
        
        return publicGroups.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (searched) {
            
            let cell: GroupsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            
            //configure the search cell
            let pubGroup: PublicGroupResponse = self.filtered_groups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "people")
//            let url = URL(string: pubGroup.groupIconPath!)
            if(pubGroup.groupIconPath == "<null>") || (pubGroup.groupIconPath == nil) || (pubGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "people")
                cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
                
            }else {
//                Nuke.loadImage(with: url!, into: cell.groupsImage)
                cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
            }
            return cell
        }else {
            
            let dates = convertDateFormatter(date: "\(self.publicGroups[indexPath.row].created)")
            
            
            let cell: GroupsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            
            
            let pubGroup: PublicGroupResponse = self.publicGroups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "people")
            cell.groupsImage.borderColor = UIColor.green
            if(pubGroup.groupIconPath == "<null>") || (pubGroup.groupIconPath == nil) || (pubGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "people")
                cell.groupsName.text = self.publicGroups[indexPath.row].groupName
                cell.groupsDate.text = dates
                print(self.publicGroups[indexPath.row].groupName)
                
            }else {
//                Nuke.loadImage(with: URL(string: pubGroup.groupIconPath!)!, into: cell.groupsImage)
                cell.groupsName.text = self.publicGroups[indexPath.row].groupName
                cell.groupsDate.text = dates
                
                
            }
            
            return cell
        }
    }
    


    func getPublicGroups(){
        AuthNetworkManager.getPublicGroups { (result) in
            self.parseGetPublicGroupsResponse(result: result)
        }
    }
    
    private func parseGetPublicGroupsResponse(result: DataResponse<[PublicGroupResponse]>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()

            print(response)
            for item in response {
                self.publicGroups.append(item)
            }
            print(self.publicGroups)
            
            self.tableView.reloadData()
            break
        case .failure(let error):
            FTIndicator.dismissProgress()

            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(error: error), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    

}
