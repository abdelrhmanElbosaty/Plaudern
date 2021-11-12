//
//  HelperFunctions.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 12/09/2021.
//

import UIKit


private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter{
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}

func timeElapsed(date: Date) -> String {
   
   let seconds = NSDate().timeIntervalSince(date)
   
   var elapsed: String?
   
   
   if (seconds < 60) {
       elapsed = "Just now"
   } else if (seconds < 60 * 60) {
       let minutes = Int(seconds / 60)
       
       var minText = "min"
       if minutes > 1 {
           minText = "mins"
       }
       elapsed = "\(minutes) \(minText)"
       
   } else if (seconds < 24 * 60 * 60) {
       let hours = Int(seconds / (60 * 60))
       var hourText = "hour"
       if hours > 1 {
           hourText = "hours"
       }
       elapsed = "\(hours) \(hourText)"
   } else {
       let currentDateFormater = dateFormatter()
       currentDateFormater.dateFormat = "yyyy-MM-dd"
       
       elapsed = "\(currentDateFormater.string(from: date))"
   }
   
   return elapsed!
}

/* Time

func formatCallTime(date: Date) -> String {

let seconds = NSDate().timeIntervalSince(date)

var elapsed: String?


if (seconds < 60) {
elapsed = "Just now"
}  else if (seconds < 24 * 60 * 60) {

let currentDateFormater = dateFormatter()
currentDateFormater.dateFormat = "HH:mm:ss"

elapsed = "\(currentDateFormater.string(from: date))"
} else {
let currentDateFormater = dateFormatter()
currentDateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"

elapsed = "\(currentDateFormater.string(from: date))"
}

return elapsed!
}

// read time status "HH:MM"

func readTimeFrom(dateString: String) -> String{

let date = dateFormatter().date(from: dateString)

let CurrentDateFormat = dateFormatter()
CurrentDateFormat.dateFormat = "HH:mm:ss"

return CurrentDateFormat.string(from: date!)
}
*/

// to convert string data to img when call it from fire store
func imageFromStringData(stringImgData: String, withBlock: @escaping( _ img: UIImage?)-> Void ){
    var img: UIImage?
    
    let decodedData = NSData(base64Encoded: stringImgData, options: NSData.Base64DecodingOptions(rawValue: 0))
    img = UIImage(data: decodedData! as Data)
    
    withBlock(img)
}


func stringFromImage(image: UIImage) -> String{
    
    let imageData = image.jpegData(compressionQuality: 0.5)
    
    guard let encodedString = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else {return ""}
    
    return encodedString
}

func getRoomId(fUser: String , sUser: String) -> String{
    let com = fUser.compare(sUser).rawValue
    
    if com > 0 {
        return fUser + sUser
    }else{
        return sUser + fUser
    }
    
        
    
}
