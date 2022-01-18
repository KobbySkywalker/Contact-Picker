//
//  FeebackViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FTIndicator
import Alamofire
import Nuke

class FeebackViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var makeAnonymous: VKCheckbox!
    @IBOutlet weak var groupIconPath: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var nameView: UIView!
    
    var anonymous: String = ""
    var campaignId: String = ""
    var publicGroup: GroupResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        makeAnonymous.checkboxValueChangedBlock = {
            isOn in
            self.makeAnonymous.vBorderColor = UIColor(hexString: "#228CC7")
            self.makeAnonymous.backgroundColor = UIColor(hexString: "#228CC7")
            self.makeAnonymous.color = .white
            print("Checkbox is \(isOn ? "ON" : "OFF")")
            
            if self.makeAnonymous.isOn() {

            }else{
                self.makeAnonymous.backgroundColor = UIColor.white
            }
        }
        
        let user = Auth.auth().currentUser

        groupName.text = publicGroup.groupName
        
        textView.delegate = self
        textView.text = "Write something..."
        
        if (publicGroup.groupIconPath == "<null>") || (publicGroup.groupIconPath == ""){
            groupIconPath.image = UIImage(named: "defaultgroupicon")
                    print(publicGroup.groupIconPath)
            groupIconPath.contentMode = .scaleAspectFit
        }else {
            groupIconPath.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: publicGroup.groupIconPath!)!, into: groupIconPath)
        }

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write something..." {
            textView.text = ""
            print("change text to nil")
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.text = "Write something..."
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = publicGroup.groupName
        self.navigationItem.titleView?.tintColor = UIColor.white
        print(publicGroup.groupName)
    }


    @IBAction func sendButtonAction(_ sender: UIButton) {
        
        if makeAnonymous.on {
            anonymous = "true"
        }else {
            anonymous = "false"
        }
        
        if (textView.text!.isEmpty) || (textView.text == "Write something...") {
            let alert = UIAlertController(title: "Send Feedback", message: "Please fill the feedback field.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {
        FTIndicator.showProgress(withMessage: "sending")
            let parameter: FeedbackParameter = FeedbackParameter(anonymous: anonymous, campaignId: campaignId, groupId: publicGroup.groupId, message: textView.text!)
        sendFeedback(sendFeedbackParameter: parameter)
        }
    }
    
    //SEND FEEDBACK
    func sendFeedback(sendFeedbackParameter: FeedbackParameter) {
        AuthNetworkManager.sendFeedback(parameter: sendFeedbackParameter) { (result) in
            self.parseSendFeedback(result: result)
        }
    }
    
    
    private func parseSendFeedback(result: DataResponse<Feedback, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            let alert = UIAlertController(title: "Chango", message: "Your feedback has been successfully sent.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            if (result.response?.statusCode == 400) {
                
                sessionTimeout()
                
            }else{
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
