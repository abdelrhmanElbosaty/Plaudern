//
//  Storage.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 26/09/2021.
//

import Foundation
import FirebaseStorage
import Firebase
import MBProgressHUD

let storage = Storage.storage()
let kFILEREFERENCE = "gs://plaudern-76169.appspot.com"

//MARK: - uploadImage
func uploadImg(image: UIImage, chatRoomId: String, view: UIView, completion: @escaping (_ imageLink: String?) -> Void){
    
    let progress = MBProgressHUD.showAdded(to: view, animated: true)
    progress.mode = .annularDeterminate
    
    let dateString = dateFormatter().string(from: Date())
    let photoFileName = "PictureMessages/" + FUser.currentId() + "/" + chatRoomId + "/" + dateString + ".jpg"
    let srorageRef = storage.reference(forURL: kFILEREFERENCE).child(photoFileName)
    
    let imgData = image.jpegData(compressionQuality: 0.4)
    
    var uploadTask: StorageUploadTask!
    uploadTask = srorageRef.putData(imgData!, metadata: nil, completion: { storageData, error in
        uploadTask.removeAllObservers()
        progress.hide(animated: true)
        if error != nil {
            print("error uploading image \(error!.localizedDescription)")
            completion(nil)
            return
        }
        srorageRef.downloadURL { url, error in
            guard let url = url else{
                completion(nil)
                return}
            completion(url.absoluteString)
        }
    })
    uploadTask.observe(StorageTaskStatus.progress) { snapshot in
        progress.progress = Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!)
    }
}

//MARK: downloadImage
func downloadImage(imageUrl: String, completion: @escaping(_ image: UIImage?) -> Void) {

    let imageURL = NSURL(string: imageUrl)

    let imageFileName = (imageUrl.components(separatedBy: "%").last!).components(separatedBy: "?").first!


    if fileExistsAtPath(path: imageFileName) {

        //exist
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
            completion(contentsOfFile)
        } else {
            print("couldnt generate image")
            completion(nil)
        }

    } else {
        //doesnt exist

        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")

        downloadQueue.async {

            let data = NSData(contentsOf: imageURL! as URL)

            if data != nil {

                var fileManagerURL = getDocumentsURL()
                // to save image locally and then return it
                fileManagerURL = fileManagerURL.appendingPathComponent(imageFileName, isDirectory: false)

                data!.write(to: fileManagerURL, atomically: true)

                let imageToReturn = UIImage(data: data! as Data)

                DispatchQueue.main.async {
                    completion(imageToReturn!)
                }

            } else {
                DispatchQueue.main.async {
                    print("no image in database")
                    completion(nil)
                }
            }
        }
    }
}

//MARK: File Path and if Exist at Documents

// create new blank file
func getDocumentsURL() -> URL{
    let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    return docUrl!
}

//"file/last/\(filename)"
func fileInDocumentsDirectory(fileName: String) -> String{
    let fileUrl = getDocumentsURL().appendingPathComponent(fileName)
    return fileUrl.path
}
// check if file exist or not
func fileExistsAtPath(path: String) -> Bool{
    var doesExist = false
    let filePath = fileInDocumentsDirectory(fileName: path)
    let fileManger = FileManager.default
    
    if fileManger.fileExists(atPath: filePath){
        doesExist = true
    }else{
        doesExist = false
    }
    return doesExist
}
