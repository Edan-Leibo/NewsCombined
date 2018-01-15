//
//  Article.swift
//  NewsCombined
//
//  Created by admin on 14/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation


class Article {
    
    //  var id : String = ""
    var url : String = ""
    var title : String = ""
    var imageURL : String = ""
    var description : String = ""
    var author : String = ""
    var source : String = ""
    var clusterKey : String = ""    //foreign KEYS
    // var clustertopic : String = ""
    //var publishedAt : String = ""
    var content : String = ""
    
    
    init(fromJson:[String:Any]){
        // id = fromJson["id"] as! String
        url = fromJson["url"] as! String
        title = fromJson["title"] as! String
        imageURL = fromJson["imageURL"] as! String
        description = fromJson["description"] as! String
        author = fromJson["author"] as! String
        source = fromJson["source"] as! String
        clusterKey = fromJson["clusterKey"] as! String
        // clustertopic = fromJson["clustertopic"] as! String
        //    publishedAt = fromJson["publishedAt"] as! String
        content = fromJson["content"] as! String
    }
    
    init(inserturl : String, inserttitle : String,insertimageURL : String, insertdescription : String, insertauthor : String, insertsource : String , insertpublishdate : String , insertcontent : String,insertclusterkey : String) {
        
        url = inserturl
        title = inserttitle
        imageURL = insertimageURL
        description = insertdescription
        author = insertauthor
        source = insertsource
        //   publishedAt = insertpublishdate
        content = insertcontent
        clusterKey = insertclusterkey
        //   clustertopic = insertclustertopic
        
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        //  json["articleid"] = id
        json["url"] = url
        json["title"] = title
        json["imageURL"] = imageURL
        json["description"] = description
        json["author"] = author
        json["source"] = source
        json["clusterKey"] = clusterKey
        json["source"] = source
        //     json["clustertopic"] = clustertopic
        json["content"] = content
        
        return json
    }
}


