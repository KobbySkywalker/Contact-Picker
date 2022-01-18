//
//  FAQsVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 20/03/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import WebKit

class FAQsVC: BaseViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, FZAccordionTableViewDelegate {

    @IBOutlet weak var faqsView: WKWebView!
    @IBOutlet weak var tableView: FZAccordionTableView!
    
    let cellReuseIdentifier = "MyCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"
    
    var fAQArray: [FAQsModel] = [
        FAQsModel(id_: 1, itemName_: "About Chango?", itemDescription_: "Chango is a crowdfunding platform that enables anyone to create groups and contribute towards a predetermined campaign. \n\nCampaigns can be added to allow users to Contribute, Cashout, and Borrow from the groups. Chango can be used in any country, however, Cashout can only be made in Ghana and Kenya currently. \n\nChango is developed by IT Consortium and the company is ISO/IEC 27001:2013 and PCI DSS certified."),
        FAQsModel(id_: 2, itemName_: "How does it work?", itemDescription_: "Chango leverages the financial platforms of banks to aggregate contributions in a secure account and provide a shared and transparent means of disbursing the funds."),
        FAQsModel(id_: 3, itemName_: "What are Private Groups", itemDescription_: "Private groups are groups created by any member of Chango. These groups are self created and managed."),
        FAQsModel(id_: 4, itemName_: "What are Public Groups", itemDescription_: "Public groups are groups created by a corporate institution that is duly registered and has a registered bank account in a commercial bank. The target is mainly governmental or non-governmental organisations"),
        FAQsModel(id_: 5, itemName_: "Does it cost anything to use Chango?", itemDescription_: "There is no cost for using Chango or having funds in a group. However, regular charges through your cell phone carrier or card issuer may apply."),
        FAQsModel(id_: 6, itemName_: "What payment methods can I use to contribute on Chango?", itemDescription_: "Chango supports Mobile Money and Card Payments and bank accounts where available."),
        FAQsModel(id_: 7, itemName_: "How safe is the money I contribute?", itemDescription_: "Money contributed to a group is kept secured by a bank."),
        FAQsModel(id_: 8, itemName_: "Or where is the money I contribute kept?", itemDescription_: "In a bank"),
        FAQsModel(id_: 9, itemName_: "How do I repay money I had borrowed?", itemDescription_: "You repay borrowed funds by contributing to the group or campaign you borrowed from."),
        FAQsModel(id_: 10, itemName_: "How can i get my money off or cash my money from Chango?", itemDescription_: "Users can withdraw or cashout their funds into a specified Mobile Money wallet or Bank account"),
        FAQsModel(id_: 11, itemName_: "How secure is the Chango app?", itemDescription_: "This service employs the 128-bit Secure Socket Layer (SSL), which is one of the strongest encryption technologies most commonly used by large-scale online merchants, banks, and brokerages worldwide. All online sessions are protected by up to 128-bit encryption, which best protects your information against disclosure to third parties."),
        FAQsModel(id_: 12, itemName_: "Is Chango a deposit taking app?", itemDescription_: "No. Chango is an App which helps users to contribute in a group and cashout the money for an intended use."),
        FAQsModel(id_: 13, itemName_: "Will the app support offline mode?", itemDescription_: "All features of Chango App require an internet connection to function."),
        FAQsModel(id_: 14, itemName_: "How do I get Chango?", itemDescription_: "For iOS, you can download directly from the AppStore (or use the link on the Chango Website).")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "FAQs"
        showChatController()
        disableDarkMode()
        
//        if let url = Bundle.main.url(forResource: "FAQs", withExtension: "html"){// 1st step
//                faqsView.loadFileURL(url, allowingReadAccessTo: url)
//
//                let request = URLRequest(url: url as URL) // 2nd step
//                faqsView.load(request)
//                self.view.addSubview(self.faqsView) // 3rd step
//        }
        
        tableView.allowMultipleSectionsOpen = true
        
        
        tableView.register(UINib(nibName: "FAQsHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: FAQsHeaderCell.kAccordionHeaderViewReuseIdentifier)
        
        tableView.register(UINib(nibName: "FAQsCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
                
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
    
    @IBAction func faqsButtonAction(_ sender: Any) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    @IBAction func slideMenu(_ sender: UIBarButtonItem) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return fAQArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch fAQArray[indexPath.section].id {
        case 1:
            return 180.0
        case 2,4,5:
            return 98.0
        case 11:
            return 120.0
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return FAQsHeaderCell.kDefaultAccordionHeaderViewHeight

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FAQsCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FAQsCell
        cell.faqDetails.text = fAQArray[indexPath.section].itemDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: FAQsHeaderCell.kAccordionHeaderViewReuseIdentifier) as! FAQsHeaderCell
        sectionHeader.faqsTitle.text = fAQArray[section].itemName
        return sectionHeader
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
}
