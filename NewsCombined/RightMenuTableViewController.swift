//
//  RightMenuTableViewController.swift
//  NewsCombined
//


import UIKit
import SVProgressHUD


/*
 This class is in charge of the right menu of the SWT - allows acsess to profile and welcome page
 
 */

class RightMenuTableViewController: UITableViewController {
  
    @IBOutlet weak var userName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        NotificationCenter.default.addObserver(self, selector: #selector(RightMenuTableViewController.functionName), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
 Function not used saved for Final project
 */
    
    @objc func functionName() {
        
        let name = Model.instance.GetUser()
        if (name != nil) {
            userName.text = name
            
        }
        else{
            userName.text = "Guest"
        }
        
    }
    
    
    /*
 Main functionallity of viewcontroller - acsess to profile page and welcome page - varies between
     logged and un logged users
 */

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch indexPath.row {
        case 0:
            let user = Model.instance.GetUser()
            if (user != nil)
            {
                SVProgressHUD.show()
            self.revealViewController().revealToggle(animated: true)
            performSegue(withIdentifier: "toProfile", sender: self)
             self.revealViewController().revealToggle(animated: true)
             SVProgressHUD.dismiss(withDelay: 1)
            break
            }
            else{
                SVProgressHUD.show()
                self.revealViewController().revealToggle(animated: true)
                performSegue(withIdentifier: "GoToWelcome", sender: self)
                self.revealViewController().revealToggle(animated: true)
                SVProgressHUD.dismiss(withDelay: 1)
                break
            }
        
        /*
        case 2:
            performSegue(withIdentifier: "toSettings", sender: self)
            break
       */
        case 1:
            SVProgressHUD.show()
            self.revealViewController().revealToggle(animated: true)
            performSegue(withIdentifier: "GoToWelcome", sender: self)
            self.revealViewController().revealToggle(animated: true)
            SVProgressHUD.dismiss(withDelay: 1)
            break
            
            
            
        default:
            break
            //GoToWelcome
        }
        
            
    }
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //    self.revealViewController().revealToggle(animated: true)
        
    //}
    

}
