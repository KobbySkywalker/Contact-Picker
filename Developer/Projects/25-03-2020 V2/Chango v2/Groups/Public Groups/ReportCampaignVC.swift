//
//  ReportCampaignVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 09/10/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class ReportCampaignVC: UIViewController, UITextViewDelegate {

//    @IBOutlet weak var campaignReport: TextField!
    @IBOutlet weak var reportHeading: UILabel!
    @IBOutlet weak var campaignReport: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        campaignReport.text = "I suspect this campaign isn't legit"
        campaignReport.textColor = UIColor.lightGray
        campaignReport.delegate = self
        disableDarkMode()
        
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            print("clear your text view")
            textView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "I suspect this campaign isn't legit"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = campaignReport.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // make sure the result is under 16 characters
        return updatedText.count <= 240
    }

}


extension ReportCampaignVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
