//
//  WelcomeViewController.swift

//
//  This is the welcome view controller - the first thign the user sees when tries to connect to system
//

import UIKit
import Firebase


class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var logOutbtn: UIBarButtonItem!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var logInBtn: UIButton!
    
    /*
     Alert to let user know log out was finished
     */
    func createalert(todo: String, titletext: String, messageText : String)
    {
        let alert = UIAlertController(title: titletext, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if todo == "LogOut" {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Page varies between loged users and un logged users
     */
    
    @IBOutlet weak var frontLabel: UILabel!
    
    @IBAction func hideButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        Model.instance.logoutFB()
        createalert(todo: "LogOut", titletext: "You have been successfully logged out!", messageText: "Returning to news page")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let username = Model.instance.GetUser()
        if username != nil {
            frontLabel.text = "Hello " + username!
            registerBtn.isHidden = true
            logInBtn.isHidden = true
        }
        else {
            logOutbtn.isEnabled = false
            logOutbtn.tintColor = UIColor.clear
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
