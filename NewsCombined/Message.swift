//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

class Message {
    
    //TODO: Messages need a messageBody and a sender variable
    //sender and body
    
    var sender : String = ""
    var body : String = ""
    var id : String = ""
    
    init(insertsender : String, insertbody: String,insertID: String) {
        self.sender = insertsender
        self.body = insertbody
        self.id = insertID
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["MessageBody"] = body
        json["sender"] = sender
        json["id"] = id
        
        return json
    }
}

