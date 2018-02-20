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
    
    let ref:DatabaseReference?
    
    var results : String = ""
    
    
    
    init(){
        
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        ref = Database.database().reference()
           
        
       
        
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
