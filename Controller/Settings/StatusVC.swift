//
//  StatusVC.swift
//  Dardesh
//
//  Created by abdurhman elbosaty on 21/08/2021.
//

import UIKit
import Firebase
import ProgressHUD

class StatusVC: UITableViewController {
    
    //MARK:- Variables
    
    let status = ["Hey,I'm using this App","Busy","Not Available","Sleeping","At work","Gym time","No one talk to me"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- IBActions
    
    //MARK:- Helper Functions
    func setupUI() {
        tableView.tableFooterView = UIView()
        self.title = "Status"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusCell
            cell.statusLBLOutlet.text = status[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREENHEIGHT / 12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
            let status = status[indexPath.row]
            
            FirebaseAPI.shared.saveUserToDatabase(userId: FUser.currentId(), email: FUser.currentUser()!.email, name: FUser.currentUser()!.fullname, avatar: FUser.currentUser()!.avatar, status: status) { error, dbRef in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess("Status updated")
                self.navigationController?.popViewController(animated: true)
            }

    }
}
