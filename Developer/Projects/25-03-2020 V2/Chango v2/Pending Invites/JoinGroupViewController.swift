//
//  JoinGroupViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
//import RealmSwift
import Alamofire
import Nuke
import FTIndicator
import Firebase
import FirebaseAuth
import FirebaseDatabase


class JoinGroupViewController: BaseViewController {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var inviteeName: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var termsConditions: UITextView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    var groupId: String = ""
//    var invited: Invite!
    var groups: GroupInviteResponse!
    var cashout: Double = 0.0
    let user = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        groupImage.layer.masksToBounds = true
        groupImage.layer.borderWidth = 2.0
        groupImage.borderColor = UIColor.red
        groupImage.layer.cornerRadius = 50.0
        groupImage.clipsToBounds = true
        
        groupName.text = groups.groupName
        if groups.groupIconPath == ""{
            print("group icon is nil")
            groupImage.image = UIImage(named: "people")
        }else {
        Nuke.loadImage(with: URL(string: groups.groupIconPath!)!, into: groupImage)
        }

        groupDescription.text = groups.description
        termsConditions.text = groups.tnc
        
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func joinGroupButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "loading")
        let parameter: JoinGroupParameter = JoinGroupParameter(groupId: groups.groupId)
        self.joinGroup(joinGroupParameter: parameter)
    }
    
    
    @IBAction func rejectGroupButtonAction(_ sender: UIButton) {
        let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
        
        let alert = UIAlertController(title: "Reject Invite", message: "Are you sure you want to reject this invite?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Reject", style: .default) { [self] (action: UIAlertAction!) in
            
            print("remove: \(user?.uid)")
            self.remove(child: self.user!.uid)

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
        
        let ref = Database.database().reference().child("invites").child((user?.uid)!)
        print("uid: \(user?.uid)")
        
        let itemReference = ref.child(child)
        itemReference.removeValue { (error, ref) in

            print(error)
        }
    }
    
    
    func joinGroup(joinGroupParameter: JoinGroupParameter) {
        AuthNetworkManager.joinGroup(parameter: joinGroupParameter) { (result) in
            self.parseJoinGroupResponse(result: result)
        }
    }

    
    
    private func parseJoinGroupResponse(result: DataResponse<JoinGroupResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)

            
                let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                
                let alert = UIAlertController(title: "Chango", message: "You have joined \(groups.groupName) successfully.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    self.remove(child: self.groups.groupId)
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
    

}
