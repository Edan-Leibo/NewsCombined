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
    
    
    
    /////////// UserDetails ////////////
    
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
        return Auth.auth().currentUser?.email as String?
        
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

