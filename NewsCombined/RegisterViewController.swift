//
//  RegisterViewController.swift

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
    
    /*
     Alert to tell user of sucsess
     */
    
    func createalert(todo: String, titletext: String, messageText : String)
    {
        let alert = UIAlertController(title: titletext, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if todo == "Register" {
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Function to perform Register
     */
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        Model.instance.RegisterUser(Email: emailTextfield.text!, Password: passwordTextfield.text!,callback: { (data) in
            if (data == "Email/Password Error Use An Email With A 6 letter Password")
            {
                self.errorTextLabelRegister.text = data as String!
            }
            else {
                self.createalert(todo: "Register", titletext: "You have been successfully registered,welcome to NewsCombined!", messageText: "Returning to news page")

            }
        })
        
    } 
    
    
}
