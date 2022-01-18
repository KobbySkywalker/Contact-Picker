//
//  SigninViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 19/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView
import Alamofire
import FTIndicator
import FirebaseDatabase

class SigninViewController: UIViewController {

    @IBOutlet weak var phoneNumber: ACFloatingTextfield!
    @IBOutlet weak var password: ACFloatingTextfield!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var phoneCode: UILabel!
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    

    
    let firebaseHelper = FirebaseHelpers()
    
    var country_name: String = ""
    var areaCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countryPicker(tapGestureRecognizer:)))
        self.countryFlag.isUserInteractionEnabled = true
        self.countryFlag.addGestureRecognizer(tapGestureRecognizer)
        
        let x = (self.view.frame.width / 2) - 20
        let y = (self.view.frame.height / 2) - 20
        let frame = CGRect(x: x, y: y, width: 40, height: 40)
        let animationTypeLabel = UILabel(frame: frame)
        animationTypeLabel.sizeToFit()
        animationTypeLabel.textColor = UIColor.white
        animationTypeLabel.frame.origin.y += 20
        animationTypeLabel.text = "Loading..."
        let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.orbit)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()

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
            self.countryFlag.image = UIImage(named: countryCode)
            self.phoneCode.text = countryCode.getCountryPhoneCode()
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
            


        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func dropDownPickder(_ sender: UIButton) {
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
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        FTIndicator.showProgress(withMessage: "logging in")

//        activityIndicatorView.startAnimating()
        
//        self.memberExists()
        
        if ((phoneNumber.text?.isEmpty)! && (password.text?.isEmpty)!) {
            FTIndicator.dismissProgress()
            let alert = UIAlertController(title: "LOGIN", message: "Please fill empty fields.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//                activityIndicatorView.stopAnimating()

            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {

        let finalNumber = checkNumber(number: phoneNumber.text!, countryCode: phoneCode.text!)
        print("final: \(finalNumber)")
        
        firebaseHelper.lookup(phoneNumber: finalNumber) { (user, error) in
            if error != nil {
                //alert
                let alert = UIAlertController(title: "Sign up", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.getVerifyIDToken()
                print(user?.email)
                Auth.auth().signIn(withEmail: (user?.email)!, password: self.password.text!) { (user, error) in
                    FTIndicator.dismissProgress()
                    if error != nil {
                        //alert
//                        activityIndicatorView.stopAnimating()
                        let alert = UIAlertController(title: "Sign up", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }else {
//                        activityIndicatorView.stopAnimating()
                        let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                        


                        self.present(vc, animated: true, completion: nil)
                    }
                    // ...
                }
            }
        }
    }
        }
    

    
    
    //verify id
    func getVerifyIDToken(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print("error: \(error.localizedDescription)")
                return
            }
            print("id token: \(String(describing: idToken))")
            
            let def: UserDefaults = UserDefaults.standard
            def.set(idToken, forKey: "idToken")
            // Send token to your backend via HTTPS
            // ...

        }
    }

}


//verify id
func getVerifyIDToken(){
    let currentUser = Auth.auth().currentUser
    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
        if let error = error {
            // Handle error
            print("error: \(error.localizedDescription)")
            return
        }
        print("id token: \(String(describing: idToken))")
        let def: UserDefaults = UserDefaults.standard
        def.set(idToken, forKey: "idToken")
        
        
        // Send token to your backend via HTTPS
        // ...
    }
}


