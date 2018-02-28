//
//  ModelFileStore.swift
//  NewsCombined
//
//

import Foundation
import UIKit

/*
This class is in charge of jugling between local save of files/images and cloud save of files/images
it uses both the FirebaseFileStore and the LocalFileStore
*/

class ModelFileStore {
    
    /*
     This function saves image to FB cloud and than locally
     */
    static func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        FirebaseFileStore.saveImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                LocalFileStore.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    
    //This function first attempts to get image from local catche - if its not there it attempts to get it from Firebase and after that saves it locally
    
    static func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        if let image = LocalFileStore.getImageFromFile(name: localImageName){
            callback(image)
        }else{
            //2. get the image from Firebase
            FirebaseFileStore.getImageFromFirebase(url: urlStr, callback: { (image) in
                if (image != nil){
                    //3. save the image localy
                    LocalFileStore.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
            })
        }
    }


    
//For Images not stored in Firebase we have a different function for getting them from URL and saving locally
static func getImageFromWeb(urlStr:String, callback:@escaping (UIImage?)->Void){
    // try to get the image from local store
    let url = URL(string: urlStr)
    let localImageName = url!.lastPathComponent
    if let image = LocalFileStore.getImageFromFile(name: localImageName){
        callback(image)
    }else{
        let url = URL(string: urlStr)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            LocalFileStore.saveImageToFile(image: image, name: localImageName)
            // return the image to the user
            callback(image)
        }

       
    }
    
}
}


