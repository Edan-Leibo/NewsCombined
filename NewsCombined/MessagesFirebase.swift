//
//  MessagesFirebase.swift
//  NewsCombined
//
//  Created by admin on 20/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

//

//  ModelFirebase.swift

//  SqliteDemo_6_12

//

//  Created by Eliav Menachi on 13/12/2017.

//  Copyright © 2017 menachi. All rights reserved.

//



import Foundation

import Firebase

import FirebaseDatabase





class MessagesFirebase{
    
    let ref:DatabaseReference?
    
    var results : Message?
    
    
    init(){
        
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        
        ref = Database.database().reference()
        
        
        
        
    }
    

   
    
    func saveMessage(insertCluster : Cluster, messageTextfield : UITextField) {
        
        var sender = "Guest"
        if (Auth.auth().currentUser != nil) {
            sender = (Auth.auth().currentUser?.email)!
        }
        let messagesDB = ref?.child("Messages").child(((insertCluster.category) + "_" + (insertCluster.topic)))
        let messageDictionary = ["sender": sender, "MessageBody" : messageTextfield.text] as [String : Any]
        
        
        //TODO: Send the message to Firebase and save it in our database
         messagesDB?.childByAutoId().setValue(messageDictionary) { //creating auto id for each message!!!
            (error,ref) in
            
            if error != nil{
                print(error)
            }
            else {
                print("No Problem with saving message")
             
            }
        }
        
    }
    
    
    func retriveMessages(insertCluster:Cluster,callback:@escaping ([Message]?)->Void){
        let myRef = ref?.child("Messages").child(((insertCluster.category) + "_" + (insertCluster.topic)))
        myRef?.observe(.value, with: { (snapshot) in
            var messageArray = [Message]()
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snaps {
                    let MessageID = snap.key;
                    print(MessageID)
                    if let clusterDict = snap.value as? Dictionary<String,AnyObject> {
                        if let sender = clusterDict["sender"] as? String {
                            print(sender)
                            if let MessageBody = clusterDict["MessageBody"] as? String{
                                print (MessageBody)
                                let msg = Message(insertsender: sender, insertbody: MessageBody,insertID:MessageID)
                                messageArray.append(msg)
                              
                            }
                            
                        }
                    }
                }
                callback(messageArray)
            }else{
                callback(nil)
            }
        })
    }
    
    
            
            /*
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue ["sender"]!
 
            let message = Message (insertsender : sender,insertbody : text)
             */
      
   

    
    
}




 

