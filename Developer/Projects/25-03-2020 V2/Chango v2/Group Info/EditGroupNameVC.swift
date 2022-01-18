//
//  EditGroupNameVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/02/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import Nuke

var newGroupName: String = ""
var reloadGroupTable: Bool = false

class EditGroupNameVC: BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var creatorDateLabel: UILabel!
    @IBOutlet weak var editGroupNameField: ACFloatingTextfield!
    
    var groupName: String = ""
    var groupId: String = ""
    var creatorInfo: String = ""
    var groupIconPath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        
        // Do any additional setup after loading the view.
        
//        editGroupNameField.setLeftPaddingPoints(20)
//        editGroupNameField.setRightPaddingPoints(20)
        groupNameLabel.text = groupName
        
        if (groupIconPath == "<null>") || (groupIconPath == ""){
            groupImage.image = UIImage(named: "defaultgroupicon")
                    print(groupIconPath)
            groupImage.contentMode = .scaleAspectFit
            
        }else {
            groupImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupImage)
            
        }
        
        creatorDateLabel.text = creatorInfo
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editGroupNameField.becomeFirstResponder()
        if groupName != "" {
            self.editGroupNameField.text = groupName
        }else {
            self.editGroupNameField.text = ""
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveName(_ sender: UIButton) {
        print("save name")
        
        if editGroupNameField.text!.isEmpty {
            let alert = UIAlertController(title: "Edit Group Name", message: "Group Name cannot be empty", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                

            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if groupName == editGroupNameField.text {
            let alert = UIAlertController(title: "Edit Group Name", message: "Group Name cannot be the same as the old one", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                

            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            
            let parameter: EditGroupNameParameter = EditGroupNameParameter(groupId: groupId, groupName: editGroupNameField.text!)
            editGroupName(editGroupNameParameter: parameter)
        }

    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        print("cancel")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //EDIT GROUP NAME
    func editGroupName(editGroupNameParameter: EditGroupNameParameter) {
        AuthNetworkManager.editGroupName(parameter: editGroupNameParameter) { (result) in
            self.parseEditGroupNameResponse(result: result)
        }
    }
    
    
    private func parseEditGroupNameResponse(result: DataResponse<GroupResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            
            let alert = UIAlertController(title: "Edit Group Name", message: "Group Name changed successfully.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                    SwiftEventBus.post("namechange", sender: GroupNameChangeEvent(groupName_: response.groupName))

                
                self.navigationController?.popViewController(animated: true)
            
                
            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
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
    
    
}





extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
