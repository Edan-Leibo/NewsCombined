//
//  LogInViewController.swift



//  This is the view controller where users login


import UIKit

class LogInViewController: UIViewController {
    
   
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
    
    /*
     Alert to tell user of sucsess
     */
    
    func createalert(todo: String, titletext: String, messageText : String)
    {
        let alert = UIAlertController(title: titletext, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if todo == "LogIn" {
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
     Function to perform log in
     */
   
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        
      Model.instance.Login(Email: emailTextfield.text!, Password: passwordTextfield.text!,callback: { (data) in
            if (data == "Email/Password combination Error")
            {
                self.errorTextLabelLogIn.text = data as String!
            }
            else {
                self.createalert(todo: "LogIn", titletext: "You have been successfully logged in!", messageText: "Returning to news page")
                
            }
        })
    }
}  
