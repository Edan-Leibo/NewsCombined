//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
//Lesson 180
class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    
    // 184 creating the array for all the realtime messages!!!!
    var messagearray : [Message] = [Message]()
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self  //HAVE TO SET WHO IS IN CHARGE OF THE DATA AND DELEGATE!!!! Delegate = Whenever something happens in the table view it knows to send info to the messageTableView!!!!!!
        messageTableView.dataSource = self
        self.configureTableView()
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //AFTER WE RISED THE KEYBOARD(103) WE NEED EVENT TO KNOW WE TAPPED OUTSIDE OF IT TO MAKE KEAYBAORD DISSAPPEAR!!!
        //TABLEviewTapped is created in 77!!!!
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tableviewTapped))

        
        messageTableView.addGestureRecognizer(tapgesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        retriveMessages()
        
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
      
        
        cell.messageBody.text = messagearray[indexPath.row].body
        cell.senderUsername.text = messagearray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text ==  FIRAuth.auth()?.currentUser?.email as String! { //TO CHECK IF MESSAGE IS FROM USER OR SOMEBODY ELSE!!!
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }
        
        else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagearray.count; //THIS IS FOR NUMBER OF VARS IN THE ARRAY
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableviewTapped(){
    messageTextfield.endEditing(true)
    
    }
    
    
    //TODO: Declare configureTableView here:
    
    //THIS IS TO SET CORRECT SIZE FOR CELLS!!!!!
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
 
    
    
    //THIS IS TO RISE THE KEYBOARD IN ANIMATED STYLE
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant=308
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant=50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true) //STOP ALLOWING ENTERING TEXT and repeadetly pressing Send!!!!!
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = FIRDatabase.database().reference().child("Messages")
        let messageDictionary = ["sender": FIRAuth.auth()?.currentUser?.email, "MessageBody" : messageTextfield.text]
        
        //TODO: Send the message to Firebase and save it in our database
        messagesDB.childByAutoId().setValue(messageDictionary) { //creating auto id for each message!!!!
            (error,ref) in
            
            if error != nil{
                print(error)
            }
            else {
                print("No Problem with saving message")
                self.messageTextfield.isEnabled = true
                self.messageTextfield.text = ""
                self.sendButton.isEnabled = true
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retriveMessages()
    {
        var messageDB = FIRDatabase.database().reference().child("Messages") //Needs to be identical to 138 so its going to the right DB!!!!
        messageDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as!Dictionary <String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue ["sender"]!
            
            let message = Message (insertsender : sender,insertbody : text)
            self.messagearray.append(message)
            
            self.configureTableView() //AFTER SENDING NEW MESSAGE WE NEED TO RESIZE SCREEN
            self.messageTableView.reloadData()
        })
        
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try
           FIRAuth.auth()?.signOut()

        } catch {
            print("Error signing out")
        }
        //This returns to the very first page of navigation controller
       guard (navigationController?.popToRootViewController(animated: true)) != nil
        else {
            print("This is first nav screen")
            return
        }
    }


    

    
}
