//
//  CategoryTableViewController.swift
//  NewsCombined
//
//  Created by Adam Yablonka on 10/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SVProgressHUD




class ClustersPerCategoryTableViewController: UITableViewController, cellDelegat{
    
    
    
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet var messageTableView: UITableView!
    
    var observerId:Any?
    var type : String?
    var clusterArray : [Cluster] = [Cluster]()
    // var Clustertosend : Cluster?
    var chosenRow:Int=0
    //old: var model:NewsFirebase?
    var cellHeight : CGFloat = 0
    var currentCategory : String = "politics"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //old: model=NewsFirebase.instance
        refreshClusters(withChosenCategoty: currentCategory)
        sideMenus()
        messageTableView.register(UINib(nibName: "BlockCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureTableView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "Preview.jpg"))

        messageTableView.separatorStyle = .none
        
        
    }
    func refreshClusters(withChosenCategoty category: String){
        SVProgressHUD.show()
        navigationItem.title = category.capitalized
        ModelNotification.ClusterList.observe { (clusters) in
            if clusters != nil{
                if (!SVProgressHUD.isVisible()){
                    SVProgressHUD.show()
                }
                self.clusterArray = clusters!
                self.tableView.reloadData()
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
        Model.instance.getAllClustersAndObserve(category: category)
        
    }
    
    /*deinit{
     if (observerId != nil){
     ModelNotification.removeObserver(observer: observerId!)
     }
     }*/
    
    func didpressbutton(title: Any) {
        chosenRow = title as! Int
        let user = Model.instance.GetUser()
        if (user != nil)
        {
            performSegue(withIdentifier: "goToMessages", sender: self)
        }
        else{
            //goToWelcome
            performSegue(withIdentifier: "goToWelcome", sender: self)
        }
    }
    
    func sideMenus(){
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            alertButton.target = revealViewController()
            alertButton.action = #selector (SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clusterArray.count
    }
    
    
    /*
 
     ModelFileStore.getImage(urlStr: self.imageUrl!) { (data) in
     if (cell.avatarImageView.tag == indexPath.row){
     cell.avatarImageView.image = data
     }
     }
 */
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.clear
        let clus = clusterArray[indexPath.row]
        cell.setCluster(cluster: clus)
        cell.delegate = self
        cell.commentsBTN.tag = indexPath.row
        // cell.commentsBTN.addTarget(self, action: "btnTapped", for: .touchUpInside)
        cell.senderUsername.text = clusterArray[indexPath.row].clustertitle
        //cell.clusterTitle.sizeToFit()
        let urlKey = clusterArray[indexPath.row].clusterimgurl as! String
        cell.avatarImageView.tag = indexPath.row
        ModelFileStore.getImageNotInFirebase (urlStr: urlKey) { (data) in
            if (cell.avatarImageView.tag == indexPath.row){
                cell.avatarImageView.image = data
            }
        }
        
        cell.messageBody.isHidden = true
        cell.commentsBTN.setTitle("4 Comments", for: .normal)
        
        
        
        
        
        
        //cellHeight = cell.newsDescription.frame.size.height + cell.newsDescription.frame.origin.y + 50
        
        return cell
    }
    /*
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     return cellHeight
     }
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRow=indexPath.row
        performSegue(withIdentifier: "moveToSpecificClusterSegue", sender: self)
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
     override func tableView(_ tableVizbew: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier=="moveToSpecificClusterSegue"){
            let vc = segue.destination as! ArticlesInClusAndCatViewController
            vc.chosenCluster = clusterArray[chosenRow]
        }
        if (segue.identifier=="goToMessages"){
            let vc = segue.destination as! MessagesViewController
            vc.clusterToHold = clusterArray[chosenRow]
        }
        
        
        
        
    }
}
