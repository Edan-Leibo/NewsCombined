//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit


class RegisterViewController: UIViewController {

    
    
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var errorTextLabelRegister: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        //RegisterUser(Email: emailTextfield.text!, Password: passwordTextfield.text!, completion: (res), in
        Model.instance.RegisterUser(Email: emailTextfield.text!, Password: passwordTextfield.text!,callback: { (data) in
            if (data == "Email/Password Error Use An Email With A 6 letter Password")
            {
                self.errorTextLabelRegister.text = data as String!
            }
            else {
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
            }
        })
        
    } 
    
    
}
