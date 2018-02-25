//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import Firebase


class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var logOutbtn: UIBarButtonItem!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var logInBtn: UIButton!
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
        
        
        var username = Model.instance.GetUser()
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
