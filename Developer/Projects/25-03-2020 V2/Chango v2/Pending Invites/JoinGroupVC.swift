//
//  JoinGroupVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 11/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import FTIndicator
import Firebase
import FirebaseAuth
import FirebaseDatabase

class JoinGroupVC: BaseViewController {

    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var aboutGroupLabel: UILabel!
    @IBOutlet weak var tnCLabel: UILabel!
    @IBOutlet weak var additionalPolicyLabel: UILabel!
    
    var groupId: String = ""
    var groups: GroupInviteResponse!
    var cashout: String = ""
    var tnc: String = ""
    var joinViaLink: Bool = false
    
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        groupNameLabel.text = groups.groupName
        aboutGroupLabel.text = groups.description
        tnCLabel.text = cashout
        additionalPolicyLabel.text = groups.tnc
        
        if groups.groupIconPath == ""{
            groupIcon.image = UIImage(named: "people")
        }else {
        Nuke.loadImage(with: URL(string: groups.groupIconPath!)!, into: groupIcon)
        }
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func joinGroupButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Accept Invite", message: "By joining \(groups.groupName), you agree to the Terms & Conditions of \(groups.groupName).", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "JOIN GROUP", style: .default) { (action: UIAlertAction!) in
            FTIndicator.showProgress(withMessage: "loading")
            let parameter: JoinPrivateGroupParameter = JoinPrivateGroupParameter(groupId: self.groups.groupId)
            self.joinGroup(joinGroupParameter: parameter)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func rejectInviteButtonAction(_ sender: Any) {
        let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
        
        let alert = UIAlertController(title: "Reject Invite", message: "Are you sure you want to reject this invite?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Reject", style: .default) { [self] (action: UIAlertAction!) in
            FTIndicator.showProgress(withMessage: "loading")
            let parameter: DeleteMemberInviteInGroupParameter = DeleteMemberInviteInGroupParameter(groupId: self.groups.groupId)
            self.deleteMemberInviteInGroup(deleteMemberInviteInGroupParameter: parameter)
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action: UIAlertAction!) in
            }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func remove(child: String) {
           let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("invites").child((user?.uid)!).child(groups.groupId)
           let itemReference = ref.child(child)
           itemReference.removeValue { (error, ref) in
               print(error)
           }
       }
       
       func joinGroup(joinGroupParameter: JoinPrivateGroupParameter) {
           AuthNetworkManager.joinPrivateGroup(parameter: joinGroupParameter) { (result) in
               self.parseJoinPrivateGroupResponse(result: result)
           }
       }
       
       private func parseJoinPrivateGroupResponse(result: DataResponse<JoinPrivateGroupResponse, AFError>){
           FTIndicator.dismissProgress()
           switch result.result {
           case .success(let response):
               print(response)

               
                   let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                   
            let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
                   
                   let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//                       self.remove(child: self.groups.groupId)
                    vc.modalPresentationStyle = .fullScreen
                       self.present(vc, animated: true, completion: nil)
                   }
                   
                   alert.addAction(okAction)
                   
                   self.present(alert, animated: true, completion: nil)
           
                   
               break
           case .failure(let error):
               
               
               if error.asAFError?.responseCode == 403 {
                   
                   let alert = UIAlertController(title: "Chango", message: "The maximum limit of the group has been reached", preferredStyle: .alert)
                   
                   let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                       
                   }
                   
                   alert.addAction(okAction)
                   
                   self.present(alert, animated: true, completion: nil)
               }else if error.asAFError?.responseCode == 502 {
                   
                   let alert = UIAlertController(title: "Chango", message: "Oops, something went wrong. Please try again later.", preferredStyle: .alert)
                   
                   let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                       
                   }
                   
                   alert.addAction(okAction)
                   
                   self.present(alert, animated: true, completion: nil)
               }else if error.asAFError?.responseCode == 400 {
                   
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
    
    
    func deleteMemberInviteInGroup(deleteMemberInviteInGroupParameter: DeleteMemberInviteInGroupParameter) {
        AuthNetworkManager.deleteMemberInviteInGroup(parameter: deleteMemberInviteInGroupParameter) { (result) in
            self.parseDeleteMemberInviteInGroupParameterResponse(result: result)
        }
    }
    
    private func parseDeleteMemberInviteInGroupParameterResponse(result: DataResponse<RegularResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)

            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
     let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
             vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            break
        case .failure(let error):
            if error.asAFError?.responseCode == 400 {
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
