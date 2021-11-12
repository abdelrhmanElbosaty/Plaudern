//
//  MessagesVC.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 19/09/2021.
//

import UIKit
import Gallery
import ProgressHUD

class MessagesVC: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var openGalleryBtnOutlet: UIButton!
    @IBOutlet weak var sendMessageBtnOutlet: UIButton!
    @IBOutlet weak var messageTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Varibales
    var gallary: GalleryController!
    var message = [Messages]()
    var usersId: [String]!
    var chatRoomId: String!
    var users = [FUser]()
    
    var choosedImg: UIImage?
    
    var chatRoomName: String!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        message = []
        chatRoomId = getRoomId(fUser: usersId.first!, sUser: usersId.last!)
        retriveMessage()
        setupNavigationUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- IBActions
    @IBAction func sendMessageBtnPressed(_ sender: UIButton) {
        if messageTF.text != ""{
            sendMessageBtnOutlet.isEnabled = false
            sendMessage(text: messageTF.text!, photo: nil)
        }
    }
    
    @IBAction func openCameraOrGallaryBtnPressed(_ sender: UIButton) {
        
        gallary = GalleryController()
        gallary.delegate = self
        
        
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        self.present(gallary, animated: true, completion: nil)
    }
    //MARK:- Helper Functions
    
    func setupUI(){
        self.tabBarController?.tabBar.isHidden = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
    }
    func setupNavigationUI(){
        self.navigationItem.title = chatRoomName
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.transparentNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.6143774986, blue: 0.7439641953, alpha: 1)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    // send message
    func sendMessage(text: String? , photo: String?){
        if let text = text{
            let ecryptedTxt = Encryption.encryptText(chatRoomId: chatRoomId, message: text)
            let messageId = UUID().uuidString
            let message = OutgoingMessages(message: ecryptedTxt, senderId: FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date: Date(), messageType: kPRIVATE, type: messageType(.text), messageId: messageId)
            message.sendMessage(chatRoomId: chatRoomId, messageDictionary: message.messagesDictionary, membersIds: usersId)
            messageTF.text = ""
            sendMessageBtnOutlet.isEnabled = true
        }
        
        if let photo = photo{
            let ecryptedTxt = Encryption.encryptText(chatRoomId: chatRoomId, message: "[image]")
            let messageId = UUID().uuidString
            let message = OutgoingMessages(message: ecryptedTxt , senderId: FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date: Date(), messageType: kPRIVATE, imageLink: photo, type: messageType(.image), messageId: messageId)
            message.sendMessage(chatRoomId: chatRoomId, messageDictionary: message.messagesDictionary, membersIds: usersId)
        }
    }
    //  get message to show
    func retriveMessage(){
        DBref.child(reference(.Message)).child(FUser.currentId()).child(chatRoomId).queryOrdered(byChild: kDATE).observe(.childAdded) { (snapshot) in
            
            let snap = snapshot.value as! NSDictionary
            
            let newMessage = Messages(_dictionary: snap ,chatRoomId: self.chatRoomId)
            
            self.message.append(newMessage)
            
            self.tableView.reloadData()
            self.scrollDown()
        }
    }
    // to reach last message at time
    func scrollDown(){
        DispatchQueue.main.async {
            
            let indexPath = IndexPath(row: self.message.count - 1, section: 0)
            
            if (indexPath.row > 0){
                
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }
}


//MARK:- TableView

extension MessagesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if message[indexPath.row].type == kTEXT {
            if message[indexPath.row].senderId == FUser.currentId(){
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendedMessageCell") as! SendedMessageCell
                cell.dateLbl.text = timeElapsed(date: message[indexPath.row].date)
                cell.messageLbl.text = message[indexPath.row].message
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResevedMessageCell") as! ResevedMessageCell
                cell.dateLbl.text = timeElapsed(date: message[indexPath.row].date)
                cell.messageLbl.text = message[indexPath.row].message
                return cell
            }
        }else{
            if message[indexPath.row].senderId == FUser.currentId(){
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendImgCell") as! SendImgCell
                downloadImage(imageUrl: message[indexPath.row].picture) { image in
                    if let image = image {
                        cell.imgMessage.image = image
                    }
                }
                cell.dateLbl.text = timeElapsed(date: message[indexPath.row].date)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResevedImgCell") as! ResevedImgCell
                downloadImage(imageUrl: message[indexPath.row].picture) { image in
                    if let image = image {
                        cell.imgMessage.image = image
                    }
                }
                cell.dateLbl.text = timeElapsed(date: message[indexPath.row].date)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK:- Image Picker

extension MessagesVC: GalleryControllerDelegate{
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            images.first!.resolve{(image) in
                if image != nil{
                    self.choosedImg = image
                    //TODO: -
                    uploadImg(image: self.choosedImg!, chatRoomId: self.chatRoomId, view: self.view) { imgUrl in
                        guard let imgUrl = imgUrl else{return}
                        
                        self.sendMessage(text: nil, photo: imgUrl)
                    }
                }else{
                    ProgressHUD.showError("Cant upload image")
                }
            }
            self.dismiss(animated: true, completion: nil)
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



