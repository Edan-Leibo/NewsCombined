//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit


class RegisterViewController: UIViewController {

    
    
    var FBunit : ModelFirebase? = nil
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var errorTextLabelRegister: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FBunit == nil {
            FBunit = ModelFirebase ()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        let check : String = (FBunit?.RegisterUser(Email: emailTextfield.text!, Password: passwordTextfield.text!))!
        
        if check == "Email/Password error" {
                self.errorTextLabelRegister.text = check
        }
            

            
            else {
                //print("Created new user")
             //   self.performSegue(withIdentifier: "goToNewsCombined", sender: self)
                 self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
    
        
        

        
        
    } 
    
    
}
