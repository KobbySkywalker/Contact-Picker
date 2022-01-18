//
//  RoleVoteCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 09/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator

class RoleVoteCell1: UIViewController {

    @IBOutlet weak var noVoteButton: UIButton!
    @IBOutlet weak var yesVoteButton: UIButton!
    
    
    var admin: Int = 0
    var approver: Int = 0
    var drop: Int = 0
    var groupId: String = ""
    var memberId: String = ""
    
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func noVoteButtonAction(_ sender: UIButton) {
        if admin == 1 {
            
            FTIndicator.showProgress(withMessage: "voting")
            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "0")
            self.revokeAdmin(revokeAdminParameter: parameter)
            
        }else if approver == 1 {
            FTIndicator.showProgress(withMessage: "voting")
            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "0")
            self.revokeAdmin(revokeAdminParameter: parameter)
            
        }else if drop == 1 {
            
            FTIndicator.showProgress(withMessage: "voting")
            let parameter: DropMemberParameter = DropMemberParameter(groupId: groupId, removeMemberId: memberId, status: "0")
            self.dropMember(dropMemberParameter: parameter)
            
        }
        
    }
    
    @IBAction func yesVoteButtonAction(_ sender: UIButton) {
        
        if admin == 1 {
            
            FTIndicator.showProgress(withMessage: "voting")
            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "1")
            self.revokeAdmin(revokeAdminParameter: parameter)
            
        }else if approver == 1 {
            
            FTIndicator.showProgress(withMessage: "voting")
            let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
            self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
            
        }else if drop == 1 {
            
            FTIndicator.showProgress(withMessage: "voting")
            let parameter: DropMemberParameter = DropMemberParameter(groupId: groupId, removeMemberId: memberId, status: "0")
            self.dropMember(dropMemberParameter: parameter)
            
        }
    }
    
    
    
    //REVOKE LOAN APPROVER
    func revokeLoanApprover(revokeLoanApproverParameter: RevokeLoanApproverParameter) {
        AuthNetworkManager.revokeLoanApprover(parameter: revokeLoanApproverParameter) { (result) in
            self.parseRevokeLoanApproverResponse(result: result)
        }
    }
    
    
    
    
    private func parseRevokeLoanApproverResponse(result: DataResponse<RevokeLoanApproverResponse>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            //            self.remove(child: self.groupId)
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(error: error), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //REVOKE ADMIN
    func revokeAdmin(revokeAdminParameter: RevokeAdminParameter) {
        AuthNetworkManager.revokeAdmin(parameter: revokeAdminParameter) { (result) in
            self.parseRevokeAdminResponse(result: result)
        }
    }
    
    
    private func parseRevokeAdminResponse(result: DataResponse<RevokeAdminResponse>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            //            self.remove(child: self.groupId)
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            break
        case .failure(let error):
            
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(error: error), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //DROP MEMBER
    func dropMember(dropMemberParameter: DropMemberParameter) {
        AuthNetworkManager.dropMember(parameter: dropMemberParameter) { (result) in
            self.parseDropMemberResponse(result: result)
        }
    }
    
    
    
    
    private func parseDropMemberResponse(result: DataResponse<RevokeAdminResponse>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            //            self.remove(child: self.groupId)
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(error: error), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
