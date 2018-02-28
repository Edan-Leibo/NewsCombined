

import Foundation
import FirebaseDatabase

class Message {
    
    var id : String
    var sender : String
    var body : String
    var categoryTopic : String
    var lastUpdate:Date?

    
    init(insertId: String, insertSender : String, insertBody: String, InsertCategotyTopic: String) {
        self.id = insertId
        self.sender = insertSender
        self.body = insertBody
        self.categoryTopic = InsertCategotyTopic
    }
    
    init(json:Dictionary<String,Any>){
        id = json["id"] as! String
        sender = json["sender"] as! String
        body = json["body"] as! String
        categoryTopic = json["categoryTopic"] as! String
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }

    
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

