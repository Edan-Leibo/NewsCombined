

import Foundation
import FirebaseDatabase


/*
 This class is the UserDetails and all its data members - each instance contains both the image of the user and the username mostly used in future references

 */

class UserDetails{
    

    var sender : String
    var imageurl : String
    var lastUpdate:Date?
    
    
    /*
     A simple constructor for the UserDetails class
     */
    
    init(insertsender: String, insertimageurl : String) {
        self.sender = insertsender
        self.imageurl = insertimageurl
   
    }
    
    /*
     A Json constructor for the Userdetails class
     */
    
    init(json:Dictionary<String,Any>){
   //     id = json["id"] as! String
        sender = json["sender"] as! String
        imageurl = json["imageurl"] as! String
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    /*
     A Json exporter for the Userdetails class
     */
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
      //  json["id"] = id
        json["sender"] = sender
        json["imageurl"] = imageurl
        json["lastUpdate"] = ServerValue.timestamp()
        return json
        
    }
}


