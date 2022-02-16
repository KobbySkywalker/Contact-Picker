//
//  VerifyAccountVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 31/01/2022.
//  Copyright © 2022 IT Consortium. All rights reserved.
//

import UIKit
import Nuke
import LocalAuthentication
import FirebaseAuth
import FTIndicator
import Alamofire

class VerifyAccountVC: BaseViewController {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupProfileImage: UIImageView!
    @IBOutlet weak var verifyAccountDescriptionLabel: UILabel!
    @IBOutlet weak var passwordLabel: ACFloatingTextfield!
    @IBOutlet weak var showPassButton: UIButton!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var verifyAccountLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!

    var groupName: String = ""
    var groupProfile: String = ""
    var cashoutPolicyEdit: Bool = false
    var biometricAuth: Bool = false
    var iconClick = true
    var groupId: String = ""
    var newMinVote: String = ""
    var groupIconPath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if cashoutPolicyEdit {
            activityLabel.text =  "Cashout Policy"
            verifyAccountLabel.text = "Modify Cashout Policy"
            verifyAccountDescriptionLabel.text = "You are attempting to modify \(groupName)'s cashout policy. Kindly enter your passsword so we can verify that it's you"
            groupNameLabel.text = "\(groupName)"
        }
        biometricAuthetication()
        if (groupIconPath == "<null>") || (groupIconPath == ""){
            groupProfileImage.image = UIImage(named: "defaultgroupicon")
            groupProfileImage.contentMode = .scaleAspectFit
        }else {
            groupProfileImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupProfileImage)
        }
    }

    @IBAction func showBtnAction(_ sender: UIButton) {
        if(iconClick == true) {
            if case showPassButton.imageView?.image = UIImage(named: "invisible") {
            }
            sender.setTitle("HIDE", for: .normal)
            passwordLabel.isSecureTextEntry = false
        } else {
            if case showPassButton.imageView?.image = UIImage(named: "eye") {
            }
            sender.setTitle("SHOW", for: .normal)
            passwordLabel.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }

    @IBAction func verifyBtnAction(_ sender: UIButton) {
        reauthenticateCurrentUser(email: "", password: passwordLabel.text!)
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func biometricAuthetication() {
        if UserDefaults.standard.bool(forKey: "touchID"){
            print("touchID")
            //TOUCH ID
            let context = LAContext()
            var error: NSError?
            switch UIDevice.current.screenType {
            case UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax, UIDevice.ScreenType.iPhone_XR_11:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Verify user with Face ID"
                    UserDefaults.standard.set(true, forKey: "touchID")
//                    touchID.imageView?.image = UIImage(named: "faceid2")
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        DispatchQueue.main.async {
                            if success {
                                self.unlockID()
                            } else {
                                // error
                            }
                        }
                    }
                } else {
                    // no biometry
                    UserDefaults.standard.set(false, forKey: "touchID")
                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                break
            default:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Verify user with Touch ID"

                    UserDefaults.standard.set(true, forKey: "touchID")

                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in

                        DispatchQueue.main.async {
                            if success {
                                self.unlockID()
                            } else {
                                // error
                            }
                        }
                    }
                } else {
                    // no biometry
                    UserDefaults.standard.set(false, forKey: "touchID")

                    let alert = UIAlertController(title: "Touch ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in


                    }
                    alert.addAction(okAction)

                    self.present(alert, animated: true, completion: nil)

                }
            }

        }else {
            //
        }
    }

    func unlockID() {
        biometricAuth = true
        guard let pass = UserDefaults.standard.string(forKey: "password") else { return }
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        print("\(pass), \(email)")
        reauthenticateCurrentUser(email: email, password: pass)
    }

    func reauthenticateCurrentUser(email: String, password: String) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        var emailValue = ""
        if !biometricAuth {
            emailValue = userEmail
        }else {
            emailValue = email
        }
        FTIndicator.init()
        FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
        FTIndicator.showProgress(withMessage: "verifying", userInteractionEnable: false)
        //Firebase Auth
        Auth.auth().signIn(withEmail: userEmail, password: password) { (user, error) in
            if error != nil {
                FTIndicator.dismissProgress()
                self.showAlert(withTitle: "User Verification", message: "Invalid credentials")
                print(error?.localizedDescription)
            } else {
                //initiate cashout policy edit
                print("initiate")
                let cashoutPolicy: BallotDetail = BallotDetail(ballotId: "changepolicy", minVote: self.newMinVote)
                let parameter: CashoutPolicyChangeParameter = CashoutPolicyChangeParameter(ballotDetail: cashoutPolicy, groupId: self.groupId)
                self.initiateCashoutPolicyChange(cashoutPolicyChange: parameter)
            }
        }
    }

    func initiateCashoutPolicyChange(cashoutPolicyChange: CashoutPolicyChangeParameter) {
        AuthNetworkManager.initiateCashoutPolicyChange(parameter: cashoutPolicyChange) { (result) in
            self.parseInitiateCashoutPolicyChange(result: result)
        }
    }


    private func parseInitiateCashoutPolicyChange(result: DataResponse<InitiateLoanWithWalletResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PrivateGroupDashboardVC.self){
                        self.navigationController?.popToViewController(controller, animated: true)
                    }
                }
            }

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
            break
        case .failure:
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
