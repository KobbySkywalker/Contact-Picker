//
//  PublicGroupContactsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Nuke
import MessageUI
import FirebaseAuth

class PublicGroupContactsViewController: BaseViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var contactNumber: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var emailAddress: UIButton!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    
    
    var publicGroup: GroupResponse!
    var publicContact: [PublicContact] = []
    var groupNamed: String = ""
    var groupImage: String = ""
    var phoneNumber: String = ""
    var mail: String = ""
    var location: String = ""
    var groupDescription: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        print("\(phoneNumber), \(mail)")
        groupName.text = groupNamed
        contactNumber.setTitle(phoneNumber, for: .normal)
        emailAddress.setTitle(mail, for: .normal)
        groupDescriptionLabel.text = groupDescription
        
        if location == "" {
            address.isHidden = true
        }else {
            address.text = location
            address.isHidden = false
        }

        if (groupImage == "<null>") || (groupImage == ""){
            groupIcon.image = UIImage(named: "defaultgroupicon")
            groupIcon.contentMode = .scaleAspectFit
            
        }else {
            groupIcon.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupImage)!, into: groupIcon)
        }
        
    }
    @IBAction func publicGroupNumberButton(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func publicGroupEmailButton(_ sender: UIButton) {
        let email = mail
        if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([email])
        mail.setSubject("\(groupNamed) on Chango")
            mail.setMessageBody("Name: <br> Email: \((Auth.auth().currentUser?.email)!) <br> Issue: ", isHTML: true)
        present(mail, animated: true)
        }else if let emailUrl = createEmailUrl(to: email, subject: "\(groupNamed) on Chango", body: "<br> Name: \((Auth.auth().currentUser?.displayName)!) <br> Email: \((Auth.auth().currentUser?.email)!) <br> Issue: ") {
            UIApplication.shared.open(emailUrl)
        }
    }
    
        private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

            let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
            let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

            if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                return gmailUrl
            } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                return outlookUrl
            } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                return yahooMail
            } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                return sparkUrl
            }

            return defaultUrl
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendFeedbackBtn(_ sender: UIButton) {
        let vc: FeebackViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedback") as! FeebackViewController
        vc.campaignId = publicGroup.defaultCampaignId ?? ""
        vc.publicGroup = publicGroup
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
