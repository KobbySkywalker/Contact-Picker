//
//  CashoutOtherVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 28/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import PhoneNumberKit
import EPContactsPicker

class CashoutOtherVC: BaseViewController, EPPickerDelegate {

    //Wallet
    @IBOutlet weak var bankAccountNumber: ACFloatingTextfield!
    @IBOutlet weak var bankSelectedName: UIButton!
    @IBOutlet weak var networkSelectedName: UIButton!
    @IBOutlet weak var bankStackView: UIStackView!
    @IBOutlet weak var walletStackView: UIStackView!
    @IBOutlet weak var selectContactButton: UIButton!
    @IBOutlet weak var mobileMoneyTextField: ACFloatingTextfield!
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var walletImage: UIImageView!
    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var bankImageView: UIImageView!
    @IBOutlet weak var bankRedIcon: UIImageView!
    @IBOutlet weak var walletRedIcon: UIImageView!
    //Bank Account

    @IBOutlet weak var bContinueButton: UIButton!
    
    var ghanaBanks: [BankModel] = [BankModel(bankName_: "Standard Charted Bank", bankCode_: "SCB", bankImage_: "stancharticon"), BankModel(bankName_: "Ecobank", bankCode_: "EBG", bankImage_: "ecobankicon"), BankModel(bankName_: "CAL Bank", bankCode_: "CAL", bankImage_: ""), BankModel(bankName_: "Ghana Commercial Bank", bankCode_: "GCB", bankImage_: ""), BankModel(bankName_: "National Investment Bank", bankCode_: "NIB", bankImage_: ""), BankModel(bankName_: "Universal Merchant Bank", bankCode_: "UMB", bankImage_: ""), BankModel(bankName_: "Republic Bank", bankCode_: "HFC", bankImage_: ""), BankModel(bankName_: "Agricultural Development Bank", bankCode_: "ADB", bankImage_: ""), BankModel(bankName_: "ABSA Bank", bankCode_: "BBG", bankImage_: ""), BankModel(bankName_: "Zenith Bank", bankCode_: "ZBL", bankImage_: ""), BankModel(bankName_: "Prudential Bank", bankCode_: "PBL", bankImage_: ""), BankModel(bankName_: "Stanbic Bank", bankCode_: "SBG", bankImage_: ""), BankModel(bankName_: "GT Bank", bankCode_: "GTB", bankImage_: ""), BankModel(bankName_: "United Bank of Africa", bankCode_: "UBA", bankImage_: ""), BankModel(bankName_: "First National Bank", bankCode_: "FNB", bankImage_: ""), BankModel(bankName_: "Access Bank", bankCode_: "ABN", bankImage_: "accessicon"), BankModel(bankName_: "Fidelity Bank", bankCode_: "FBL", bankImage_: ""), BankModel(bankName_: "Consolidated Bank", bankCode_: "CBG", bankImage_: ""), BankModel(bankName_: "Bank of Afica", bankCode_: "BOA", bankImage_: ""), BankModel(bankName_: "First Bank of Nigeria ", bankCode_: "FBN", bankImage_: ""), BankModel(bankName_: "First Allied Savings & Loans", bankCode_: "FSL", bankImage_: ""), BankModel(bankName_: "Bank of Baroda", bankCode_: "BOB", bankImage_: ""), BankModel(bankName_: "ARB Apex Bank Limited", bankCode_: "ARB", bankImage_: ""), BankModel(bankName_: "GHL Bank", bankCode_: "GHL", bankImage_: ""), BankModel(bankName_: "First Atlantic Bank", bankCode_: "FAB", bankImage_: ""), BankModel(bankName_: "Bank of Ghana", bankCode_: "BOG", bankImage_: ""), BankModel(bankName_: " Sahel Sahara Bank (BSIC)", bankCode_: "SSB", bankImage_: ""), BankModel(bankName_: "G-Money", bankCode_: "GMY", bankImage_: "")]
    
    var reason: String = ""
    var amount: String = ""
    var groupId: String = ""
    var campaignId: String = ""
    var voteId: String = ""
    var paymentOption: String = ""
    var network: String = ""
    var selectedBank: String = ""
    var bankCode: String = ""
    var bankSelected: Bool = false
    var countryId: String = ""
    var msisdn = ""
    var mapped: [String] = []
    var phoneNumber: String = ""

    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()

        self.title = "Cashout"
        
        bankSelectedName.titleLabel?.adjustsFontSizeToFitWidth = true
        networkSelectedName.titleLabel?.adjustsFontSizeToFitWidth = true
        walletRedIcon.isHidden = true
        bankRedIcon.isHidden = true

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func walletOptionSelected(_ sender: UIButton) {
        walletButton.backgroundColor = UIColor(hexString: "#05406F")
        bankButton.backgroundColor = UIColor(hexString: "#228CC7")
        walletRedIcon.isHidden = false
        bankRedIcon.isHidden = true
        paymentOption = "wallet"
        mobileMoneyTextField.isHidden = false
        selectContactButton.isHidden = false
        bankAccountNumber.isHidden = true
        selectLabel.text = "Select Network"
        walletStackView.isHidden = false
        bankStackView.isHidden = true
    }
    
    
    @IBAction func bankOptionSelected(_ sender: UIButton) {
        bankButton.backgroundColor = UIColor(hexString: "#05406F")
        walletButton.backgroundColor = UIColor(hexString: "#228CC7")
        walletRedIcon.isHidden = true
        bankRedIcon.isHidden = false
        paymentOption = "bank"
        mobileMoneyTextField.isHidden = true
        selectContactButton.isHidden = true
        bankAccountNumber.isHidden = false
        selectLabel.text = "Select Bank"
        walletStackView.isHidden = true
        bankStackView.isHidden = false
    }
    
    @IBAction func bankNameButton(_ sender: UIButton) {
                
        switch UIDevice.current.screenType {
            
            
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            
        let alert = UIAlertController(style: .actionSheet, title: "Select Bank", message: "Preferred bank to cashout to")

        let frameSizes: [BankModel] = ghanaBanks.map { BankModel(bankName_: $0.bankName, bankCode_: $0.bankCode, bankImage_: $0.bankImage) }
        let pickerViewValues: [[String]] = [frameSizes.map { ($0).bankName }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    print("chose: \(frameSizes[index.row].bankName)")
                    self.bankSelected = true
                    self.selectedBank = frameSizes[index.row].bankName
                    self.bankCode = frameSizes[index.row].bankCode
                    self.bankSelectedName.setTitle("\(frameSizes[index.row].bankName)", for: .normal)
                    self.bankImageView.image = UIImage(named: "\(frameSizes[index.row].bankImage)")
                }
            }
        }
        alert.addAction(title: "Done", style: .default) {
            (action: UIAlertAction!) in

            self.bankSelectedName.setTitle("\(self.selectedBank)", for: .normal)
        }

        self.present(alert, animated: true)
            
        default:
            
            let alert = UIAlertController(style: .alert, title: "Select Bank", message: "Preferred bank to cashout to")

            let frameSizes: [BankModel] = ghanaBanks.map { BankModel(bankName_: $0.bankName, bankCode_: $0.bankCode, bankImage_: $0.bankImage) }
            let pickerViewValues: [[String]] = [frameSizes.map { ($0).bankName }]
            let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)

            alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1) {
                        print("chose: \(frameSizes[index.row].bankName)")
                        self.bankSelected = true
                        self.selectedBank = frameSizes[index.row].bankName
                        self.bankCode = frameSizes[index.row].bankCode
                        self.bankSelectedName.setTitle("\(frameSizes[index.row].bankName)", for: .normal)
                        self.bankImageView.image = UIImage(named: "\(frameSizes[index.row].bankImage)")
                    }
                }
            }
            alert.addAction(title: "Done", style: .default) {
                (action: UIAlertAction!) in

                self.bankSelectedName.setTitle("\(self.selectedBank)", for: .normal)
            }

            self.present(alert, animated: true)
                
        }
        
    }
    
    
    @IBAction func bankBranchButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func selectNetwork(_ sender: Any) {
        var alert = UIAlertController(title: "Choose Network", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Network", message: "", preferredStyle: .actionSheet)
        
        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            print("you cancelled")

        }
        
        let mtn: UIAlertAction = UIAlertAction(title: "MTN", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.network = "MTN"
            self.networkSelectedName.setTitle("MTN", for: .normal)
            self.walletImage.image = UIImage(named: "mtnicon")
        }
        
        let vodafone: UIAlertAction = UIAlertAction(title: "Vodafone", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.network = "VODAFONE"
            self.networkSelectedName.setTitle("Vodafone", for: .normal)
            self.walletImage.image = UIImage(named: "vodafoneicon")
        }
        
        let airtelTigo: UIAlertAction = UIAlertAction(title: "AirtelTigo", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.network = "ARTLTIGO"
            self.networkSelectedName.setTitle("AirtelTigo", for: .normal)
            self.walletImage.image = UIImage(named: "airteltigoicon")
        }
        
        let tigo: UIAlertAction = UIAlertAction(title: "TIGO", style: .default) { action -> Void in
            print("you just chose perpetual")
            //display perpetual in button
            self.network = "TIGO"
            self.networkSelectedName.setTitle("TIGO", for: .normal)
            self.walletImage.image = UIImage(named: "")
            
        }
        
        actionSheetController.addAction(mtn)
        actionSheetController.addAction(vodafone)
        actionSheetController.addAction(airtelTigo)
//        actionSheetController.addAction(tigo)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
            
            break
            default:
                alert = UIAlertController(title: "Choose Network", message: "", preferredStyle: UIAlertController.Style.alert)
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
                
            }
            
            let mtn: UIAlertAction = UIAlertAction(title: "MTN", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.network = "MTN"
                self.networkSelectedName.setTitle("MTN", for: .normal)
                self.walletImage.image = UIImage(named: "mtnicon")
            }
            
            let vodafone: UIAlertAction = UIAlertAction(title: "Vodafone", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.network = "VODAFONE"
                self.networkSelectedName.setTitle("Vodafone", for: .normal)
                self.walletImage.image = UIImage(named: "vodafoneicon")
            }
            
            let airtelTigo: UIAlertAction = UIAlertAction(title: "AirtelTigo", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.network = "ARTLTIGO"
                self.networkSelectedName.setTitle("AirtelTigo", for: .normal)
                self.walletImage.image = UIImage(named: "airteltigoicon")
            }
            
            let tigo: UIAlertAction = UIAlertAction(title: "TIGO", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.network = "TIGO"
                self.networkSelectedName.setTitle("TIGO", for: .normal)
                self.walletImage.image = UIImage(named: "")
            }
            
            alert.addAction(mtn)
            alert.addAction(vodafone)
            alert.addAction(airtelTigo)
//            alert.addAction(tigo)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectContactButtonAction(_ sender: UIButton) {
        let contactPickerScene = EPContactsPicker(delegate: self , multiSelection: false, subtitleCellType: SubtitleCellValue.phoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error: NSError){
        
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact){
        
        for item in contact.phoneNumbers {
            let phones = contact.phoneNumbers
            if phones.count > 1 {
                switch UIDevice.current.screenType {
                
                
                case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
                    
                    let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .actionSheet)
                    
                    for item in phones {
                        
                        alert.addAction(title: item.phoneNumber, style: .default, handler: {(action) in
                            
                            var numbers = item.phoneNumber
                            
                            let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                            let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                            let phi: String = gama.replacingOccurrences(of: ")", with: "")
                            let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                            let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                            print(numbers)
                            print(alpha)
                            print(beta)
                            
                            print("selected number: \(beta)")
                            self.mobileMoneyTextField.text = beta
                            self.phoneNumber = beta
                            
                        })
                        
                    }
                    
                    alert.addAction(title: "Cancel", style: .cancel)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                default:
                    
                    var phoneNumb: [String] = []
                    for item in phones {
                        
                        phoneNumb.append(item.phoneNumber)
                    }
                    
                    let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .alert)
                    
                    for item in phoneNumb {
                        
                        var numbers = item
                        
                        let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                        let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                        let phi: String = gama.replacingOccurrences(of: ")", with: "")
                        let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                        let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                        print(numbers)
                        print(alpha)
                        print(beta)
                        
                        alert.addAction(title: beta, style: .default, handler: {(action) in
                            
                            print("selected number: \(beta)")
                            self.mobileMoneyTextField.text = beta
                            self.phoneNumber = beta
                            
                        })
                        
                    }
                    
                    alert.addAction(title: "Cancel", style: .cancel)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }else {
                
                let numbers = item.phoneNumber
                
                let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                let phi: String = gama.replacingOccurrences(of: ")", with: "")
                let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                print(numbers)
                print(alpha)
                print(beta)
                
                self.mobileMoneyTextField.text = beta
                phoneNumber = beta
            }
        }
    }
    
    @IBAction func InitiateCashout(_ sender: UIButton) {
        if (paymentOption == "") {
            showAlert(title: "Cashout", message: "Please select a cashout option.")
        }else if (paymentOption == "bank") && (bankSelected == false) {
            print("bool: \(bankSelected)")
            
            let alert = UIAlertController(title: "Cashout", message: "Please select preferred bank before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if paymentOption == "wallet" && (mobileMoneyTextField.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Cashout", message: "Please fill both Name and Mobile Wallet fields.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if (paymentOption == "wallet") && (networkSelectedName.titleLabel?.text == "Select Network") {
            print("bool: \(bankSelected)")
            
            let alert = UIAlertController(title: "Cashout", message: "Please select preferred mobile network before you can proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            

            if paymentOption == "wallet" {
                phoneNumber = mobileMoneyTextField.text!
//                print("nnum: \(mobileMoneyTextField.text!)")
                do {
                    let phoneNumbersCustomDefaultRegion = try phoneNumberKit.parse(phoneNumber, withRegion: countryId,  ignoreType: true)
                    msisdn = phoneNumberKit.format(phoneNumbersCustomDefaultRegion, toType: .e164)
                    msisdn.removeFirst()
                    print("results: \(msisdn)")
                }catch {
                    print("error")
                }
                let parameter: GetNameRegisteredOnWalletParameter = GetNameRegisteredOnWalletParameter(channelId: "wallet", msisdn: msisdn, network: network, countryId: countryId)
                getNameRegisteredOnMobileWallet(getNameRegisteredOnMobileWalletParameter: parameter)
            }else {
                let parameter: GetNameRegisteredOnWalletParameter = GetNameRegisteredOnWalletParameter(channelId: "bank", msisdn: bankAccountNumber.text!, network: bankCode, countryId: countryId)
                    getNameRegisteredOnMobileWallet(getNameRegisteredOnMobileWalletParameter: parameter)
            }
        }
    }
    
    func getNameRegisteredOnMobileWallet(getNameRegisteredOnMobileWalletParameter: GetNameRegisteredOnWalletParameter) {
        AuthNetworkManager.getNameRegisteredOnMobileWallet(parameter: getNameRegisteredOnMobileWalletParameter) { (result) in
            self.parseGetNameRegisteredOnMobileWallet(result: result)
        }
    }
    
    private func parseGetNameRegisteredOnMobileWallet(result: DataResponse<GetNameRegisteredOnMobileWalletResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            if response.responseCode == "100" {
                showAlert(title: "Cashout", message: response.responseMessage!)
            }else {
            let vc: CashoutSummaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashoutsummary") as! CashoutSummaryVC
            
            vc.reason = self.reason
            vc.amount = self.amount
            vc.groupId = self.groupId
            vc.campaignId = self.campaignId
            vc.voteId = self.voteId
            vc.recipientNumber = self.mobileMoneyTextField.text!
            vc.recipientName = response.name ?? ""
            if paymentOption == "wallet" {
            vc.recipientNumber = self.msisdn
                print("recipient number: \( self.mobileMoneyTextField.text!)")
                print("account number: \( self.bankAccountNumber.text!)")
                print(self.paymentOption)
            vc.walletRecipientNumber = self.mobileMoneyTextField.text!
                vc.cashoutDestinationCode = network
            }else {
                vc.recipientNumber = bankAccountNumber.text!
                vc.cashoutDestinationCode = bankCode
            }
                print("deets: \(bankAccountNumber)")
            vc.forOther = 1
            vc.network = network
            vc.paymentOption = self.paymentOption
            vc.bankName = selectedBank
                print(bankCode)
            
            self.navigationController?.pushViewController(vc, animated: true)
            }

            break
        case .failure(_):
            FTIndicator.dismissProgress()
            
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
