//
//  ViewController.swift


import UIKit
import Firebase


/*
 This viewcontroller is charge of handling the Messages page and everything about it
 */

class MessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var clusterToHold : Cluster? //The cluster which is the topic of the chat
    var messagearray : [Message] = [Message]()
    var imageUrl:String?
    
    
    /*
      Outlets
     */
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.backgroundView = UIImageView(image: UIImage(named: "Preview.jpg"))
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        
        
        messageTextfield.delegate = self
        
        
        //AFTER WE RISED THE KEYBOARD(103) WE NEED EVENT TO KNOW WE TAPPED OUTSIDE OF IT TO MAKE KEAYBAORD DISSAPPEAR!!!
        //TABLEviewTapped is created in 77!!!!
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tableviewTapped))
        messageTableView.addGestureRecognizer(tapgesture)
        messageTableView.register(UINib(nibName: "BlockCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureTableView()
        retriveMessages()
        messageTableView.separatorStyle = .none
        messageTableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if messagearray[indexPath.row].sender == Model.instance.GetUser() {
            return true
        }
        else {
            return false
        }
    }
    
    
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if messagearray[indexPath.row].sender == Model.instance.GetUser()  {
        let ClusterId = (clusterToHold?.category)! + "_" + (clusterToHold?.topic)!
        let messageToDelete = messagearray [indexPath.row]
            Model.instance.deleteMessage(clusterId: ClusterId, insertMessage: messageToDelete, callback: { (res) in
            if (res == "Deleted")
            {
                //self.messagearray.remove(at: indexPath.row)
                //self.messageTableView.reloadData()
                }
            else {
                print("Failed to Delete")
                }
            })
        }
    }
    
    /*
     Alert to tell user if chat is empty for cluster
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
     Cell data integration
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.clear
        // cell.messageBackground.backgroundColor = UIColor.green
        cell.commentsBTN.isHidden = true
        cell.senderUsername.text = messagearray[indexPath.row].body
        cell.messageBody.text = messagearray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "no-photo-male")
        cell.avatarImageView.tag = indexPath.row
        Model.instance.getImgDetailsFromUser(insertUser: messagearray[indexPath.row].sender, callback: { (imgd) in
            if imgd != nil{
                self.imageUrl =   imgd?.imageurl
                ModelFileStore.getImage(urlStr: self.imageUrl!) { (data) in
                    if (cell.avatarImageView.tag == indexPath.row){
                        cell.avatarImageView.image = data
                    }
                }
                
                
            }
        })
       
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
    
    /*
     To activate send button in keybaord
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendButton.sendActions(for: .touchUpInside)
        return true
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase

    /*
     Sends message and saves it both locally and cloud FB
     */
    
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
                if self.messagearray.count == 0{
                    self.createalert(todo: "No_Comments", titletext: "No comments for this story", messageText: "Why not be the first one to comment on it?")
                }
                self.messageTableView.reloadData()
            }
        }
        
        
    }

}
