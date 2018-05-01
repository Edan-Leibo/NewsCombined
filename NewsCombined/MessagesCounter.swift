

import Foundation
import FirebaseDatabase

/*
 This class is the Message class and all its data members - each cluster has its own messages and chat.
 */

class MessagesCounter {
    
    var topic : String
    var numOfComments: String
    var lastUpdate:Date?
    
    
    /*
     Simple constructor for the Message class
     */
    
    init(insertTopic: String, insertNumOfComments : String) {
        self.topic = insertTopic
        self.numOfComments = insertNumOfComments

    }
    
    
    /*
     Json constructor for the Message class
     */
    init(json:Dictionary<String,Any>){
        topic = json["topic"] as! String
        numOfComments = json["numOfComments"] as! String
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    /*
     Function to create an instance of the Message class from a JSON file
     */
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["topic"] = topic
        json["numOfComments"] = numOfComments
        json["lastUpdate"] = ServerValue.timestamp()
        return json
        
    }
}


