//
//  LeftMenuTableViewController.swift
//  NewsCombined
//


/*
 This viewcontroller is in charge of the left menu of the SWReveal - in charge of picking category
 */

import UIKit

class LeftMenuTableViewController: UITableViewController, LeftMenuTableViewCellDelegate {
    func cellPressed(numOfRow: Int) {
        selectedRow=numOfRow
    }
    
    let NUM_OF_CATEGORIES=8
    let CATEGORIES = ["general", "politics","sport", "business","science-and-nature", "technology", "entertainment", "gaming"]
    var LeftMenuArray=[String]()
    var selectedRow:Int?
    
    
    /*
     Each category is delegated to a cell - picking one will change the current viewcontroller of clusterspercategory
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        LeftMenuArray=["General News","Politics","Sport", "Business","Science", "Technology", "Entertainment", "Gaming"]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return LeftMenuArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTableViewCell", for: indexPath) as! LeftMenuTableViewCell

        // Configure the cell...
        cell.delegate=self
        cell.numOfCell=indexPath.row
        cell.textLabel?.text=LeftMenuArray[indexPath.row]
        
        return cell
    }
    

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //super.tableView(tableView, didSelectRowAt: indexPath)
        //performSegue(withIdentifier: "updateClusterSegue, sender: self)
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destNavVC=segue.destination as! UINavigationController
        let clustersVC = destNavVC.topViewController as! ClustersPerCategoryTableViewController
        clustersVC.currentCategory = CATEGORIES[selectedRow!]
        dismiss(animated: false, completion: nil)
        //destVC.currentCategory=CATEGORIES[selectedRow!]
    }
    

}
