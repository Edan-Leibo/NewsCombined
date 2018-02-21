//
//  Article.swift
//  NewsCombined
//
//  Created by admin on 14/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Article {
    
    var id : String = ""
    var url : String = ""
    var title : String = ""
    var imageURL : String = ""
    var description : String = ""
    var author : String = ""
    var source : String = ""
    var clusterKey : String = ""    //foreign KEYS
    var content : String = ""
    var lastUpdate:Date?

    
    init(insertId:String, fromJson:[String:Any]){
        id = insertId
        url = fromJson["url"] as! String
        title = fromJson["title"] as! String
        imageURL = fromJson["imageURL"] as! String
        description = fromJson["description"] as! String
        author = fromJson["author"] as! String
        source = fromJson["source"] as! String
        clusterKey = fromJson["clusterKey"] as! String
        content = fromJson["content"] as! String
        if let ts = fromJson["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }

    }
    
    init(insertId:String, inserturl : String, inserttitle : String,insertimageURL : String, insertdescription : String, insertauthor : String, insertsource : String , insertcontent : String,insertclusterkey : String) {
        
        id = insertId
        url = inserturl
        title = inserttitle
        imageURL = insertimageURL
        description = insertdescription
        author = insertauthor
        source = insertsource
        content = insertcontent
        clusterKey = insertclusterkey
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["id"] = id
        json["url"] = url
        json["title"] = title
        json["imageURL"] = imageURL
        json["description"] = description
        json["author"] = author
        json["source"] = source
        json["clusterKey"] = clusterKey
        json["source"] = source
        json["content"] = content
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
}


