//
//  OutgoingMessages.swift
//  ChatNasrCity
//
//  Created by Mohamed Arafa on 12/4/19.
//  Copyright © 2019 VarsKey. All rights reserved.
//

import Foundation
class OutgoingMessages{
    
    let messagesDictionary: NSMutableDictionary
    
    //MARK: Intializers
    
    // text Messages
    init(message: String, senderId: String, senderName: String, date: Date, messageType: String, type: String, messageId: String) {
        
        messagesDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().string(from: date), messageType, type, messageId], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kMESSAGETYPE as NSCopying, kTYPE as NSCopying, kMESSAGEID as NSCopying])
        
    }
    
    // Picture Messages
    init(message: String, senderId: String, senderName: String, date: Date, messageType: String, imageLink: String, type: String, messageId: String) {
        
        messagesDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().string(from: date), messageType, imageLink, type, messageId], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kMESSAGETYPE as NSCopying, kPICTURE as NSCopying, kTYPE as NSCopying, kMESSAGEID as NSCopying])
    }
    
    
    //MARK: SendMessage
    
    func sendMessage(chatRoomId: String, messageDictionary: NSMutableDictionary, membersIds: [String]){
        
        
        let DB = DBref.child(reference(.Message))
        
        for memberId in membersIds{
            
            // create new refrence in firestore with this message for all members
            
            DB.child(memberId).child(chatRoomId).child(messageDictionary[kMESSAGEID] as! String).setValue(messageDictionary as! [String : Any])
            
        }
        
        // update recent Chat
        
        //updateRecent(chatRoomId: chatRoomId, lastMessage: messageDictionary[kMESSAGE] as! String, membersIds: membersIds)
        
        // send PushNotifircation for other users
  
    }

}
