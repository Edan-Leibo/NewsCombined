//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD
class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func badinput(error : String)
    {
        errorLabel.text = error
        
    }

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        SVProgressHUD.show()
     
        //This func is after register button was pressed, first 2 params are simple, in completion press enter and enter (user,error) - completion is closure style func explained in 176!!!!
        FIRAuth.auth()?.createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
            if error != nil {
                self.badinput(error : "Invalid Email input")
                
            }
            else {
                print("Registration is good")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
        })
        

        
        
    } 
    
    
}
