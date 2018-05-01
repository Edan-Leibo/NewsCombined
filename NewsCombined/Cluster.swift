//
//  Cluster.swift
//  NewsCombined
//

/*
 This class is the Cluster class and all its data members - each cluster has various articles with a common subject matter
 */

import Foundation
import FirebaseDatabase

class Cluster {
    
    //The key/ID for cluster is created with the combination of the category and the topic

    var category : String = ""
    var topic : String = ""
    var clusterimgurl : String = ""
    var clustertitle : String = ""
    var lastUpdate:Date?

    /*
     Simple constructor for the Cluster class
     */
    
    init(insertcategory : String, inserttopic : String, insertclusterimg : String, insertclustertitle : String) {
        //  id = insertid
        category = insertcategory
        topic = inserttopic
        clusterimgurl = insertclusterimg
        clustertitle = insertclustertitle
    }
    /*
     Json constructor for the Cluster class
     */
    init(fromJson:[String:Any]){
        category = fromJson["category"] as! String
        topic = fromJson["topic"] as! String
        clusterimgurl = fromJson["clusterimgurl"] as! String
        clustertitle = fromJson["clustertitle"] as! String
        if let ts = fromJson["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    /*
     A function that creates an instance of the Cluster class with a JSON file
     */
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["category"] = category
        json["topic"] = topic
        json["clusterimgurl"] = clusterimgurl
        json["clustertitle"] = clustertitle
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
    
}


