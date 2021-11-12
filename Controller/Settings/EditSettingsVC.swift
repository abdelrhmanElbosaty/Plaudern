//
//  EditSettingsVC.swift
//  Dardesh
//
//  Created by abdurhman elbosaty on 20/08/2021.
//

import UIKit
import Gallery
import ProgressHUD
import Firebase

class EditSettingsVC: UITableViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var userProfileImgOutlet: UIImageView!{
        didSet{
            userProfileImgOutlet.layer.cornerRadius = userProfileImgOutlet.frame.height / 2
        }
    }
    @IBOutlet weak var pageInfoOutlet: UILabel!
    @IBOutlet weak var userNameTFOutlet: UITextField!
    @IBOutlet weak var userStatusOutlet: UILabel!
    
    //MARK:- Variables
    
    var profileImg: UIImage?
    var gallary: GalleryController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        textFieldDelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retriveUserData()
    }
    
    
    //MARK:- IBActions
    @IBAction func editBtnPressed(_ sender: UIButton) {
        
        asignImgFromGallary()
    }
    
    
    //MARK:-  Helper Functions
    func retriveUserData(){
        if let userData = FUser.currentUser(){
            userNameTFOutlet.text = userData.fullname
            userStatusOutlet.text = userData.status
            if userData.avatar != ""{
                imageFromStringData(stringImgData: userData.avatar) { image in
                    self.userProfileImgOutlet.image = image
                }
            }
        }
    }
    func setupUI(){
        tableView.tableFooterView = UIView()
        self.title = "Edit"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func asignImgFromGallary(){
        gallary = GalleryController()
        gallary.delegate = self
        
        
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        self.present(gallary, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0 : 10
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0{
            let statusVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(identifier: "StatusVC") as! StatusVC
            self.navigationController?.pushViewController(statusVC, animated: true)
        }
    }
    
}
//MARK:- TextField Delrgates

extension EditSettingsVC:UITextFieldDelegate{
    func textFieldDelegate(){
        userNameTFOutlet.delegate = self
        userNameTFOutlet.clearButtonMode = .whileEditing
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTFOutlet {
            if let user = FUser.currentUser(){
                user.fullname = textField.text!
                //saveToUserDeafults(user)
                FirebaseAPI.shared.saveUserToDatabase(userId: FUser.currentId(), email: FUser.currentUser()!.email, name: user.fullname, avatar: FUser.currentUser()!.avatar , status: FUser.currentUser()!.status) { error, dbRef in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    ProgressHUD.showSuccess("Name updated")
             
                }
                
            }
            return false
        }
        textField.resignFirstResponder()
        return true
    }
}

extension EditSettingsVC:GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { image in
                if image != nil{
                    self.profileImg = image?.circleMasked
                    let strImg = stringFromImage(image: self.profileImg!)
                    FirebaseAPI.shared.saveUserToDatabase(userId: FUser.currentId(), email: FUser.currentUser()!.email, name: FUser.currentUser()!.fullname, avatar: strImg, status: FUser.currentUser()!.status) { error, dbRef in
                        if error != nil {
                            ProgressHUD.showError(error?.localizedDescription)
                            return
                        }
                        ProgressHUD.showSuccess("photo updated")
                        self.userProfileImgOutlet.image = self.profileImg
                    }
                }
            }
  
        }else{
            ProgressHUD.showError("Cant upload image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}



