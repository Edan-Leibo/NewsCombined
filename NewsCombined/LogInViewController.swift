//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit

class LogInViewController: UIViewController {
    
    var FBunit : ModelFirebase? = nil
    //Textfields 
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var errorTextLabelLogIn: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if FBunit == nil {
            FBunit = ModelFirebase ()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        
        //TODO: Log in the user
        
        let check : String = (FBunit?.LogInUser(Email: emailTextfield.text!, Password: passwordTextfield.text!))!
        
        if check == "Email/Password error" {
            self.errorTextLabelLogIn.text = check
        }
            
            
            
        else {
          //  print("Created new user")
            self.performSegue(withIdentifier: "goToNews", sender: self)
            
        }
        
    


    }
}  
