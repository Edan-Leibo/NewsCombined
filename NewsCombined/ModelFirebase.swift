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
    static var ref:DatabaseReference?=Database.database().reference()
    
    init(){
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
    }
    
    ///////////////////// CLUSTERS ///////////////////////////////

    static func getAllClustersAndObserve(byCategory:String, lastUpdateDate:Date? , callback:@escaping ([Cluster])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var clusters = [Cluster]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let st = Cluster(fromJson: json)
                        clusters.append(st)
                    }
                }
            }
            callback(clusters)
        }
        
        let myRef = ref?.child("Clusters").child(byCategory)
        if (lastUpdateDate != nil){
            let fbQuery = myRef!.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(.value, with: handler)
        }else{
            myRef!.observe(.value, with: handler)
        }
    }
    
    ///////////////////// ARTICLES ///////////////////////////////

    static func getAllArticlesInClusterAndObserve(byCluster: Cluster, lastUpdateDate:Date? , callback:@escaping ([Article])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var articles = [Article]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let ar = Article(insertId: childData.key,fromJson: json)
                        if ar.clusterKey == byCluster.category+"_"+byCluster.topic
                        {
                            articles.append(ar)
                        }
                    }
                }
            }
            callback(articles)
        }
        
        //USE QUERYORDERED IN GET ALL ARTICLES-VERY HEAVY!!!!!!!!!!!!
        let myRef = ref?.child("Articles")
        if (lastUpdateDate != nil){
            let fbQuery = myRef!.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(.value, with: handler)
        }else{
            myRef!.observe(.value, with: handler)
        }
    }
    
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
        
        //USE QUERYORDERED IN GET ALL MESSAGES-VERY HEAVY!!!!!!!!!!!!
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
    
    /////////// IMAGEURL ////////////

    
    static func addImageDetails(insertImageDetails : ImageDetails,  onCompletion:@escaping (Error?, ImageDetails)->Void){
        var sender = "Guest"
        if (Auth.auth().currentUser != nil) {
            sender = (Auth.auth().currentUser?.email)!
        }
        print (sender)
        let imageRef = ref?.child("imageDetail").childByAutoId()
        var jsonofdetails = insertImageDetails.toJson()
        print (jsonofdetails)
        imageRef?.setValue(jsonofdetails){(error, dbref) in
            onCompletion(error, insertImageDetails)
        }
    }
    // ref.queryOrdered(byChild: "email").queryEqual(toValue: idtosearch)
    //orderByChild('email').equalTo('wal@aol.com')
    static func getImgDetailsFromUser(user:String, callback:@escaping (ImageDetails)->Void){
        let ref = Database.database().reference().child("imageDetail").queryOrdered(byChild: "sender").queryEqual(toValue: user)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let json = snapshot.value as? Dictionary<String,String>
            let st = ImageDetails(json: json!)
            callback(st)
        })
    }
    
    //ref.queryOrdered(byChild: "sender").queryEqual(toValue: user)
    
     func getImgDetailsFromUser(user:String, callback:@escaping (ImageDetails?)->Void){
        let ref = Database.database().reference().child("imageDetail").queryOrdered(byChild: "sender").queryEqual(toValue: user)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let json = snapshot.value as? Dictionary<String,Dictionary<String,Any>> {
                for (_,value) in json{
                let img = ImageDetails(json: value)
                callback(img)
            }
            }
            callback (nil)
        })
    }
    
    
    
    
    
    
    
    
    
   //////////// FIREBASE AUTH //////////////////
    
    func getuser () -> String?{
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
    func LogInUser(Email : String , Password : String, callback:@escaping (String)->Void)  {
        
        
        Auth.auth().signIn(withEmail: Email, password: Password, completion: { (user, error) in
            if error != nil {
                callback("Email/Password combination Error")
            }
            else {
                callback ("")
            }
            
        })
        
        
    }
    

    func RegisterUser(Email : String , Password : String, callback:@escaping (String)->Void){
        
        // self.results = ""
        Auth.auth().createUser(withEmail: Email, password: Password, completion: { (user, error) in
            if error != nil {
                callback("Email/Password Error Use An Email With A 6 letter Password")
            }
            else{
                callback("")
            }
            
        })
        
        
    }// Auth.auth().signIn(withEmail: Email, password: Password) { (user, error) in
    
    
    
    
}

