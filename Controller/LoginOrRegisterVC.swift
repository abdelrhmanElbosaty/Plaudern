//
//  ViewController.swift
//  RealTimeChatApp Session15 LVL3
//
//  Created by abdurhman elbosaty on 06/09/2021.
//

import UIKit
import Gallery
import ProgressHUD
import Firebase

class LoginOrRegisterVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!{
        didSet{
            userNameTF.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailTF: UITextField!{
        didSet{
            userEmailTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userPasswordTF: UITextField!{
        didSet{
            userPasswordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var userPasswordLbl: UILabel!
    @IBOutlet weak var signBtnOutlet: UIButton!
    @IBOutlet weak var notfiLBL: UILabel!
    
    //MARK:- Variables
    var profileImg: UIImage?
    var gallary: GalleryController!
    override func viewDidLoad() {
        super.viewDidLoad()
        swipesGesture()
        tapGesture()
        setupTextDelegates()
    }
    
    
    //MARK:- Helper Functions
    func setupTextDelegates(){
        userNameTF.delegate = self
        userEmailTF.delegate = self
        userPasswordTF.delegate = self
    }
    func swipesGesture(){
        let leftSwip = UISwipeGestureRecognizer()
        let rightSwip = UISwipeGestureRecognizer()
        
        leftSwip.direction = .left
        rightSwip.direction = .right
        
        leftSwip.addTarget(self, action: #selector(self.swipeToDo))
        rightSwip.addTarget(self, action: #selector(self.swipeToDo))
        
        self.view.addGestureRecognizer(leftSwip)
        self.view.addGestureRecognizer(rightSwip)
    }
    
    func tapGesture(){
        userProfileImgView.isUserInteractionEnabled = true
        userProfileImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapToPickImg)))
    }
    
    func signUp(){
         if prepareFieldsToUse(to: .register){
            FirebaseAPI.shared.firebaseRegister(email: userEmailTF.text!, password: userPasswordTF.text!) { authData,error in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                print(authData?.user.uid as Any)
                self.saveUserToDatabase(userId: authData!.user.uid)
                self.goToApp()
            }
        }else{
            ProgressHUD.showError("All fields Required")
        }
    }
    
    func saveUserToDatabase(userId: String){
        FirebaseAPI.shared.saveUserToDatabase(userId: userId, email: userEmailTF.text!, name: userNameTF.text!, avatar: stringFromImage(image: profileImg!), status: "Busy") { error, databaseRef in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            self.goToApp()
//            UserDefaults.standard.set(true, forKey: KISUSERLOGGEDIN)
            UserDefaults.standard.synchronize()
        }
    }
    // to sign in
    func signIn(){
        if prepareFieldsToUse(to: .login){
            FirebaseAPI.shared.firebaseLogin(email: userEmailTF.text!, password: userPasswordTF.text!) { authData, error in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                print(authData?.user.uid as Any)
                SaveCurrentUser(uId: (authData?.user.uid)!) { succ in
                    if succ{
                        self.goToApp()
                        print("yyyyy")
//                        UserDefaults.standard.set(true, forKey: KISUSERLOGGEDIN)
                        UserDefaults.standard.synchronize()
                    }else{
                        ProgressHUD.showError("Cant Save Data")
                    }
                }
            }
        }else{
            ProgressHUD.showError("All fields Required")
        }
    }
    // to check if fields not empty
    func prepareFieldsToUse(to: PrepareTF) -> Bool{
        if to == .login{
            return !userEmailTF.text!.isEmpty && userPasswordTF.text != ""
        }else{
            return !userNameTF.text!.isEmpty && userPasswordTF.text != "" && profileImg != nil
        }
    }
    // segue
    func goToApp(){
        let vc = UIStoryboard(name: "MainTabbar", bundle: nil).instantiateViewController(identifier: "mainTabbar")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- IBActions
    
    // swiped view
    @objc func swipeToDo(){
        if signBtnOutlet.titleLabel?.text == "Sign Up"{
            signBtnOutlet.setTitle("Sign In", for: .normal)
            userNameTF.isHidden = true
            userNameLbl.isHidden = true
            userProfileImgView.isHidden = true
            notfiLBL.text = "Swipe To Sign Up"
        }else{
            signBtnOutlet.setTitle("Sign Up", for: .normal)
            userNameTF.isHidden = false
            userNameLbl.isHidden = false
            userProfileImgView.isHidden = false
            notfiLBL.text = "Swipe To Sign In"
        }
    }
    // profile img taper
    @objc func tapToPickImg(){
        gallary = GalleryController()
        gallary.delegate = self
        
        
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        self.present(gallary, animated: true, completion: nil)
    }
    @IBAction func signBtnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Sign Up"{
            signUp()
        }else{
            signIn()
        }
    }
}
extension LoginOrRegisterVC: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        userNameLbl.text = userNameTF.hasText ? "Full Name" : " "
        userEmailLbl.text = userEmailTF.hasText ? "E-mail Address" : " "
        userPasswordLbl.text = userPasswordTF.hasText ? "Password" : " "
    }
}
// Image Picker
extension LoginOrRegisterVC: GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            
            images.first!.resolve{(image) in
                if image != nil{
                    self.profileImg = image
                    self.userProfileImgView.image = self.profileImg?.circleMasked
                }else{
                    ProgressHUD.showError("Cant upload image")
                }
        }
        dismiss(animated: true, completion: nil)
    }
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


