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
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        
      Model.instance.Login(Email: emailTextfield.text!, Password: passwordTextfield.text!,callback: { (data) in
            if (data == "Email/Password combination Error")
            {
                self.errorTextLabelLogIn.text = data as String!
            }
            else {
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
            }
        })
        
        
        
        
        
        
        
    }
}  
