//
//  FirebaseFileStore.swift
//  NewsCombined
//
//  Created by admin on 22/02/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//


import Foundation
import Firebase
import FirebaseStorage

class FirebaseFileStore {
    static var storageRef = Storage.storage().reference(forURL:
        "gs://sssss-41596.appspot.com/")
    
    static func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = storageRef.child(name)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.putData(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    //NEEDED CHANGES MIGHT BE PROBLEM
    static func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData (maxSize: 10000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }
}

