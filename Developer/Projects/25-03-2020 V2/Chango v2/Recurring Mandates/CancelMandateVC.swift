//
//  CancelMandateVC.swift
//  Alamofire
//
//  Created by Hosny Ben Savage on 06/09/2019.
//

import UIKit
import Alamofire
import FTIndicator

class CancelMandateVC: BaseViewController {

    @IBOutlet weak var mandateNameLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var mandateId: String = ""
    var amount: String = ""
    var mandateName: String = ""
    var duration: String = ""
    var frequencyType: String = ""
    
    let cell = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()

        self.title = "Cancel Mandate"
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
//        self.tableView.register(UINib(nibName: "MandateCell", bundle: nil), forCellReuseIdentifier: "MandateCell")
//        self.tableView.register(UINib(nibName: "RecurringPaymentsVC", bundle: nil), forCellReuseIdentifier: "RecurringPaymentsVC")
//        tableView.tableFooterView = UIView()
        
        frequencyLabel.text = "\(amount) \(frequencyType) for \(duration) days"
        
        
    }
    
    
    @IBAction func cancelMandate(_ sender: UIButton) {
        
        let parameter: CancelSingleMandateParameter = CancelSingleMandateParameter(id: mandateId)
        
        self.cancelMandate(cancelSingleMandateParameter: parameter)
        
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell: MandateCell = self.tableView.dequeueReusableCell(withIdentifier: "MandateCell", for: indexPath) as! MandateCell
//        cell.selectionStyle = .none
//
//        cell.groupName.text = "Group Name Here"
//        cell.amount.text = "GHS Amount"
//        cell.debitDate.text = "20th Debit Date"
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 70.00
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
    //CANCEL ALL
    func cancelMandate(cancelSingleMandateParameter: CancelSingleMandateParameter) {
        AuthNetworkManager.cancelSingleMandate(parameter: cancelSingleMandateParameter) { (result) in
            self.parseCancelSingleMandatesResponse(result: result)
        }
    }
    
    
    private func parseCancelSingleMandatesResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Recurring Payments", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                let vc: GroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groups") as! GroupsViewController
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
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

    


}
