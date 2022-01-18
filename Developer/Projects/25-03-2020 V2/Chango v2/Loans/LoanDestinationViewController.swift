//
//  LoanDestinationViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 11/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import DropDown

class LoanDestinationViewController: BaseViewController {

    
    @IBOutlet weak var destinationTypeButton: UIButton!
    @IBOutlet weak var accountNumber: ACFloatingTextfield!
    @IBOutlet weak var destinationBankButton: UIButton!
    @IBOutlet weak var destinationBankLabel: UILabel!
    @IBOutlet weak var selectBankStack: UIStackView!
    @IBOutlet weak var selectDestinationStack: UIStackView!
    @IBOutlet weak var recipientAccountStack: UIStackView!
    @IBOutlet weak var destinationTypeLabel: UIButton!
    @IBOutlet weak var selectDestinationLabel: UILabel!
    @IBOutlet weak var destinationTypeLbl: UILabel!
    @IBOutlet weak var destinationBankLbl: UILabel!
    
    var destinationType: [String] = ["Wallet", "Bank"]
    var bankType: [String] = ["Standard Chartered Bank", "Barclays Bank", "Republic Bank"]
    
    var ghanaBanks: [BankModel] = [BankModel(bankName_: "Standard Charted Bank", bankCode_: "SCB", bankImage_: ""), BankModel(bankName_: "Ecobank", bankCode_: "EBG", bankImage_: ""), BankModel(bankName_: "CAL Bank", bankCode_: "CAL", bankImage_: ""), BankModel(bankName_: "Ghana Commercial Bank", bankCode_: "GCB", bankImage_: ""), BankModel(bankName_: "National Investment Bank", bankCode_: "NIB", bankImage_: ""), BankModel(bankName_: "Universal Merchant Bank", bankCode_: "UMB", bankImage_: ""), BankModel(bankName_: "Republic Bank", bankCode_: "HFC", bankImage_: ""), BankModel(bankName_: "Agricultural Development Bank", bankCode_: "ADB", bankImage_: ""), BankModel(bankName_: "Barclays Bank", bankCode_: "BBG", bankImage_: ""), BankModel(bankName_: "Zenith Bank", bankCode_: "ZBL", bankImage_: ""), BankModel(bankName_: "Prudential Bank", bankCode_: "PBL", bankImage_: ""), BankModel(bankName_: "Stanbic Bank", bankCode_: "SBG", bankImage_: ""), BankModel(bankName_: "GT Bank", bankCode_: "GTB", bankImage_: ""), BankModel(bankName_: "United Bank of Africa", bankCode_: "UBA", bankImage_: ""), BankModel(bankName_: "First National Bank", bankCode_: "FNB", bankImage_: ""), BankModel(bankName_: "The Royal Bank", bankCode_: "RBG", bankImage_: ""), BankModel(bankName_: "Fidelity Bank", bankCode_: "FBL", bankImage_: ""), BankModel(bankName_: "First Allied Savings and Loans", bankCode_: "FSL", bankImage_: ""), BankModel(bankName_: "Capital Bank", bankCode_: "CAP", bankImage_: ""), BankModel(bankName_: "Energy Bank", bankCode_: "EBL", bankImage_: ""), BankModel(bankName_: "Premium Bank", bankCode_: "", bankImage_: ""), BankModel(bankName_: "Sovereign Bank", bankCode_: "SBL", bankImage_: ""), BankModel(bankName_: "Heritage Bank", bankCode_: "HBG", bankImage_: "")]
    
    var campaignId: String = ""
    var voteId: String = ""
    var groupId: String = ""
    var cashoutDestination: String = ""
    var campaignBalance: String = ""
    var campaignBalances: [GroupBalance] = []
    var destinationBank: String = ""
    var bankSelected: Bool = false
    
    let dropDown = DropDown()
    let destinationTypeDropDown = DropDown()
    let destinationBankDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
        self.destinationTypeDropDown,
        self.destinationBankDropDown
        ]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        self.destinationBankLabel.isHidden = true
        self.selectBankStack.isHidden = true
        self.recipientAccountStack.isHidden = true

    }
    
    func setupDropDowns() {
        setupDestinationTypeDropDown()
        setupDestinationBankDropDown()
    }
    
    func setupDestinationTypeDropDown(){
        destinationTypeDropDown.anchorView = selectDestinationStack
        
        destinationTypeDropDown.bottomOffset = CGPoint(x: 0, y: selectDestinationStack.bounds.height + 10)
        
            destinationTypeDropDown.dataSource = destinationType
        
        //Action triggered on selection
        destinationTypeDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            
            print(self!.destinationType)
            
            self!.cashoutDestination = item
            
            if item == "Wallet"{
                self!.destinationTypeLabel.titleLabel?.text = item
                self!.destinationBankLabel.isHidden = true

                self!.selectBankStack.isHidden = true
                self!.recipientAccountStack.isHidden = true
            }else {
                self!.destinationTypeLabel.titleLabel?.text = item
                self!.destinationBankLabel.isHidden = false
                self!.selectBankStack.isHidden = false
                self!.recipientAccountStack.isHidden = false
            }
            
        }
        self.destinationTypeLabel.width = 200

    }
    
    
    
    func setupDestinationBankDropDown(){
        destinationBankDropDown.anchorView = selectBankStack
        
        destinationBankDropDown.bottomOffset = CGPoint(x: 0, y: selectBankStack.bounds.height + 10)
        
        destinationBankDropDown.dataSource = bankType
        
        destinationBankDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.destinationTypeLabel.titleLabel?.text = item
        }
        
    }
    
    @IBAction func destinationTypeDropDownAction(_ sender: UIButton) {
//        destinationTypeDropDown.show()
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Select payment mode", message: "", preferredStyle: .actionSheet)

        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            print("you cancelled")

        }

        let mobileWallet: UIAlertAction = UIAlertAction(title: "Mobile Wallet", style: .default) { action -> Void in

            self.destinationTypeLbl.text = "Mobile Wallet"
            self.destinationBankLabel.isHidden = true

            self.selectBankStack.isHidden = true
            self.recipientAccountStack.isHidden = true
        }

        let bankAccount: UIAlertAction = UIAlertAction(title: "Bank Account", style: .default) { action -> Void in

            print("chose bank")
            self.destinationTypeLbl.text = "Bank Account"
            self.destinationBankLabel.isHidden = false
            self.selectBankStack.isHidden = false
            self.recipientAccountStack.isHidden = false
            self.cashoutDestination = "Bank"

        }

        actionSheetController.addAction(mobileWallet)
        actionSheetController.addAction(bankAccount)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func destinationBankDropDownActon(_ sender: UIButton) {
//        destinationBankDropDown.show()
        
        let alert = UIAlertController(style: .actionSheet, title: "Select Bank", message: "Preferred bank to cashout to")

        let frameSizes: [BankModel] = ghanaBanks.map { BankModel(bankName_: $0.bankName, bankCode_: $0.bankCode, bankImage_: $0.bankImage) }
        let pickerViewValues: [[String]] = [frameSizes.map { ($0).bankName }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    print("chose: \(frameSizes[index.row].bankName)")
                    self.bankSelected = true
                    self.destinationBankLbl.text = frameSizes[index.row].bankName
                    self.destinationBank = frameSizes[index.row].bankName


                }
            }
        }
        alert.addAction(title: "Done", style: .default) {
            (action: UIAlertAction!) in

            self.destinationBankLbl.text = self.destinationBank

        }

        self.present(alert, animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        if accountNumber.text!.isEmpty && cashoutDestination == "Bank" {
            
            let alert = UIAlertController(title: "Borrow", message: "Please enter recipient account number.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if bankSelected == false && cashoutDestination == "Bank" {
            
            let alert = UIAlertController(title: "Borrow", message: "Please selected preferred bank.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {
        print("destination: \(cashoutDestination)")
        let vc: LoanAmountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "request") as! LoanAmountViewController
        vc.groupId = groupId
        vc.voteId = voteId
        vc.campaignId = campaignId
        vc.cashoutDestination = cashoutDestination
        vc.campaignBalance = campaignBalance
        vc.campaignBalances = campaignBalances
        
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
