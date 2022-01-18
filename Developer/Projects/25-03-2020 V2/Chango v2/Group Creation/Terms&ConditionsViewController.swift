//
//  Terms&ConditionsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator

class Terms_ConditionsViewController: BaseViewController, UITextViewDelegate {
    
    var agreed = ""
    var countryId: String = ""
    var groupName: String = ""
    var groupDesc: String = ""
    var cashoutMinVote: String = ""
    var loanMinVote: String = ""
    var loanFlag: String = ""
    var msisdnList: [String] = []


    @IBOutlet weak var termsAndConditions: UITextView!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var agreementCheck: VKCheckbox!
    @IBOutlet weak var characterCount: UILabel!
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsAndConditions.text = "Add your group's specific terms and conditions here"
        termsAndConditions.textColor = UIColor.lightGray
        termsAndConditions.delegate = self
        showChatController()
        disableDarkMode()
        privacyPolicyLabel.text = "View the standard terms and conditions of every Chango group here"
        let text = (privacyPolicyLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "here")
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor(red: 255/255, green: 44/255, blue: 42/255, alpha: 1), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        privacyPolicyLabel.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        privacyPolicyLabel.isUserInteractionEnabled = true
        privacyPolicyLabel.addGestureRecognizer(tapAction)
        agreementCheck.checkboxValueChangedBlock = {
            isOn in
            self.agreementCheck.vBorderColor = UIColor(hexString: "#727272")
            self.agreementCheck.color = UIColor(hexString: "#727272")
            print("Checkbox is \(isOn ? "ON" : "OFF")")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            print("clear your text view")
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add your group's specific terms and conditions here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = termsAndConditions.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        // make sure the result is under 16 characters
        return updatedText.count <= 240
    }

    
    //For example adding uilabel then setup
    func setupTapLabel() {
        privacyPolicyLabel.text = "View the standard terms and conditions of every Chango group here"
        let text = (privacyPolicyLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "here")
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor(red: 255/255, green: 44/255, blue: 42/255, alpha: 1), range: range1)
//        UIColor.init(red: 255/255, green: 44/255, blue: 42/255, alpha: 1)
        privacyPolicyLabel.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        privacyPolicyLabel.isUserInteractionEnabled = true
        privacyPolicyLabel.addGestureRecognizer(tapAction)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (privacyPolicyLabel.text)!
        let hereRange = (text as NSString).range(of: "here")
        if gesture.didTapAttributedTextInLabel(label: privacyPolicyLabel, inRange: hereRange) {
            print("here tapped")
            let vc: PrivacyPolicyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "privacy") as! PrivacyPolicyViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    @IBAction func nextButtonAction(_ sender: UIButton) {
        if (agreementCheck.on) {
            agreed = "yes"
        }else {
            agreed = "no"
        }
        if agreed == "no" {
            showAlert(title: "Chango", message: "You must agree with the terms and conditions before you can proceed.")
        } else {
            
            let vc: CreateGroupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "create") as! CreateGroupViewController
            vc.groupName = groupName
            vc.countryId = countryId
            vc.groupDesc = groupDesc
            vc.cashoutMinVote = cashoutMinVote
            vc.loanMinVote = loanMinVote
            if termsAndConditions.textColor == UIColor.lightGray {
                vc.tnc = ""
            }else {
            vc.tnc = termsAndConditions.text!
            }
            vc.loanFlag = loanFlag
            self.navigationController?.pushViewController(vc, animated: true)
            
//            print(groupName)
//            print(countryId)
//            print(cashoutMinVote)
//            print(loanMinVote)
//            print(termsAndConditions.text!)
//            print(loanFlag)
//            if loanMinVote == "" {
//                print("no loans for this group")
//                let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                let ballotArray = [ballotDetailOne]
//                let parameterr: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.termsAndConditions.text!, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                print(parameterr)
//                FTIndicator.showProgress(withMessage: "creating group")
//                self.createGroup(createGroupParameter: parameterr)
//            }else {
//                let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                let ballotDetailTwo = BallotDetail(ballotId: "loan", minVote: self.loanMinVote)
//                let ballotArray = [ballotDetailOne, ballotDetailTwo]
//                let parameter: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.termsAndConditions.text!, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                print(parameter)
//                FTIndicator.showProgress(withMessage: "creating group")
//                self.createGroup(createGroupParameter: parameter)
//            }

        }
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func createGroup(createGroupParameter: GroupCreationParameter) {
        AuthNetworkManager.groupCreation(parameter: createGroupParameter) { (result) in
            self.parseCreateGroupResponse(result: result)
        }
    }
    
    private func parseCreateGroupResponse(result: DataResponse<GroupCreationResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            print("empty msisdn")
//            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
//            let alert = UIAlertController(title: "Chango", message: "Group created successfully.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//                self.present(vc, animated: true, completion: nil)
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
            
            let vc: CreateGroupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "create") as! CreateGroupViewController
            vc.groupName = groupName
            vc.countryId = countryId
            vc.groupDesc = groupDesc
            vc.cashoutMinVote = cashoutMinVote
            vc.loanMinVote = loanMinVote
            if termsAndConditions.textColor == UIColor.lightGray {
                vc.tnc = ""
            }else {
            vc.tnc = termsAndConditions.text!
            }
            vc.loanFlag = loanFlag
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .failure(_ ):
            if (result.response?.statusCode == 400) {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
