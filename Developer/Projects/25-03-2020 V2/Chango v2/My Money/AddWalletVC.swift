//
//  AddMobileWalletVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 15/02/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import Nuke
import FirebaseAuth

class AddWalletVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var walletTypeLabel: UILabel!
    @IBOutlet weak var selectTypeLabel: UILabel!
    @IBOutlet weak var emptyWallet: UIView!
    @IBOutlet weak var emptyWalletLabel: UILabel!

    var countryId: String = ""
    var channel: String = ""
    var walletArray: [RetrieveCountryChannelDestinations] = []
    var walletOption: AddWalletOptions = .wallet
    var fromWalletView: Bool = false
    var user = Auth.auth().currentUser
    let cell = "cellId"
    
    enum AddWalletOptions {
        case wallet
        case bank
    }
    
    var bankOptions: [BankModel] = [BankModel(bankName_: "Standard Charted Bank", bankCode_: "SCB", bankImage_: "stancharticon"), BankModel(bankName_: "Ecobank", bankCode_: "EBG", bankImage_: "ecobankicon"), BankModel(bankName_: "CAL Bank", bankCode_: "CAL", bankImage_: "cal"), BankModel(bankName_: "Ghana Commercial Bank", bankCode_: "GCB", bankImage_: "gcb"), BankModel(bankName_: "National Investment Bank", bankCode_: "NIB", bankImage_: "nib"), BankModel(bankName_: "Universal Merchant Bank", bankCode_: "UMB", bankImage_: "umb"), BankModel(bankName_: "Republic Bank", bankCode_: "HFC", bankImage_: "hfc"), BankModel(bankName_: "Agricultural Development Bank", bankCode_: "ADB", bankImage_: "adb"), BankModel(bankName_: "Absa Bank", bankCode_: "BBG", bankImage_: "absaicon"), BankModel(bankName_: "Zenith Bank", bankCode_: "ZBL", bankImage_: "zbg"), BankModel(bankName_: "Prudential Bank", bankCode_: "PBL", bankImage_: "pbl"), BankModel(bankName_: "Stanbic Bank", bankCode_: "SBG", bankImage_: "sbg"), BankModel(bankName_: "GT Bank", bankCode_: "GTB", bankImage_: "gtb"), BankModel(bankName_: "United Bank of Africa", bankCode_: "UBA", bankImage_: "uba"), BankModel(bankName_: "First National Bank", bankCode_: "FNB", bankImage_: "fnb"), BankModel(bankName_: "Access Bank",bankCode_: "ABN", bankImage_: "accessicon"), BankModel(bankName_: "Fidelity Bank", bankCode_: "FBL", bankImage_: "fbl"), BankModel(bankName_: "First Allied Savings and Loans", bankCode_: "FSL", bankImage_: "fsl"), BankModel(bankName_: "Consolidated Bank", bankCode_: "CBG", bankImage_: "cbg"), BankModel(bankName_: "G-Money", bankCode_: "GMY", bankImage_: "gmy")]
    
    var mobileMoneyOptions: [NetworkModel] = [NetworkModel(networkId_: 1, networkName_: "MTN", networkCode_: "MTN", networkImage_: "mtnicon"), NetworkModel(networkId_: 2, networkName_: "Vodafone", networkCode_: "VODAFONE", networkImage_: "vodafoneicon"), NetworkModel(networkId_: 3, networkName_: "AirtelTigo", networkCode_: "AIRTELTIGO", networkImage_: "airteltigoicon")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "LeftDrawerCell", bundle: nil), forCellReuseIdentifier: "LeftDrawerCell")
        print("\(walletOption)")
        retrieveCountryCode()
        self.tableView.tableFooterView = UIView()
        if walletOption == .wallet {
            walletTypeLabel.text = "Mobile Wallet"
            selectTypeLabel.text = "Select Network"
        }else {
            walletTypeLabel.text = "Bank Wallet"
            selectTypeLabel.text = "Select Bank"
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func retrieveCountryCode() {
        let phone = user?.phoneNumber
        let phoneUtil = NBPhoneNumberUtil()
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: nil)
            countryId = phoneUtil.getRegionCode(for: phoneNumber)
            print("code: \(countryId)")
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let parameter: countryChannelsParameter = countryChannelsParameter(channelId: "\(walletOption)", countryId: countryId)
        retrieveCountryChannelDestinations(countryChannelParameter: parameter)    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if walletOption == .wallet {
//            return mobileMoneyOptions.count
//        }else {
//        return bankOptions.count
//        }
        return walletArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeftDrawerCell = tableView.dequeueReusableCell(withIdentifier: "LeftDrawerCell", for: indexPath) as! LeftDrawerCell
        cell.selectionStyle = .none
        cell.drawerIcon.contentMode = .scaleAspectFit
        cell.drawerIcon.maskToBounds = true
        cell.drawerIcon.cornerRadius = 5
            let wallets: RetrieveCountryChannelDestinations = self.walletArray[indexPath.row]
            
            cell.drawerIcon.image = nil
            cell.drawerIcon.image = UIImage(named: "defaultgroupicon")
            let url = URL(string: wallets.destinationIconPath!)
            if(wallets.destinationIconPath! == "<null>") || (wallets.destinationIconPath == nil) || (wallets.destinationIconPath! == "") {
                cell.drawerIcon.image = UIImage(named: "defaultgroupicon")
            }else {
                Nuke.loadImage(with: url!, into: cell.drawerIcon)
            }
            cell.drawerCellName.text = wallets.destinationName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if walletOption == .wallet {

        let wallets: RetrieveCountryChannelDestinations = self.walletArray[indexPath.row]
        
        let vc: MobileNetworkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobnetwork") as! MobileNetworkVC
            vc.network = wallets.destinationCode!
            vc.networkIcon = wallets.destinationIconPath!
            vc.fromWalletView = false
        self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let bankWallets: RetrieveCountryChannelDestinations = self.walletArray[indexPath.row]
            let vc: BankAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bankaccount") as! BankAccountVC
            vc.bankName = bankWallets.destinationName!
            vc.bankCode = bankWallets.destinationCode!
            vc.bankIcon = bankWallets.destinationIconPath!
            vc.fromWalletView = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func retrieveCountryChannelDestinations(countryChannelParameter: countryChannelsParameter) {
        AuthNetworkManager.retrieveCountryChannelDestinations(parameter: countryChannelParameter) { (result) in
            self.parseRetrieveCountryChannelDestinationsResponse(result: result)
        }
    }
    
    private func parseRetrieveCountryChannelDestinationsResponse(result: DataResponse<[RetrieveCountryChannelDestinations], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            walletArray.append(response)
            if walletArray.isEmpty {
                emptyWallet.isHidden = false
                if walletOption == .wallet {
                    emptyWalletLabel.text = "No wallets available for current region"
                }else {
                    emptyWalletLabel.text = "No banks available for current region"
                }
            }else {
                emptyWallet.isHidden = true
            }
            tableView.reloadData()
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
