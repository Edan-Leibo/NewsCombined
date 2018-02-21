//
//  Cluster.swift
//  NewsCombined
//
//  Created by admin on 14/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Cluster {
    
    

    var category : String = ""
    var topic : String = ""
    var clusterimgurl : String = ""
    var clustertitle : String = ""
    var lastUpdate:Date?
    
    
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
        if let ts = fromJson["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["category"] = category
        json["topic"] = topic
        json["clusterimgurl"] = clusterimgurl
        json["clustertitle"] = clustertitle
        json["lastUpdate"] = ServerValue.timestamp()

        return json
    }
    /*
     func addarticles(toinsert : Article) {
     articles.append(toinsert)
     return
     
     }
     */
}


