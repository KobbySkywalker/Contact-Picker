//
//  VerifyCodeViewController.swift
//  
//
//  Created by Hosny Ben Savage on 05/11/2018.
//

import UIKit
import KWVerificationCodeView
import FirebaseAuth
import FirebaseDatabase

class VerifyCodeViewController: UIViewController {


    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var verificationView: KWVerificationCodeView!
    
    var phone: String = ""
    var area: String = ""
    var mail: String = ""
    var firstName: String = ""
    var password: String = ""
    var lastName: String = ""
    var language: String = ""
    var networkCode: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        verificationView.delegate = self
        
        submitButton.layer.cornerRadius = 5.0
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view.
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        let verificationCode = "\(verificationView.getVerificationCode())"
        print("\(verificationView.getVerificationCode())")
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                print("verified?: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Chango", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            // User is signed in
            // ...
            //Saving Phone Number to Realtime Database
            let profiles = Database.database().reference().child("users")
            print("auth: \((authResult?.user.uid)!)")
            profiles.child(self.phone).setValue(self.mail)
            
            let credential = EmailAuthProvider.credential(withEmail: self.mail, password: self.password)

            
            authResult?.user.link(with: credential) { (authResult, error) in
                if let error = error {
                    // ...
                    let alert = UIAlertController(title: "Chango", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    print("verified?: \(error.localizedDescription)")
                    return
                }
                self.getVerifyIDToken()
                

                
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
            print(self.mail)
//            let parameter: SignupParameter = SignupParameter( networkCode: self.networkCode, email: self.mail, firstName: self.self.firstName, lastName: self.lastName, msisdn: self.phone, language: "EN", registrationToken: InstanceID.instanceID().token()!)
//            print(parameter)
//            self.signupServer(signupParameter: parameter)
            }
        }
    
    
//    func signupServer(signupParameter: SignupParameter) {
//        let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,completionHandlerQueue: OperationQueue.main)
//        let apiManager = AuthApiManager(apiClient: apiClient)
//        apiManager.signup(parameter: signupParameter) { (result) in
//            switch result{
//            case let .success(registerResponse):
//                print(registerResponse)
//                    let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
//
//                    self.present(vc, animated: true, completion: nil)
//
//                break
//            case .failure(let error):
//                self.handleError(error)
//                break
//            }
//        }
//    }
    
    
    
//    func handleError(_ error:Error){
//        var message = "We encountered an error while connecting. Please try again later"
//        if error is ApiError{
//            print("ApiError")
//            let apiError = error as! ApiError
//            let statusCode = apiError.httpUrlResponse.statusCode
//            print(statusCode)
//            switch statusCode{
//            case 401:
//                message = "Invalid Credentials. Please check and try again"
//                break
//            default:
//                print("Any")
//                do{
//                    if let json = try JSONSerialization.jsonObject(with: apiError.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                        print(json)
//                        message = (json["message"] as? String)!
//                    }
//                }catch {
//                }
//                break
//            }
//        }else if error is ApiParseError{
//            message = "Error. Please try again"
//        }else if error is NetworkRequestError{
//            message = "Please check your connection and try again"
//        }
//        
//        let alert = UIAlertController(title: "Chango", message: message, preferredStyle: .alert)
//        
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//            
//        }
//        
//        alert.addAction(okAction)
//        
//        self.present(alert, animated: true, completion: nil)
//    
//    }
    //Database
//    func saveToDatabase(_ authResult: ){
//        //Saving Phone Number to Realtime Database
//        let profiles = Database.database().reference().child("users")
//        print("auth: \((authResult?.user.uid)!)")
//        let profile = profiles.child((authResult?.user.uid)!)
//
//        profile.observeSingleEvent(of: .value, with: { (snapshot) in
//            let snapshot = snapshot.value as? NSDictionary
//            if (snapshot == nil) {
//                //                    profile.child("\(self.signupController.phoneNumber1)").setValue(self.signupController.phoneNumber1)
//                //                    profile.child("\(self.signupController.areaCode1)").setValue(self.signupController.areaCode1)
//                //                    profile.child("\(self.signupController.firstName1)").setValue(self.signupController.firstName1)
//                //                    profile.child("\(self.signupController.email1)").setValue(self.signupController.email1)
//                //
//            }
//        })
//    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - KWVerificationCodeViewDelegate
extension VerifyCodeViewController: KWVerificationCodeViewDelegate {
    func didChangeVerificationCode() {
        submitButton.isEnabled = verificationView.hasValidCode()
    }
}


