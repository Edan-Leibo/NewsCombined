//
//  MessagesCounter+firebase.swift
//  NewsCombined
//
//  Created by admin on 01/05/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

/*
 var messageDB = Database.database().reference().child("MessagesCounter")
 messageDB.observe(.childAdded, with: { (snapshot) in
 let snapshotValue = snapshot.value as!Dictionary <String,String>
 
 let topic = snapshotValue["topic"]!
 let numOfComments = snapshotValue ["numOfComments"]!
 
 let message = MessagesCounter(insertTopic: topic, insertNumOfComments: numOfComments)
 self.messagesCountArray.append(message)
 
 self.configureTableView() //AFTER SENDING NEW MESSAGE WE NEED TO RESIZE SCREEN
 })
 */


extension MessagesCounter{
    
    /*
     Gets all Clusters from Firebase class
     */
    static func getMessagesCounter(topicArray: [String],callback:@escaping ([MessagesCounter]?)->Void){
        var ref = Database.database().reference()
        let myRef = ref.child("MessagesCounter")
        myRef.observe(.value, with: { (snapshot) in
            if let values = snapshot.value as? [String:[String:Any]]{
                var counterArray = [MessagesCounter]()
                for msCounterJson in values{
                    let messageCount = MessagesCounter(json: msCounterJson.value)
                    for topic in topicArray{
                        if topic==messageCount.topic{ counterArray.append(messageCount)
                        }
                        
                    }
                    
                }
                callback(counterArray)
            }else{
                callback(nil)
            }
        })
    }
    
    /*
    static func getSpecificMessagesCounterAndUpdate(topic: String,callback:@escaping (MessagesCounter?)->Void){
        var ref = Database.database().reference()
        let myRef = ref.child("MessagesCounter")
        myRef.observe(.value, with: { (snapshot) in
            if let values = snapshot.value as? [String:[String:Any]]{
                var counter = MessagesCounter()
                for msCounterJson in values{
                    let messageCount = MessagesCounter(json: msCounterJson.value)
                    if messageCount.topic == topic {
                        counter = messageCount
                    }
                }
                callback(counter)
            }else{
                callback(nil)
            }
        })
    }
 */
    
    static func getSpecificMessageCounter(bytopic:String, callback: @escaping (MessagesCounter?)->Void){
         var ref = Database.database().reference()
        let myRef = ref.child("MessagesCounter").child(bytopic)
        myRef.observeSingleEvent(of: .value, with: { (snapshot ) in
            if let val = snapshot.value as? [String:Any]{
                let msgCounter = MessagesCounter (json: val)
                callback(msgCounter)
            }else{
                callback(nil)
            }
        })
    }
   
    
    
    func updateAfterAdditionOrDeletion (messageCounter:MessagesCounter, newOrAdditionOrSubtraction:String)
    {
        
        var ref = Database.database().reference()
        let myRef = ref.child("MessagesCounter").child(messageCounter.topic)
        if (newOrAdditionOrSubtraction == "New"){
        myRef.setValue(messageCounter.toJson())
            
        }
        if(newOrAdditionOrSubtraction == "Add"){
            let oldnumber:Int? = Int(messageCounter.numOfComments)
            var newnumber = oldnumber!+1
            var numberToAdd = String(newnumber)
            messageCounter.numOfComments = numberToAdd
            myRef.setValue(messageCounter.toJson())
        }
        
        //NOT GOOD
        if(newOrAdditionOrSubtraction == "Subtract"){
            let oldnumber:Int? = Int(messageCounter.numOfComments)
            var newnumber = oldnumber!-1
            var numberToAdd = String(newnumber)
            messageCounter.numOfComments = numberToAdd
            myRef.setValue(messageCounter.toJson())
        
    }
    
    
    
}

}
    

