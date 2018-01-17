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
    
    init(insertsender : String, insertbody: String) {
        self.sender = insertsender
        self.body = insertbody
    }
}
