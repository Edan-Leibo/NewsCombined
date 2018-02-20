//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import Firebase


class WelcomeViewController: UIViewController {
    var FBunit:ModelFirebase?

    
   
    
    @IBOutlet weak var frontLabel: UILabel!
    
    @IBAction func hideButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try
                Auth.auth().signOut()
            
        } catch {
            print("Error signing out")
        }
        self.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if FBunit == nil {
            FBunit = ModelFirebase ()
        }
        
        var username = FBunit?.getuser()
        if username != nil {
            frontLabel.text = "Hello " + username!
            
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}
