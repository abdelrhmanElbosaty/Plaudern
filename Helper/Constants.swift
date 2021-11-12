//
//  Constants.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 12/09/2021.
//

import Foundation
import Firebase


let SCREENHEIGHT = UIScreen.main.bounds.height
let SCREENWIDTH = UIScreen.main.bounds.width
//let KISUSERLOGGEDIN = "isUserLoggedIn"

var DBref = Database.database().reference()


enum PrepareTF: String {
    case login
    case register
}




//FUser
public let kOBJECTID = "objectId"
public let kCREATEDAT = "createdAt"
public let kUPDATEDAT = "updatedAt"
public let kEMAIL = "email"
public let kPHONE = "phone"
public let kPUSHID = "pushId"
public let kFIRSTNAME = "firstname"
public let kLASTNAME = "lastname"
public let kFULLNAME = "fullname"
public let kAVATAR = "avatar"
public let KSTATUS = "status"
public let kCURRENTUSER = "currentUser"
public let kCITY = "city"
public let kCOUNTRY = "country"

public let kPRIVATE = "private"
public let kGROUP = "group"


//recent chats
public let kCHATROOMID = "chatRoomID"
public let kUSERID = "userId"
public let kGROUPID = "groupId"
public let kRECENTID = "recentId"
public let kMEMBERS = "members"
public let kMEMBERSTOPUSH = "membersToPush"
public let kDISCRIPTION = "discription"
public let kLASTMESSAGE = "lastMessage"
public let kCOUNTER = "counter"
public let kTYPE = "type"
public let kWITHUSERUSERNAME = "withUserUserName"
public let kWITHUSERUSERID = "withUserUserID"
public let kOWNERID = "ownerID"
public let kSTATUS = "status"
public let kMESSAGEID = "messageId"
public let kNAME = "name"
public let kWITHUSERFULLNAME = "withUserFullName"
public let kSENDERID = "senderId"
public let kSENDERNAME = "senderName"


//message types
public let kPICTURE = "picture"
public let kTEXT = "text"
public let kVIDEO = "video"
public let kAUDIO = "audio"
public let kLOCATION = "location"

//coordinates
public let kLATITUDE = "latitude"
public let kLONGITUDE = "longitude"


public let kUSERS = "users"
public let kUSER = "user"
public let kDATE = "date"
public let kMESSAGE = "message"

public let kMESSAGETYPE = "messageType"
