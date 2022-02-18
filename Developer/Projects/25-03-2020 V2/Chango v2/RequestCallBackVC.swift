//
//  RequestCallBackVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 22/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import FTIndicator
import PhoneNumberKit
import Sodium

class RequestCallBackVC: BaseViewController {

    @IBOutlet weak var phoneNumberTextField: ACFloatingTextfield!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var dropDownButton: UIButton!

    let phoneNumberKit = PhoneNumberKit()
    var loginCheck: Int = 0
    var countryName: String = ""
    var areaCode: String = ""
    var phoneCode: String = ""
    var phoneNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        showChatController()
        
        if let phoneNumber : String = Auth.auth().currentUser?.phoneNumber {
            phoneNumberTextField.text = phoneNumber
        }else {
            phoneNumberTextField.text = ""
        }

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countryPicker(tapGestureRecognizer:)))
        self.countryFlag.isUserInteractionEnabled = true
        self.countryFlag.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        let currentLocale = Locale.current
        let englishLocale: NSLocale = NSLocale.init(localeIdentifier: "en_US")
        print(englishLocale)

        var theEnglishName: String? = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: currentLocale.identifier)
        if let theEnglishName = theEnglishName {

            countryName = theEnglishName.sliceFrom(start: "(", to: ")")!
            print(countryFlag)

        }
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
//            self.getCountryPhoneCode(countryCode)
            self.countryFlag.image = UIImage(named: countryCode)
//            self.phoneCode.text = countryCode.getCountryPhoneCode()
        }
    }

    @objc func countryPicker(tapGestureRecognizer: UITapGestureRecognizer){
        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: .alert)

        alert.addLocalePicker(type: .phoneCode) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.countryFlag.image = flag
            print((info?.flag)!)
            self.phoneCode = ((info?.phoneCode)!)
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if loginCheck == 0 {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func dropDownButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: .alert)

        alert.addLocalePicker(type: .phoneCode) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.countryFlag.image = flag
            print((info?.flag)!)
            self.phoneCode = ((info?.phoneCode)!)
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBAction func callBackButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "loading")
        if phoneNumberTextField.text != Auth.auth().currentUser?.phoneNumber {

            let enteredNumber = phoneNumberTextField.text!
            if enteredNumber.hasPrefix(phoneCode) {
                phoneNumber = enteredNumber
                print("fin: \(phoneNumber)")
                let parameter: RequestACallbackParameter = RequestACallbackParameter(contactNumber: phoneNumber)
                self.requestACallback(requestACallbackParameter: parameter)
            } else {
                let finalNumber = checkNumber(number: enteredNumber, countryCode: phoneCode)

                do {
                    let phoneNumberBeta = try self.phoneNumberKit.parse(finalNumber)
                    let betaValue = self.phoneNumberKit.format(phoneNumberBeta, toType: .international)
                    print("beta: \(betaValue)")
                    phoneNumber = betaValue.removingWhitespaceAndNewlines()
                } catch {
                    print("wrong number")
                    showAlert(title: "Invalid Phonenumber", message: "The number entered is incorrect. Please check and try again.")
                }
            }
        } else {
            phoneNumber = phoneNumberTextField.text!
            let parameter: RequestACallbackParameter = RequestACallbackParameter(contactNumber: phoneNumber)
            self.requestACallback(requestACallbackParameter: parameter)
        }
        print("\(phoneNumber)")
    }

    
    //REQUEST A CALL BACK
    func requestACallback(requestACallbackParameter: RequestACallbackParameter) {
        AuthNetworkManager.requestACallback(parameter: requestACallbackParameter) { (result) in
            self.parseRequestACallbackResponse(result: result)
        }
    }
    
    private func parseRequestACallbackResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            
            let alert = UIAlertController(title: "Contact Us", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
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
