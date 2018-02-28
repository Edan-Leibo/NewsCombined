//
//  LocalFileStore.swift
//  NewsCombined
//



//This class is in charge of handling files and storing them on the local memory of device

import Foundation
import UIKit


//Function saves file locally
class LocalFileStore {
    static func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
//Function gets the dir path of file
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

//Function extracts the image from the file containing it
    static func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
}


