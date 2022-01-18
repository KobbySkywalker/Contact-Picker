//
//  WalletOptionsVC.swift
//  
//
//  Created by Hosny Ben Savage on 23/03/2020.
//

import UIKit

class WalletOptionsVC: BaseViewController {


    
    let walletOpitons: [String] = [/*"MTN Mobile Money", "Vodafone Cash",*/ "Mobile Wallet", "Card", "Bank Account"]
    var ghanaBanks: [BankModel] = [BankModel(bankName_: "Standard Charted Bank", bankCode_: "SCB", bankImage_: ""), BankModel(bankName_: "Ecobank", bankCode_: "EBG", bankImage_: "ecobankicon"), BankModel(bankName_: "CAL Bank", bankCode_: "CAL", bankImage_: ""), BankModel(bankName_: "Ghana Commercial Bank", bankCode_: "GCB", bankImage_: ""), BankModel(bankName_: "National Investment Bank", bankCode_: "NIB", bankImage_: ""), BankModel(bankName_: "Universal Merchant Bank", bankCode_: "UMB", bankImage_: ""), BankModel(bankName_: "Republic Bank", bankCode_: "HFC", bankImage_: ""), BankModel(bankName_: "Agricultural Development Bank", bankCode_: "ADB", bankImage_: ""), BankModel(bankName_: "Barclays Bank", bankCode_: "BBG", bankImage_: ""), BankModel(bankName_: "Zenith Bank", bankCode_: "ZBL", bankImage_: ""), BankModel(bankName_: "Prudential Bank", bankCode_: "PBL", bankImage_: ""), BankModel(bankName_: "Stanbic Bank", bankCode_: "SBG", bankImage_: ""), BankModel(bankName_: "GT Bank", bankCode_: "GTB", bankImage_: ""), BankModel(bankName_: "United Bank of Africa", bankCode_: "UBA", bankImage_: ""), BankModel(bankName_: "First National Bank", bankCode_: "FNB", bankImage_: ""), BankModel(bankName_: "The Royal Bank", bankCode_: "RBG", bankImage_: ""), BankModel(bankName_: "Fidelity Bank", bankCode_: "FBL", bankImage_: ""), BankModel(bankName_: "First Allied Savings and Loans", bankCode_: "FSL", bankImage_: ""), BankModel(bankName_: "Capital Bank", bankCode_: "CAP", bankImage_: ""), BankModel(bankName_: "Energy Bank", bankCode_: "EBL", bankImage_: ""), BankModel(bankName_: "Premium Bank", bankCode_: "", bankImage_: ""), BankModel(bankName_: "Sovereign Bank", bankCode_: "SBL", bankImage_: ""), BankModel(bankName_: "Heritage Bank", bankCode_: "HBG", bankImage_: ""), BankModel(bankName_: "G-Money", bankCode_: "GMY", bankImage_: "")]
        
    
    var mobileMoneyOptions: [NetworkModel] = [NetworkModel(networkId_: 1, networkName_: "MTN", networkCode_: "MTN", networkImage_: "mtnicon"), NetworkModel(networkId_: 2, networkName_: "Vodafone", networkCode_: "VODAFONE", networkImage_: "vodafoneicon"), NetworkModel(networkId_: 3, networkName_: "AirtelTigo", networkCode_: "AIRTELTIGO", networkImage_: "airteltigoicon")]
    var network: String = ""
    var selectedBank: String = "Standard Charted Bank"
    var fromWalletView: Bool = false
    var contributeParameters: ContributeParameters!
    let cell = "UITableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mobileWalletButtonAction(_ sender: Any) {
//        selectNetwork()
        let vc: AddWalletVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addwallet") as! AddWalletVC
        vc.walletOption = .wallet
        vc.fromWalletView = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cardButtonAction(_ sender: Any) {
        let vc: CardUploadOptionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardupload") as! CardUploadOptionsVC
        vc.fromWalletView = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bankAccountButtonAction(_ sender: Any) {
        let vc: AddWalletVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addwallet") as! AddWalletVC
        vc.walletOption = .bank
        vc.fromWalletView = false
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func selectNetwork() {
            var alert = UIAlertController(title: "Choose Network", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            switch UIDevice.current.screenType {
            case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Network", message: "", preferredStyle: .actionSheet)
            
            let vc: MobileNetworkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobnetwork") as! MobileNetworkVC
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")

            }
            
            let mtn: UIAlertAction = UIAlertAction(title: "MTN", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.network = "MTN"
                vc.network = self.network
                self.present(vc, animated: true, completion: nil)

            }
            
            let vodafone: UIAlertAction = UIAlertAction(title: "Vodafone", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.network = "Vodafone"
                vc.network = self.network
                self.present(vc, animated: true, completion: nil)

            }
            
            let airtelTigo: UIAlertAction = UIAlertAction(title: "AirtelTigo", style: .default) { action -> Void in
                print("you just chose perpetual")
                //display perpetual in button
                self.network = "AirtelTigo"
                vc.network = self.network
                self.present(vc, animated: true, completion: nil)
            }
            
            actionSheetController.addAction(mtn)
            actionSheetController.addAction(vodafone)
            actionSheetController.addAction(airtelTigo)
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
                
                break
                default:
                    alert = UIAlertController(title: "Choose Network", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                let vc: MobileNetworkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobnetwork") as! MobileNetworkVC
                
                //Create and add the "Cancel" action
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    //Just dismiss the action sheet
                    print("you cancelled")
                    
                }
                
                let mtn: UIAlertAction = UIAlertAction(title: "MTN", style: .default) { action -> Void in
                    print("you just chose perpetual")
                    //display perpetual in button
                    self.network = "MTN"
                    vc.network = self.network
                    self.present(vc, animated: true, completion: nil)
                }
                
                let vodafone: UIAlertAction = UIAlertAction(title: "Vodafone", style: .default) { action -> Void in
                    print("you just chose perpetual")
                    //display perpetual in button
                    self.network = "Vodafone"
                    vc.network = self.network
                    self.present(vc, animated: true, completion: nil)
                }
                
                let airtelTigo: UIAlertAction = UIAlertAction(title: "AirtelTigo", style: .default) { action -> Void in
                    print("you just chose perpetual")
                    //display perpetual in button
                    self.network = "AirtelTigo"
                    vc.network = self.network
                    self.present(vc, animated: true, completion: nil)
                }
                
                alert.addAction(mtn)
                alert.addAction(vodafone)
                alert.addAction(airtelTigo)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    

}
