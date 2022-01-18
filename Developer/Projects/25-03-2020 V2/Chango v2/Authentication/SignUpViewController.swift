//
//  SignUpViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: ACFloatingTextfield!
    @IBOutlet weak var lastName: ACFloatingTextfield!
    @IBOutlet weak var email: ACFloatingTextfield!
    @IBOutlet weak var phoneNumber: ACFloatingTextfield!
    @IBOutlet weak var nationalId: ACFloatingTextfield!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var password: ACFloatingTextfield!
    @IBOutlet weak var confirmPassword: ACFloatingTextfield!
    @IBOutlet weak var phoneCode: UILabel!
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    
    var verify: VerifyCodeViewController!

    var areaCode: String = ""
    
    var country_name: String = ""
    
    var signupCheck: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countryPicker(tapGestureRecognizer:)))
        self.countryFlag.isUserInteractionEnabled = true
        self.countryFlag.addGestureRecognizer(tapGestureRecognizer)
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentLocale = Locale.current
        let englishLocale: NSLocale = NSLocale.init(localeIdentifier: "en_US")
        print(englishLocale)
        
        var theEnglishName: String? = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: currentLocale.identifier)
        if let theEnglishName = theEnglishName {
            
            country_name = theEnglishName.sliceFrom(start: "(", to: ")")!
            print(country_name)
            
        }
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
//            self.getCountryPhoneCode(countryCode)
            self.areaCode = countryCode
            self.countryFlag.image = UIImage(named: countryCode)
            
            self.phoneCode.text = countryCode.getCountryPhoneCode()
            print(phoneCode.text!)
            
            


        }
        
        

        
    }
    
    
    @objc func countryPicker(tapGestureRecognizer: UITapGestureRecognizer){
        
        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: self.alertStyle)
        

        alert.addLocalePicker(type: .country) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.countryFlag.image = flag
            print((info?.flag)!)
            self.phoneCode.text = info?.phoneCode
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

//            let parameter: NetworkParameter = NetworkParameter(countryId: self.areaCode)
//            print(parameter)
//            self.getNetworkCodeServer(networkParameter: parameter)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
//    func getNetworkCodeServer(networkParameter: NetworkParameter) {
//        let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default, completionHandlerQueue: OperationQueue.main)
//        let apiManager = AuthApiManager(apiClient: apiClient)
//        apiManager.getNetworkCode(parameter: networkParameter) { (result) in
//            switch result{
//            case let .success(nameResponse):
//                print(nameResponse)
//
//                self.networkAlertDisplay(networkCode: nameResponse)
//
//                break
//            case .failure(let error):
//                self.handleError(error)
//                break
//            }
//        }
//    }
    
    var chosenItem: NetworkCode!
    
    func networkAlertDisplay(networkCode: [NetworkCode]) {
        
        
        Log("start --- ")
        let alert = UIAlertController(title: "Sign", message: "Please select preferred network code", preferredStyle: .actionSheet)

        for item in networkCode {

            alert.addAction(title: item.name, style: .default, handler: {(action) in
                self.chosenItem = item

                if self.signupCheck == true {
                    self.signUpButtonAction(self.view)
                }
                print("tapped: \(item)")
            })
            
        }
        alert.addAction(title: "Cancel", style: .cancel)


        self.present(alert, animated: true, completion: nil)
        Log("stop --- ")
    }
    
    @IBAction func dropDownPicker(_ sender: UIButton) {


        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: self.alertStyle)
        
        
        alert.addLocalePicker(type: .country) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.countryFlag.image = flag
            print((info?.flag)!)
            self.phoneCode.text = info?.phoneCode
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            
//            let parameter: NetworkParameter = NetworkParameter(countryId: self.areaCode)
//            print(parameter)
//            self.getNetworkCodeServer(networkParameter: parameter)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    


    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else {
            return false }

        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")

        print(passwordTest.evaluate(with: testStr))
        return passwordTest.evaluate(with: testStr)
    }
    

    @IBAction func signUpButtonAction(_ sender: Any) {

        signupCheck = true

        if (phoneNumber.text?.isEmpty)! {
            //alert
            let alert = UIAlertController(title: "SIGN UP", message: "Please fill phone number field", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if isValidPassword(testStr: password.text) == false {
            print("false")
         
            
        }else {

            

            
//            if chosenItem == nil {
//                let parameter: NetworkParameter = NetworkParameter(countryId: self.areaCode)
//                print(parameter)
//                getNetworkCodeServer(networkParameter: parameter)
//
//                return
//            }
            
                print(phoneCode.text!)
            let finalNumber = checkNumber(number: phoneNumber.text!, countryCode: phoneCode.text!)
            print("final: \(finalNumber)")
            print(self.phoneCode.text!.getCountryPhoneCode())
            
            PhoneAuthProvider.provider().verifyPhoneNumber(finalNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print("sign up error: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Chango", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                // Sign in using the verificationID and the code sent to the user
                // ...
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                print("iiuh: \(verificationID)")
                
                let vc: VerifyCodeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verify") as! VerifyCodeViewController
                
                vc.phone = self.phoneNumber.text!
                vc.firstName = self.firstName.text!
                vc.lastName = self.lastName.text!
                vc.area = self.areaCode
                let alpha = self.email.text!.removeCharacters(from: CharacterSet.decimalDigits.inverted)
                print("trimmed email: \(alpha)")
                vc.mail = alpha
                vc.password = self.password.text!
                vc.language = self.areaCode
                vc.networkCode = self.chosenItem.networkCode

                self.present(vc, animated: true, completion: nil)

            }
        }
        
        

    }
    
}

func checkNumber(number: String, countryCode: String) -> String {
    var phone = number
    print(number)
    var myPhone = ""
    let index1 = phone.index(phone.startIndex, offsetBy: 1)
    let firstNumber = phone.substring(to: index1)
    
    if (firstNumber == "0") {
       let removeZero = phone.dropFirst()
        print(removeZero)
        myPhone = String(removeZero)
        
    }else{
       myPhone = phone
    }
    
    print("number: \(countryCode)\(myPhone)")
    return countryCode + myPhone
}





