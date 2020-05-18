//
//  ContactListVC.swift
//  Contact Picker
//
//  Created by Hosny Ben Savage on 11/11/2019.
//  Copyright © 2019 ITConsortium. All rights reserved.
//

import UIKit
import ContactsUI

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    var arrPhoneNumbers = [MyCNContact]()
    let cellId = "cellId"
    var phoneNumbers: [String] = []
    var selectedContacts: [MyCNContact] = []
    
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    var filteredContacts: [MyCNContact] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var phoneContacts = [PhoneContact]() // array of PhoneContact(It is model find it below)
    var filter: ContactsFilter = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Select Contacts"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        
        let contacts = PhoneContacts.getContacts()
        
        print(contacts)
        
        for item in contacts {
            
            arrPhoneNumbers.append(MyCNContact(name_: item.name!, phoneNumber_: item.phoneNumber!))
            
        }
        
        tableView.reloadData()
        
        
        searchController.searchBar.placeholder = "Search Contacts"
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        searchController.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        
    }

    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        print("send selected items to global array")
        print("you selected \(arrPhoneNumbers)")
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredContacts.removeAll(keepingCapacity: false)
        let array = arrPhoneNumbers.filter ({
            $0.name!.localizedCaseInsensitiveContains(searchText)
        })
        filteredContacts = array
        
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
    
    
    func setupContacts(){
        self.tableView.reloadData()
    }
    
    func searchMethod(searchText: String){
        //search inside search bar
        filteredContacts.removeAll()
        searchIndexes.removeAll()
        if(searchText.isEmpty){
            searched = false
            self.setupContacts()
            return
        }else if(searchController.isActive && !(searchText.isEmpty)){
            filteredContacts = arrPhoneNumbers.filter({ (contact : MyCNContact) -> Bool in
                
                return (contact.name!.lowercased().contains(searchText.lowercased()))
                
            })
            searched = true
            self.setupContacts()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searched) {
            return filteredContacts.count
        }else
        {
            return arrPhoneNumbers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (searched) {
            let cell: ContactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            
            cell.contactName?.text = filteredContacts[indexPath.row].name
            cell.contactNumber?.text = filteredContacts[indexPath.row].phoneNumber?.stringValue
            
            return cell
        }else {
            let cell: ContactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            
            cell.contactName?.text = arrPhoneNumbers[indexPath.row].name
            cell.contactNumber?.text = arrPhoneNumbers[indexPath.row].phoneNumber?.stringValue
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (searched) {
            let myContacts: MyCNContact = self.arrPhoneNumbers[indexPath.row]
            
            //add selected contact
            selectedContacts.append(myContacts)
            
            print(selectedContacts)
            
        }else {
            let myContacts: MyCNContact = self.arrPhoneNumbers[indexPath.row]
            
            //add selected contact
            selectedContacts.append(myContacts)
            
            print(selectedContacts)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (searched) {
            let myContacts: MyCNContact = self.arrPhoneNumbers[indexPath.row]
            
            //remove deselected contact
            selectedContacts.removeAll{$0 == myContacts}
            
            print(selectedContacts)
        }else {
            let myContacts: MyCNContact = self.arrPhoneNumbers[indexPath.row]
            
            //remove deselected contact
            selectedContacts.removeAll{$0 == myContacts}
            
            print(selectedContacts)
        }
    }

}
