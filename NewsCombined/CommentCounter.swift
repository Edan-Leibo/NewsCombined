//
//  Article.swift
//  NewsCombined



/*
 This class is the Article and all its data members - each cluster has various articles with a common subject matter
 */

import Foundation
import FirebaseDatabase

class CommentCounter {
    
    var topic : String = ""
    var numOfComments : String = ""
   
    
    /*
     A Json constructor for the Article class
     */
    
    init(json:Dictionary<String,Any>){
        topic = json["id"] as! String
        numOfComments = json["sender"] as! String
       
    }
    
    /*
     Simple constructor for the Article class
     */
    
    init(insertTopic:String, insertNumOfComments : String) {
        
        topic = insertTopic
        numOfComments = insertNumOfComments
    
    }
    
    /*
     This function creates a JSON file containing the specific Article instance
     */
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["topic"] = topic
        json["commentCounter"] = numOfComments
       
        return json
    }
}



