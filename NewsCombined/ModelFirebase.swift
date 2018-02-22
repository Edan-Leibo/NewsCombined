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
    
    
    
    
    
    func getuser () -> String?{
        print(Auth.auth().currentUser?.email as String?)
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
    
    func LogInUser(Email : String , Password : String) ->String {
        
        self.results = ""
        checkLoggedIn()
        Auth.auth().signIn(withEmail: Email, password: Password, completion: { (user, error) in
            if error != nil {
                self.results = "Email/Password error"
            }
            
        })
        return self.results
        
    }
    
    
    
    
    func RegisterUser(Email : String , Password : String) ->String {
        
        self.results = ""
        Auth.auth().createUser(withEmail: Email, password: Password, completion: { (user, error) in
            if error != nil {
                self.results = "Email/Password error"
            }
            
        })
        return self.results
        
    }// Auth.auth().signIn(withEmail: Email, password: Password) { (user, error) in
    
    
    
    
    
}

