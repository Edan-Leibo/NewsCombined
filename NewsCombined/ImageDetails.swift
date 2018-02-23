

import Foundation
import FirebaseDatabase

class ImageDetails{
    
    //var id : String
    var sender : String
    var imageurl : String
    var lastUpdate:Date?
    
    
    init(/*insertid: String,*/insertsender: String, insertimageurl : String) {
    //  self.id = insertid
        self.sender = insertsender
        self.imageurl = insertimageurl
   
    }
    
    init(json:Dictionary<String,Any>){
   //     id = json["id"] as! String
        sender = json["sender"] as! String
        imageurl = json["imageurl"] as! String
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
      //  json["id"] = id
        json["sender"] = sender
        json["imageurl"] = imageurl
        json["lastUpdate"] = ServerValue.timestamp()
        return json
        
    }
}


