//
//  ModelFileStore.swift
//  NewsCombined
//
//  Created by admin on 22/02/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import UIKit

class ModelFileStore {
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
}
