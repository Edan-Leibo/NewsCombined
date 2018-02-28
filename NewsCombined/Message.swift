

import Foundation
import FirebaseDatabase

/*
 This class is the Message class and all its data members - each cluster has its own messages and chat.
 */

class Message {
    
    var id : String
    var sender : String
    var body : String
    var categoryTopic : String //This is the foreign key of the Cluster to which the chat belongs to
    var lastUpdate:Date?

    
    /*
     Simple constructor for the Message class
     */
    
    init(insertId: String, insertSender : String, insertBody: String, InsertCategotyTopic: String) {
        self.id = insertId
        self.sender = insertSender
        self.body = insertBody
        self.categoryTopic = InsertCategotyTopic
    }
    
    
    /*
     Json constructor for the Message class
     */
    init(json:Dictionary<String,Any>){
        id = json["id"] as! String
        sender = json["sender"] as! String
        body = json["body"] as! String
        categoryTopic = json["categoryTopic"] as! String
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }

    /*
    Function to create an instance of the Message class from a JSON file
     */
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["id"] = id
        json["sender"] = sender
        json["body"] = body
        json["categoryTopic"] = categoryTopic
        json["lastUpdate"] = ServerValue.timestamp()
        return json
        
    }
}

