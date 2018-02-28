//
//  Message+firebase.swift
//  NewsCombined
//
//  Created by admin on 28/02/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import FirebaseDatabase

extension Message
{
    
    static func getAllMessagesAndObserve(reference:DatabaseReference?,insertCluster:Cluster, lastUpdateDate:Date?, callback:@escaping ([Message])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var messages = [Message]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let message = Message(json: json)
                        if message.categoryTopic == insertCluster.category+"_"+insertCluster.topic
                        {
                            messages.append(message)
                        }
                    }
                }
            }
            callback(messages)
        }
        
        let myRef = reference?.child("Messages").child(((insertCluster.category) + "_" + (insertCluster.topic)))
        if (lastUpdateDate != nil){
            let fbQuery = myRef!.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(.value, with: handler)
        }else{
            myRef!.observe(.value, with: handler)
        }
        
    }
    
    
    
    
    
    static func addMessageToFirebase(reference:DatabaseReference?,insertCluster : Cluster, insertMessageBody : String, onCompletion:@escaping (Error?, Message)->Void){
        var sender = "Guest"
        if (Auth.auth().currentUser != nil) {
            sender = (Auth.auth().currentUser?.email)!
        }
        let categoryTopic = ((insertCluster.category) + "_" + (insertCluster.topic))
        let messagesRef = reference?.child("Messages").child(categoryTopic).childByAutoId()
        let message = Message(insertId: (messagesRef?.key)!, insertSender: sender, insertBody: insertMessageBody, InsertCategotyTopic: categoryTopic)
        messagesRef?.setValue(message.toJson()){(error, dbref) in
            onCompletion(error, message)
        }
    }
    
    
    
    
    
    static func deleteMessageFromFirebase(reference:DatabaseReference?,ClusterId: String,insertMessage: Message, onCompletion:@escaping (Error?)->Void){
        Database.database().reference().child("Messages").child(ClusterId).child(insertMessage.id).removeValue(completionBlock: { (err, ref) in
            onCompletion(err)
        })
    }
    
    
}
