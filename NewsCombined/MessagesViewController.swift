//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


class MessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var clusterToHold : Cluster?
    var messagearray : [Message] = [Message]()
    
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.backgroundView = UIImageView(image: UIImage(named: "Preview.jpg"))
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //AFTER WE RISED THE KEYBOARD(103) WE NEED EVENT TO KNOW WE TAPPED OUTSIDE OF IT TO MAKE KEAYBAORD DISSAPPEAR!!!
        //TABLEviewTapped is created in 77!!!!
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tableviewTapped))
        
        
        messageTableView.addGestureRecognizer(tapgesture)
        
        
        
        
        
        //TODO: Register your Cell.xib file here:
        messageTableView.register(UINib(nibName: "BlockCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureTableView()
        //  tableView.backgroundView = UIImageView(image: UIImage(named: "Preview.jpg"))
        
        retriveMessages()
        
        messageTableView.separatorStyle = .none
       
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.clear
        // cell.messageBackground.backgroundColor = UIColor.green
        cell.commentsBTN.isHidden = true
        cell.senderUsername.text = messagearray[indexPath.row].body
        cell.messageBody.text = messagearray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "NewsLogoBetter")
        
        
        if cell.messageBody.text ==  Model.instance.GetUser() { //TO CHECK IF MESSAGE IS FROM USER OR SOMEBODY ELSE!!!
            
            
            cell.messageBackground.backgroundColor = UIColor.cyan
            
        }
        else {
            
            cell.messageBackground.backgroundColor = UIColor.green
            
        }
        
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagearray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableviewTapped(){
        messageTextfield.endEditing(true)
        
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    
    
    //TODO: Declare textFieldDidBeginEditing here:
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
        Model.instance.addMessage(insertCluster: clusterToHold!, insertMessageBody: messageTextfield.text!) { (err) in
            if err == nil{
                print("ERROR WITH MESSAGES!!!!!")
            }
        }
        self.messageTextfield.isEnabled = true
        self.messageTextfield.text = ""
        self.sendButton.isEnabled = true
    }
    
    
    //TODO: Create the retrieveMessages method here:
    func retriveMessages()
    {
        Model.instance.getAllMessagesAndObserve(cluster: clusterToHold!)
        ////////////////////////////
        ModelNotification.MessageList.observe { (list) in
            if let messagessARR = list{
                self.messagearray = messagessARR
                self.configureTableView() //AFTER SENDING NEW MESSAGE WE NEED TO RESIZE SCREEN
                self.messageTableView.reloadData()
            }
        }
        
        
    }
    
    
    
    
    
    
    /*
     @IBAction func logOutPressed(_ sender: AnyObject) {
     let firebaseAuth = Auth.auth()
     do {
     try firebaseAuth.signOut()
     } catch let signOutError as NSError {
     print ("Error signing out: %@", signOutError)
     }
     guard (navigationController?.popToRootViewController(animated: true)) != nil
     else {
     print("This is first nav screen")
     return
     
     
     
     }
     
     }
     
     */
}
