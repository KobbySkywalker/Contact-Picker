//
//  GroupSettingsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import DLRadioButton

class GroupSettingsViewController: BaseViewController {
    
    @IBOutlet weak var cashoutSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loansSegmentedControl: UISegmentedControl!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var acceptLoansCheckBox: VKCheckbox!
    @IBOutlet weak var forLoansLabel: UILabel!
    @IBOutlet weak var thirty: DLRadioButton!
    @IBOutlet weak var loanStack: UIStackView!
    @IBOutlet weak var cashoutStack: UIStackView!
    @IBOutlet weak var loanThirty: DLRadioButton!
    
    //cashout button outlet
    @IBOutlet weak var cashout25: UIButton!
    @IBOutlet weak var cashout50: UIButton!
    @IBOutlet weak var cashout75: UIButton!
    @IBOutlet weak var cashout100: UIButton!
    @IBOutlet weak var cashoutCustom: UIButton!
    
    //borrow button outlet
    @IBOutlet weak var borrow25: UIButton!
    @IBOutlet weak var borrow50: UIButton!
    @IBOutlet weak var borrow75: UIButton!
    @IBOutlet weak var borrow100: UIButton!
    @IBOutlet weak var borrowCustom: UIButton!
    
    @IBOutlet weak var borrowLabel: UILabel!
    @IBOutlet weak var borrowInfo: UILabel!
    @IBOutlet weak var borrowStack: UIStackView!
    
    @IBOutlet weak var cash25red: UIImageView!
    @IBOutlet weak var cash50red: UIImageView!
    @IBOutlet weak var cash75red: UIImageView!
    @IBOutlet weak var cash100red: UIImageView!
    @IBOutlet weak var cashcustomred: UIImageView!
    
    @IBOutlet weak var borrow25red: UIImageView!
    @IBOutlet weak var borrow50red: UIImageView!
    @IBOutlet weak var borrow75red: UIImageView!
    @IBOutlet weak var borrow100red: UIImageView!
    @IBOutlet weak var customRed: UIImageView!
    
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var cashoutTitle: UILabel!
    @IBOutlet weak var borrowCheckStack: UIStackView!
    @IBOutlet weak var cashoutStatementLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    var countryId: String = ""
    var groupName: String = ""
    var cashoutMinVote: String = ""
    var loanMinVote: String = ""
    var groupDesc: String = ""
    var tnc: String = ""
    var loanCheck: Bool = false
    var loanFlag: String = "0"
    var cashoutPolicyEdit: Bool = false
    var cashoutPercentage: String = ""
    var groupId: String = ""
    var groupProfile: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
//        self.thirty.isMultipleSelectionEnabled = false
        if cashoutPolicyEdit {
            borrowCheckStack.isHidden = true
            disableCashoutOption(minVote: cashoutPercentage)
            cashoutTitle.text = "Modify Cashout Policy"
            cashoutStatementLabel.text = "Please note that the exisitng cashout policy is \(cashoutPercentage). To modify, choose among these options"
            continueBtn.setTitle("Request Change", for: .normal)
        }else {
            borrowCheckStack.isHidden = false
        }
        
        acceptLoansCheckBox.checkboxValueChangedBlock = {
            isOn in
            self.acceptLoansCheckBox.vBorderColor = UIColor(hexString: "#228CC7")
            self.acceptLoansCheckBox.backgroundColor = UIColor(hexString: "#228CC7")
            self.acceptLoansCheckBox.color = .white

            print("Checkbox is \(isOn ? "ON" : "OFF")")
            if self.acceptLoansCheckBox.isOn(){
                self.borrowLabel.isHidden = false
                self.borrowStack.isHidden = false
                self.borrowInfo.isHidden = false
                self.loanCheck = true
                self.loanFlag = "1"
            }else {
                self.acceptLoansCheckBox.backgroundColor = UIColor.white
                self.borrowLabel.isHidden = true
                self.borrowStack.isHidden = true
                self.borrowInfo.isHidden = true
                self.loanCheck = false
                self.loanFlag = "0"
            }
        }
    }

    func disableCashoutOption(minVote: String) {
        if minVote == "0.25" {
            cashout25.isEnabled = false
            cashout25.isHidden = true
            cashout25.backgroundColor = .gray
        }else if minVote == "0.50" {
            cashout50.isEnabled = false
            cashout50.isHidden = true
            cashout50.backgroundColor = .gray
        }else if minVote == "0.75" {
            cashout75.isEnabled = false
            cashout75.isHidden = true
            cashout75.backgroundColor = .gray
        }else if minVote == "1.00" {
            cashout100.isEnabled = false
            cashout100.isHidden = true
            cashout100.backgroundColor = .gray
        }else {
            cashoutCustom.isEnabled = false
            cashoutCustom.isHidden = true
            cashoutCustom.backgroundColor = .gray
        }
    }

    func enableSelectedOption(minVote: String) {
        if minVote == "0.25" {
            cashout25.backgroundColor = UIColor(hexString: "#05406F")
            cashout50.backgroundColor = UIColor(hexString: "#228CC7")
            cashout75.backgroundColor = UIColor(hexString: "#228CC7")
            cashout100.backgroundColor = UIColor(hexString: "#228CC7")
            cashoutCustom.backgroundColor = UIColor(hexString: "#228CC7")

            cash25red.isHidden = false
            cash50red.isHidden = true
            cash75red.isHidden = true
            cash100red.isHidden = true
            cashcustomred.isHidden = true
        }else if minVote == "0.50" {
            cashout50.backgroundColor = UIColor(hexString: "#05406F")
            cashout25.backgroundColor = UIColor(hexString: "#228CC7")
            cashout75.backgroundColor = UIColor(hexString: "#228CC7")
            cashout100.backgroundColor = UIColor(hexString: "#228CC7")
            cashoutCustom.backgroundColor = UIColor(hexString: "#228CC7")
                //red check
            cash50red.isHidden = false
            cash25red.isHidden = true
            cash75red.isHidden = true
            cash100red.isHidden = true
            cashcustomred.isHidden = true
        }else if minVote == "0.75" {
            cashout75.backgroundColor = UIColor(hexString: "#05406F")
            cashout50.backgroundColor = UIColor(hexString: "#228CC7")
            cashout25.backgroundColor = UIColor(hexString: "#228CC7")
            cashout100.backgroundColor = UIColor(hexString: "#228CC7")
            cashoutCustom.backgroundColor = UIColor(hexString: "#228CC7")

            cash75red.isHidden = false
            cash25red.isHidden = true
            cash50red.isHidden = true
            cash100red.isHidden = true
            cashcustomred.isHidden = true
        }else if minVote == "1.00" {
            cashout100.backgroundColor = UIColor(hexString: "#05406F")
            cashout50.backgroundColor = UIColor(hexString: "#228CC7")
            cashout75.backgroundColor = UIColor(hexString: "#228CC7")
            cashout25.backgroundColor = UIColor(hexString: "#228CC7")
            cashoutCustom.backgroundColor = UIColor(hexString: "#228CC7")

            cash100red.isHidden = false
            cash25red.isHidden = true
            cash75red.isHidden = true
            cash50red.isHidden = true
            cashcustomred.isHidden = true
        }else {
            cashoutCustom.backgroundColor = UIColor(hexString: "#05406F")
            cashout50.backgroundColor = UIColor(hexString: "#228CC7")
            cashout75.backgroundColor = UIColor(hexString: "#228CC7")
            cashout100.backgroundColor = UIColor(hexString: "#228CC7")
            cashout25.backgroundColor = UIColor(hexString: "#228CC7")

            cashcustomred.isHidden = false
            cash25red.isHidden = true
            cash75red.isHidden = true
            cash100red.isHidden = true
            cash50red.isHidden = true

            showAlert(title: "Cashout Custom Policy", message: "Selecting this policy means that only and all Admins will vote for cashout. The minimum number of Admins must not be less than 2.")
        }
    }
    
    @IBAction func cashoutBtn25(_ sender: Any) {
        cashoutMinVote = "0.25"
        if cashoutPolicyEdit && cashoutPercentage != "0.25" {
            disableCashoutOption(minVote: cashoutPercentage)
            enableSelectedOption(minVote: cashoutMinVote)
        }else {
            enableSelectedOption(minVote: cashoutMinVote)
        }
    }
    
    @IBAction func cashoutBtn50(_ sender: Any) {
        cashoutMinVote = "0.50"
        if cashoutPolicyEdit && cashoutPercentage != "0.50"{
            disableCashoutOption(minVote: cashoutPercentage)
            enableSelectedOption(minVote: cashoutMinVote)
        }else {
            enableSelectedOption(minVote: cashoutMinVote)
        }
    }
    
    @IBAction func cashoutBtn75(_ sender: Any) {
        cashoutMinVote = "0.75"
        if cashoutPolicyEdit && cashoutPercentage != "0.25"{
            disableCashoutOption(minVote: cashoutPercentage)
            enableSelectedOption(minVote: cashoutMinVote)
        }else {
            enableSelectedOption(minVote: cashoutMinVote)
        }
    }
    
    @IBAction func cashoutBtn100(_ sender: Any) {
        cashoutMinVote = "1.00"
        if cashoutPolicyEdit && cashoutPercentage != "0.25"{
            disableCashoutOption(minVote: cashoutPercentage)
            enableSelectedOption(minVote: cashoutMinVote)
        }else {
            enableSelectedOption(minVote: cashoutMinVote)
        }
    }
    
    @IBAction func cashoutCustomBtn(_ sender: Any) {
        cashoutMinVote = "custom"
        if cashoutPolicyEdit && cashoutPercentage != "0.25"{
            disableCashoutOption(minVote: cashoutPercentage)
            enableSelectedOption(minVote: cashoutMinVote)
        }else {
            enableSelectedOption(minVote: cashoutMinVote)
        }
    }
    
    
    
    
    @IBAction func borrowBtn25(_ sender: Any) {
        loanMinVote = "0.25"
        borrow25.backgroundColor = UIColor(hexString: "#05406F")
        borrow50.backgroundColor = UIColor(hexString: "#228CC7")
        borrow75.backgroundColor = UIColor(hexString: "#228CC7")
        borrow100.backgroundColor = UIColor(hexString: "#228CC7")
        borrowCustom.backgroundColor = UIColor(hexString: "#228CC7")
        
        borrow25red.isHidden = false
        borrow50red.isHidden = true
        borrow75red.isHidden = true
        borrow100red.isHidden = true
        customRed.isHidden = true
    }
    
    @IBAction func borrowBtn50(_ sender: Any) {
        loanMinVote = "0.50"
        borrow50.backgroundColor = UIColor(hexString: "#05406F")
        borrow25.backgroundColor = UIColor(hexString: "#228CC7")
        borrow75.backgroundColor = UIColor(hexString: "#228CC7")
        borrow100.backgroundColor = UIColor(hexString: "#228CC7")
        borrowCustom.backgroundColor = UIColor(hexString: "#228CC7")
        
        borrow25red.isHidden = true
        borrow50red.isHidden = false
        borrow75red.isHidden = true
        borrow100red.isHidden = true
        customRed.isHidden = true
    }
    
    @IBAction func borrowBtn75(_ sender: Any) {
        loanMinVote = "0.75"
        borrow75.backgroundColor = UIColor(hexString: "#05406F")
        borrow50.backgroundColor = UIColor(hexString: "#228CC7")
        borrow25.backgroundColor = UIColor(hexString: "#228CC7")
        borrow100.backgroundColor = UIColor(hexString: "#228CC7")
        borrowCustom.backgroundColor = UIColor(hexString: "#228CC7")
        
        borrow25red.isHidden = true
        borrow50red.isHidden = true
        borrow75red.isHidden = false
        borrow100red.isHidden = true
        customRed.isHidden = true
    }
    
    @IBAction func borrowBtn100(_ sender: Any) {
        loanMinVote = "1.00"
        borrow100.backgroundColor = UIColor(hexString: "#05406F")
        borrow50.backgroundColor = UIColor(hexString: "#228CC7")
        borrow75.backgroundColor = UIColor(hexString: "#228CC7")
        borrow25.backgroundColor = UIColor(hexString: "#228CC7")
        borrowCustom.backgroundColor = UIColor(hexString: "#228CC7")

        
        borrow25red.isHidden = true
        borrow50red.isHidden = true
        borrow75red.isHidden = true
        borrow100red.isHidden = false
        customRed.isHidden = true
    }
    
    
    @IBAction func borrowCustom(_ sender: Any) {
        loanMinVote = "custom"
        borrow100.backgroundColor = UIColor(hexString: "#228CC7")
        borrow50.backgroundColor = UIColor(hexString: "#228CC7")
        borrow75.backgroundColor = UIColor(hexString: "#228CC7")
        borrow25.backgroundColor = UIColor(hexString: "#228CC7")
        borrowCustom.backgroundColor = UIColor(hexString: "#05406F")
        
        borrow25red.isHidden = true
        borrow50red.isHidden = true
        borrow75red.isHidden = true
        borrow100red.isHidden = true
        customRed.isHidden = false
        
        showAlert(title: "Borrow Custom Policy", message: "Selecting this policy means that only and all Approvers will vote for borrowing. The minimum number of Approvers must not be less than 2.")
        
    }
    
    
    @IBAction func ThirtyPercent(_ sender: DLRadioButton) {
        print("\(String(describing: thirty.selected()!.titleLabel!.text))")
        let voteValue = thirty.selected()!.titleLabel!.text
        if voteValue == "25%" {
            cashoutMinVote = "0.25"
        }else if voteValue == "50%" {
            cashoutMinVote = "0.5"
        }else if voteValue == "75%"{
            cashoutMinVote = "0.75"
        }else if voteValue == "100%"{
            cashoutMinVote = "1.0"
        }
    }
    
    @IBAction func loanPercentages(_ sender: DLRadioButton) {
        print("\(String(describing: loanThirty.selected()?.titleLabel!.text))")
        let voteValue = loanThirty.selected()!.titleLabel!.text
        if voteValue == "25%" {
            loanMinVote = "0.25"
        }else if voteValue == "50%" {
            loanMinVote = "0.5"
        }else if voteValue == "75%"{
            loanMinVote = "0.75"
        }else if voteValue == "100%"{
            loanMinVote = "1.0"
        }
    }
    
    @IBAction func forCashout(_ sender: UISegmentedControl) {
        switch cashoutSegmentedControl.selectedSegmentIndex {
        case 0:
            cashoutMinVote = "0.3"
            break
        case 1:
            cashoutMinVote = "0.5"
            break
        case 2:
            cashoutMinVote = "0.7"
            break
        case 3:
            cashoutMinVote = "0.9"
            break
        case 4:
            cashoutMinVote = "1.0"
            break
        default:
            cashoutMinVote = "0.3"
            break
        }
    }
    
    @IBAction func forLoans(_ sender: UISegmentedControl) {
        switch loansSegmentedControl.selectedSegmentIndex {
        case 0:
            loanMinVote = "0.3"
            break
        case 1:
            loanMinVote = "0.5"
            break
        case 2:
            loanMinVote = "0.7"
            break
        case 3:
            loanMinVote = "0.9"
            break
        case 4:
            loanMinVote = "1.0"
            break
        default:
            loanMinVote = "0.3"
            break
        }
    }
    
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if cashoutPolicyEdit {
            print("request change")
            if cashoutMinVote == "" {
                showAlert(title: "Chango", message: "Please select a cashout percentage.")
            }else {
            let vc: VerifyAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyaccount") as! VerifyAccountVC
            vc.groupName = groupName
            vc.cashoutPolicyEdit = cashoutPolicyEdit
            vc.groupId = groupId
            vc.newMinVote = cashoutMinVote
            vc.groupIconPath = groupProfile
            self.navigationController?.pushViewController(vc, animated: true)
                }
        }else {
            actionsForGroupCreation()
        }
    }

    func actionsForGroupCreation() {
        if cashoutMinVote == "" {
            showAlert(title: "Chango", message: "Please select a cashout percentage.")
        }else if (loanCheck == true && acceptLoansCheckBox.isOn() && loanMinVote == "") {
            showAlert(title: "Chango", message: "Please select a loan percentage.")
        } else {
            let vc: Terms_ConditionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "term") as! Terms_ConditionsViewController
            vc.cashoutMinVote = cashoutMinVote
            vc.loanMinVote = loanMinVote
            vc.groupName = groupName
            vc.countryId = countryId
            vc.groupDesc = groupDesc
            vc.loanFlag = loanFlag
            print(groupDesc)
            print(cashoutMinVote)
            print(loanMinVote)
            print(groupName)
            print(countryId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
