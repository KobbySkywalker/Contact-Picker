//
//  MemberActivityViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Nuke

class MemberActivityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var memberActivities: [UserActivity] = []
    let cell = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()

        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "MemberActivityCell", bundle: nil), forCellReuseIdentifier: "MemberActivityCell")
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "Recent Activities"
        
        if memberActivities.count > 0 {
            emptyView.isHidden = true
        }else {
            emptyView.isHidden = false
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
                self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    @IBAction func navigationDrawer(_ sender: UIBarButtonItem) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})

    }
    
    // EASY SLIDE
    
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: MemberActivityCell = self.tableView.dequeueReusableCell(withIdentifier: "MemberActivityCell", for: indexPath) as! MemberActivityCell
        cell.selectionStyle = .none
        
        let activity: UserActivity = self.memberActivities[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date = formatter.date(from: activity.created)
        
        
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        _ = formatter.string(from: date as! Date)
        
        cell.notificationMessage.text = "You \(activity.message)"
        cell.notificationName.text = activity.action
        cell.notificationDate.text = timeAgoSinceDate(date!)
        cell.notificationImage.image = nil
        cell.notificationImage.image = UIImage(named: "defaulticon")
        if (activity.groupIconPath == nil) || (activity.groupIconPath == ""){
            cell.notificationImage.image = UIImage(named: "defaulticon")
        }else {
            Nuke.loadImage(with: URL(string: activity.groupIconPath!)!, into: cell.notificationImage)
        }
        
        return cell
    }

}
