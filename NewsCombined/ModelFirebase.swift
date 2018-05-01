//

//  ModelFirebase.swift

/*
 This class is in charge of handling Firebase statements and functions of UserDetails and user related functions from Firebase
 */



import Foundation

import Firebase

import FirebaseDatabase


class ModelFirebase{
    
    var results : String = ""
    static let ref:DatabaseReference? = Database.database().reference()
    
    
    
    /////////// UserDetails ////////////
    
    
/*
 This function stores the user's details in the Firebase cloud under the UserDetails section - We do it so
 We can pull the image URL's of user photos while knowing to which users they belong to.
 */
    
    static func addUserDetails(insertImageDetails : UserDetails,  onCompletion:@escaping (Error?, UserDetails)->Void){
        var sender = "Guest"
        if (Auth.auth().currentUser != nil) {
            sender = (Auth.auth().currentUser?.email)!
        }
        let _ = sender
        let imageRef = ref?.child("UserDetails").childByAutoId()
        let jsonofdetails = insertImageDetails.toJson()
        imageRef?.setValue(jsonofdetails){(error, dbref) in
            onCompletion(error, insertImageDetails)
        }
    }
    
    /*
     Function to get the userDetails with the String of the username
     */
    
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
    
    
    /*
     Function to log out the user from the FB service
 */
    static func logoutFB()
    {
        do {
            try
                Auth.auth().signOut()
            
        } catch {
            print("Error signing out")
        }
        
    }
    
    /*
     Function to return the currently active user thats connected to the FB service
     */
    static func getuser () -> String?{
        return Auth.auth().currentUser?.email as String?
        
    }

    /*
     Function to log in the user to the FB service
     */
    
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
    
    /*
     Function to register in the user to the FB service
     */
    
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

