//
//  AddMobileNumberVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import FTIndicator
import FirebaseDatabase

class AddMobileNumberVC: BaseViewController {
    
    @IBOutlet weak var phoneNumber: ACFloatingTextfield!
    @IBOutlet weak var dropdown: UIButton!
    @IBOutlet weak var phoneCode: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    private var alertStyle: UIAlertController.Style = .alert
    
    typealias FetchUIDCompletionHandler = (_ user: UserObject) -> Void
    
    var email: String = ""
    var password: String = ""
    var country_name: String = ""
    var areaCode: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var userObject: UserObject!
    
    var signupCheck: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        
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
        
        let theEnglishName: String? = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: currentLocale.identifier)
        if let theEnglishName = theEnglishName {
            
            country_name = theEnglishName.sliceFrom(start: "(", to: ")")!
            print(country_name)
            
        }
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
//            self.getCountryPhoneCode(countryCode)
//            countryCode.getCountryPhoneCode()
            self.countryFlag.image = UIImage(named: countryCode)
            self.phoneCode.text = countryCode.getCountryPhoneCode()
            self.areaCode = countryCode
            print(areaCode)
        }
        
    }
    
    
    
    
    //NETWORK CODE
    var chosenItem: NetworkCode!
    
    func networkAlertDisplay(networkCode: [NetworkCode]) {
        
        
        Log("start --- ")
        let alert = UIAlertController(title: "Sign", message: "Please select preferred network code", preferredStyle: .actionSheet)
        
        for item in networkCode {
            
            alert.addAction(title: item.name, style: .default, handler: {(action) in
                self.chosenItem = item
                
                if self.signupCheck == true {
                    self.nextButtonAction(self.view)
                }
                print("tapped: \(item)")
            })
            
        }
        alert.addAction(title: "Cancel", style: .cancel)
        
        
        self.present(alert, animated: true, completion: nil)
        Log("stop --- ")
    }
    
    
    
    //COUNTRY PICKER
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
        
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//            
//            
//            
//        }
//        
//        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        signupCheck = true
        
        if (phoneNumber.text?.isEmpty)! {
            showAlert(title: "SIGN UP", message: "Please fill phone number field")
        }else {
            let finalNumber = checkNumber(number: self.phoneNumber.text!, countryCode: self.phoneCode.text!)
                print("final: \(finalNumber)")
                FTIndicator.showProgress(withMessage: "verifying")
                    print(self.phoneCode.text!)
                    print(self.phoneCode.text!.getCountryPhoneCode())
                    PhoneAuthProvider.provider().verifyPhoneNumber(finalNumber, uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print("sign up error: \(error.localizedDescription)")
                            self.showAlert(title: "Chango", message: "\(error.localizedDescription)")
                            return
                        }
                        // Sign in using the verificationID and the code sent to the user
                        // ...
                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                        print("iiuh: \(verificationID)")
        //                let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
                        let vc: VerifyCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "code") as! VerifyCodeVC
                        vc.mail = self.email
                        vc.password = self.password
                        vc.area = self.areaCode
                        vc.firstName = self.firstName
                        vc.lastName = self.lastName
                        //            vc.networkCode = self.chosenItem.networkCode
                        vc.phone = finalNumber
                        print("items: \(self.areaCode),\(self.email),\(finalNumber)")
                        FTIndicator.dismissProgress()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
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
            
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func getNetworkCodeServer(networkParameter: NetworkCodeParameter) {
        AuthNetworkManager.getNetworkCode(parameter: networkParameter) { (result) in
            self.parseGetNetworkCodeResponse(result: result)
        }
    }
    
    
    
    private func parseGetNetworkCodeResponse(result: DataResponse<[NetworkCode], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            self.networkAlertDisplay(networkCode: response)
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
        
        func fetchUserObject(completionHandler: @escaping FetchUIDCompletionHandler) {
            
            let groupsRef = Database.database().reference().child("users")
            let user = Auth.auth().currentUser
            let uid = groupsRef.child("\((user?.uid)!)")
            print("uid: \(uid)")
            _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if let snapshotValue = snapshot.value as? [String: AnyObject] {
                    
                    var authId = ""
                    if let authProviderId = snapshotValue["authProviderId"] as? String {
                        authId = authProviderId
                    }
                    
                    var mail = ""
                    if let email = snapshotValue["email"] as? String {
                        mail = email
                    }
                    
                    var mmbrId = ""
                    if let memberId = snapshotValue["memberId"] as? String {
                        mmbrId = memberId
                    }
                    
                    var mssdn = ""
                    if let msisdn = snapshotValue["msisdn"] as? String {
                        mssdn = msisdn
                    }
                    
                    var nm = ""
                    if let name = snapshotValue["name"] as? String {
                        nm = name
                    }
                    
                    let users = UserObject(authProviderId_: authId, email_: mail, memberId_: mmbrId, msisdn_: mssdn, name_: nm)
                    
                    self.userObject = users
                    print("info \(users)")
                    completionHandler(users)
                }else {
                    let users = UserObject(authProviderId_: "", email_: "", memberId_: "", msisdn_: "", name_: "")
                    
                    completionHandler(users)
                }
                
            })
        }
    
}

extension String {
    func getCountryPhoneCode() -> String  {
        let countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
        if countryDictionary[self] != nil {
            print(countryDictionary[self]!)
            return "+\(countryDictionary[self]!)"
        }

        else {
            return ""
        }
        
    }
}


