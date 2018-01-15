//
//  Cluster.swift
//  NewsCombined
//
//  Created by admin on 14/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class Cluster {
    
    
    //var id : String = ""
    var category : String = ""
    var topic : String = ""
    var clusterimgurl : String = ""
    var clustertitle : String = ""
    //  var articles : [Article] = [Article] ()
    
    
    init(insertcategory : String, inserttopic : String, insertclusterimg : String, insertclustertitle : String) {
        //  id = insertid
        category = insertcategory
        topic = inserttopic
        clusterimgurl = insertclusterimg
        clustertitle = insertclustertitle
    }
    
    init(fromJson:[String:Any]){
        category = fromJson["category"] as! String
        topic = fromJson["topic"] as! String
        clusterimgurl = fromJson["clusterimgurl"] as! String
        clustertitle = fromJson["clustertitle"] as! String
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["category"] = category
        json["topic"] = topic
        json["clusterimgurl"] = clusterimgurl
        json["clustertitle"] = clustertitle
        
        return json
    }
    /*
     func addarticles(toinsert : Article) {
     articles.append(toinsert)
     return
     
     }
     */
}


