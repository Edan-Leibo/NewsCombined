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


class ModelFirebase{
    
    var results : String = ""
    static let ref:DatabaseReference? = Database.database().reference()
    
    /*init(){
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
    }*/
    
    
    ///////////////////// MESSAGES ///////////////////////////////
    
    static func getAllMessagesAndObserve(insertCluster:Cluster, lastUpdateDate:Date?, callback:@escaping ([Message])->Void){
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
        
        let myRef = ref?.child("Messages").child(((insertCluster.category) + "_" + (insertCluster.topic)))
        if (lastUpdateDate != nil){
            let fbQuery = myRef!.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(.value, with: handler)
        }else{
            myRef!.observe(.value, with: handler)
        }
        
    }
    
    
    
    
    
    static func addMessage(insertCluster : Cluster, insertMessageBody : String, onCompletion:@escaping (Error?, Message)->Void){
        var sender = "Guest"
        if (Auth.auth().currentUser != nil) {
            sender = (Auth.auth().currentUser?.email)!
        }
        let categoryTopic = ((insertCluster.category) + "_" + (insertCluster.topic))
        let messagesRef = ref?.child("Messages").child(categoryTopic).childByAutoId()
        let message = Message(insertId: (messagesRef?.key)!, insertSender: sender, insertBody: insertMessageBody, InsertCategotyTopic: categoryTopic)
        messagesRef?.setValue(message.toJson()){(error, dbref) in
            onCompletion(error, message)
        }
    }
    
    
    
    
    
    static func deleteMessage(ClusterId: String,insertMessage: Message, onCompletion:@escaping (Error?)->Void){
        
        
        Database.database().reference().child("Messages").child(ClusterId).child(insertMessage.id).removeValue(completionBlock: { (err, ref) in
            onCompletion(err)
        })
    }
    
    
    
   
    
    /////////// IMAGEURL ////////////

    
    static func addUserDetails(insertImageDetails : UserDetails,  onCompletion:@escaping (Error?, UserDetails)->Void){
        var sender = "Guest"
        if (Auth.auth().currentUser != nil) {
            sender = (Auth.auth().currentUser?.email)!
        }
        print (sender)
        let imageRef = ref?.child("UserDetails").childByAutoId()
        let jsonofdetails = insertImageDetails.toJson()
        print (jsonofdetails)
        imageRef?.setValue(jsonofdetails){(error, dbref) in
            onCompletion(error, insertImageDetails)
        }
    }
    // ref.queryOrdered(byChild: "email").queryEqual(toValue: idtosearch)
    //orderByChild('email').equalTo('wal@aol.com')
    static func getImgDetailsFromUser(user:String, callback:@escaping (UserDetails?)->Void){
        let ref = Database.database().reference().child("UserDetails").queryOrdered(byChild: "sender").queryEqual(toValue: user)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let json = snapshot.value as? Dictionary<String,Dictionary<String,Any>> {
                for (_,value) in json{
                    let img = UserDetails(json: value)
                    callback(img)
                }
            }
            callback (nil)
        })
    }
    

    
    
    
    
   //////////// FIREBASE AUTH //////////////////
    
    static func logoutFB()
    {
        do {
            try
                Auth.auth().signOut()
            
        } catch {
            print("Error signing out")
        }
        
    }
    
    
    static func getuser () -> String?{
        //print(Auth.auth().currentUser?.email as String?)
        return Auth.auth().currentUser?.email as String?
        
    }
    
 
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
            } else {
                // No user is signed in.
                
            }
        }
    }
   
    
    static func LogInUser(Email : String , Password : String, callback:@escaping (String)->Void)  {
        
        
        Auth.auth().signIn(withEmail: Email, password: Password, completion: { (user, error) in
            if error != nil {
                callback("Email/Password combination Error")
            }
            else {
                callback ("")
            }
            
        })
        
        
    }
    
    
    
    
   static func RegisterUser(Email : String , Password : String, callback:@escaping (String)->Void){
        
        // self.results = ""
        Auth.auth().createUser(withEmail: Email, password: Password, completion: { (user, error) in
            if error != nil {
                callback("Email/Password Error Use An Email With A 6 letter Password")
            }
            else{
                callback("")
            }
            
        })
        
        
    }
    
    
    
    
    
    
}

