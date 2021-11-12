//
//  SettingsVC.swift
//  Dardesh
//
//  Created by abdurhman elbosaty on 19/08/2021.
//

import UIKit
import ProgressHUD

class SettingsVC: UITableViewController {

    //MARK:- Outlets

    @IBOutlet weak var userProfileImgOutlet: UIImageView!{
        didSet{
            userProfileImgOutlet.layer.cornerRadius = userProfileImgOutlet.frame.height / 2
        }
    }
    @IBOutlet weak var userNameOutlet: UILabel!
    @IBOutlet weak var userStatusOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        retriveUserData()
        
    }
    //MARK:- IBActions

    @IBAction func tellAFriendBtnPressed(_ sender: UIButton) {
    }
    @IBAction func termsAndConditionsBtnPressed(_ sender: UIButton) {
    }
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        logoutFromApp()
    }
    
    //MARK:- Helper Functions
    
    func setupUI(){
        tableView.tableFooterView = UIView()
    }
    func retriveUserData(){
        if let userData = FUser.currentUser(){
            userNameOutlet.text = userData.fullname
            userStatusOutlet.text = userData.email
            if userData.avatar != ""{
                imageFromStringData(stringImgData: userData.avatar) { image in
                    self.userProfileImgOutlet.image = image
                }
            }
        }
    }
    func logoutFromApp(){

        FirebaseAPI.shared.firebaseLogOut { error in
            if error == nil{
                let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginOrRegisterVC")
                tabBarVC.modalPresentationStyle = .fullScreen
                self.present(tabBarVC, animated: true, completion: nil)
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 25
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let editVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(identifier: "EditSettingsVC") as! EditSettingsVC
            imageFromStringData(stringImgData: FUser.currentUser()!.avatar) { image in
                if image != nil {
                    editVC.profileImg = image
                }
            }
            self.navigationController?.pushViewController(editVC, animated: true)
        }
    }
}

