//
//  PrivacyPolicyViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 15/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class PrivacyPolicyViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var privacyPolicy: WKWebView!
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var menuIcon: UIButton!
    
    var checkNavigation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
//        if let url = URL(string: "https://itconsortiumgh.com/genpay/privacy-policy/") {
//            let request = URLRequest(url: url)
//            privacyPolicy.load(request)
//        }
        
        
        //        if let url = Bundle.main.url(forResource: "FAQs", withExtension: "html"){// 1st step
        //                faqsView.loadFileURL(url, allowingReadAccessTo: url)
        //
        //                let request = URLRequest(url: url as URL) // 2nd step
        //                faqsView.load(request)
        //                self.view.addSubview(self.faqsView) // 3rd step
        //        }
        
//        let url: URL! = URL(string: "Terms&Conditions-Chango.pdf")
//        privacyPolicy.load(URLRequest(url: url))
        
            // Add PDFView to view controller.
//            let pdfView = PDFView(frame: self.view.bounds)
//            self.view.addSubview(pdfView)

            // Fit content in PDFView.
            pdfView.autoScales = true

            // Load Sample.pdf file.
            let fileURL = Bundle.main.url(forResource: "Terms&Conditions-Chango", withExtension: "pdf")
            pdfView.document = PDFDocument(url: fileURL!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkNavigation == 2 {
            menuIcon.setImage(UIImage(named: "menu"), for: .normal)
        }
    }
    
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }

    @IBAction func backButtonAction(_ sender: Any) {
        if checkNavigation == 1 {
            self.dismiss(animated: true, completion: nil)
        }else if checkNavigation == 2 {
            self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
        }else {
        self.navigationController?.popViewController(animated: true)
        }
    }
    

}
