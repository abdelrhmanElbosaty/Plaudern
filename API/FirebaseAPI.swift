//
//  FirebaseAPI.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 12/09/2021.
//

import Foundation
import Firebase

class FirebaseAPI {
    init() {}
    
   static let shared = FirebaseAPI()
    
    
    func firebaseRegister(email: String ,password: String ,complition: @escaping (_ data: AuthDataResult?,_ error: Error? )->Void){
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            if error != nil {
                print(error?.localizedDescription as Any)
                complition(nil,error)
                return
            }
            complition(authData,nil)
        }
    }
    
    func firebaseLogin(email: String ,password: String, complition: @escaping (_ data: AuthDataResult?, _ error: Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if error != nil {
                print(error?.localizedDescription as Any)
                complition(nil,error)
                return
            }
            complition(authData,nil)
        }
    }
    
    func firebaseLogOut(complitionHandeler: @escaping (_ error: Error?)->Void){
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            complitionHandeler(nil)
        } catch let err as NSError {
            
            complitionHandeler(err)
        }
    }
    
    
    func saveUserToDatabase(userId: String ,email: String, name: String ,avatar: String,status: String , complition: @escaping (_ error: Error?, _ databaseRef: DatabaseReference? )->Void){
        
        let user = FUser(_objectId: userId, _createdAt: Date(), _updatedAt: Date(), _email: email, _fullname:name , _avatar: avatar, _status: status)
        
        let userDict = userDictionaryFrom(user: user)
        
        DBref.child(reference(.User)).child(userId).setValue(userDict) { error, databaseRef in
            if error != nil{
                complition(error,nil)
            }else{
                saveUserLocally(fUser: user)
                complition(nil,databaseRef)
            }
        }
    }
}

