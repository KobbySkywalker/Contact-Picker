//
//  GroupPolicyVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 09/12/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Nuke

class GroupPolicyVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    let cell = "cellId"
    
    var cashout: String = ""
    var loan: String = ""
    var makeadmin: String = ""
    var termsAndConditions: String = ""
    var makeAdmin: String = ""
    var dropMember: String = ""
    var groupIconPath: String = ""
    var creatorInfo: String = ""
    var groupName: String = ""
    var isAdmin: String = ""
    var cashoutPercentage: String = ""
    var groupId: String = ""

//    var groupPolicies: [GroupPoliciesResponse] = []
    var groupPolicy: [GroupPolicyResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()

        self.title = "Group Policies"
        
        tableView.tableFooterView = UIView()
        
//        for item in groupPolicies {
//
//            if item.cashout != nil {
//            cashout = "\(Int(item.cashout!))"
//            }
//            if item.loan != nil {
//            loan = "\(Int(item.loan ?? 0.0))"
//            }
//            if item.TermsConditions != nil {
//            termsAndConditions = item.TermsConditions ?? "nil"
//            }
//        }
        
        for item in groupPolicy {
            
            if item.termsAndConditions != nil {
                termsAndConditions = item.termsAndConditions ?? ""
            }
            if item.cashout != nil {
                cashout = item.cashout ?? ""
            }
            if item.loan != nil {
                loan = item.loan ?? ""
            }
            if item.makeAdmin != nil {
                makeAdmin = item.makeAdmin ?? ""
            }
            if item.dropMember != nil {
                dropMember = item.dropMember ?? ""
            }
            if item.cashoutPercentage != nil {
                cashoutPercentage = item.cashoutPercentage ?? ""
            }
        }
        
        
        createdLabel.text = "\(creatorInfo)"
        groupNameLabel.text = groupName
        
        print("cashout: \(cashout)")

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "PolicyCell", bundle: nil), forCellReuseIdentifier: "PolicyCell")
        
        if (groupIconPath == "<null>") || (groupIconPath == ""){
            groupImage.image = UIImage(named: "defaultgroupicon")
            groupImage.contentMode = .scaleAspectFit
        }else {
            groupImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupImage)
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 106.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: PolicyCell = self.tableView.dequeueReusableCell(withIdentifier: "PolicyCell", for: indexPath) as! PolicyCell
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.policyName.text = "Removing Member"
            cell.policyStatement.text = "\(dropMember)"
        }else if indexPath.row == 2 {
            cell.policyName.text = "Cashout Policy"
            cell.policyStatement.text = "\(cashout)"
            if isAdmin == "false" {
                cell.editPolicyView.isHidden = true
            }else {
                cell.editPolicyView.isHidden = false
                cell.editPolicyView.tappable = true
                cell.editPolicyView.callback = {
                    let vc: GroupSettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupsettings") as! GroupSettingsViewController
                    vc.cashoutPolicyEdit = true
                    vc.cashoutPercentage = self.cashoutPercentage
                    vc.groupName = self.groupName
                    vc.groupId = self.groupId
                    vc.groupProfile = self.groupIconPath
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.editPolicyView.tag = indexPath.row
            }
        }else if indexPath.row == 3 {
            if loan == "0" {
                cell.policyName.text = "Borrowing Policy"
                cell.policyStatement.text = "This group does not support borrowing."
            }else {
                cell.policyName.text = "Borrowing Policy"
                cell.policyStatement.text = "\(loan)"
            }
        }else if indexPath.row == 4 {
            cell.policyName.text = "Group's Specific Terms and Conditions:"
            cell.policyStatement.text = termsAndConditions
        }else if indexPath.row == 1 {
            cell.policyName.text = "Make Admin Policy"
            cell.policyStatement.text = "\(makeAdmin)"
        }
        
        return cell
    }
}
