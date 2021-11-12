//
//  FUser.swift
//  MyChatTest
//
//  Created by abdurhman elbosaty on 12/09/2021.
//

import Foundation
import Firebase

class FUser {
    
    let objectId: String
    let createdAt: Date
    var updatedAt: Date
    var email: String
    var fullname: String
    var avatar: String
    var status: String = "Busy"
    
    //MARK: Initializers
    
    init(_objectId: String, _createdAt: Date, _updatedAt: Date, _email: String, _fullname: String , _avatar: String, _status: String) {
        
        objectId = _objectId
        createdAt = _createdAt
        updatedAt = _updatedAt
        email = _email
        fullname = _fullname
        avatar = _avatar
        status = _status
    }
    
    init(_dictionary: NSDictionary) {

        objectId = _dictionary[kOBJECTID] as! String
        
        if let created = _dictionary[kCREATEDAT] {
            if (created as! String).count != 14 {
                createdAt = Date()
            } else {
                createdAt = dateFormatter().date(from: created as! String)!
            }
        } else {
            createdAt = Date()
        }
        
        if let updateded = _dictionary[kUPDATEDAT] {
            if (updateded as! String).count != 14 {
                updatedAt = Date()
            } else {
                updatedAt = dateFormatter().date(from: updateded as! String)!
            }
        } else {
            updatedAt = Date()
        }
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fname = _dictionary[kFULLNAME] {
            fullname = fname as! String
        } else {
            fullname = ""
        }
        
        if let myAvatar = _dictionary[kAVATAR] {
            avatar = myAvatar as! String
        } else {
            avatar = ""
        }
        if let userStatus = _dictionary[KSTATUS] {
            status = userStatus as! String
        } else {
            status = ""
        }
        
    }
    
    
    //MARK: Returning current user funcs
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser () -> FUser? {
        
        if Auth.auth().currentUser != nil {
            
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {

                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
}


func saveUserLocally(fUser: FUser) {
    
    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
    
}

func SaveCurrentUser(uId: String, complition: @escaping (_ succ: Bool)->Void){
    
    let usersDB = DBref.child(reference(.User)).child(uId)
    
    usersDB.observeSingleEvent(of: .value) { (snapshot) in
        
        if snapshot.exists(){
            
            let usersDic = snapshot.value as! [String : Any]

            saveUserLocally(fUser: FUser(_dictionary: usersDic as NSDictionary))
            complition(true)
        }else{
            complition(false)
        }
    }
}

func userDictionaryFrom(user: FUser) -> NSDictionary {
    
    let createdAt = dateFormatter().string(from: user.createdAt)
    let updatedAt = dateFormatter().string(from: user.updatedAt)
    
    return NSDictionary(objects: [user.objectId,  createdAt, updatedAt, user.email, user.fullname, user.avatar,user.status], forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kEMAIL as NSCopying, kFULLNAME as NSCopying, kAVATAR as NSCopying, kSTATUS as NSCopying])
    
}
