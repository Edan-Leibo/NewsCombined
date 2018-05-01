	//
//  CategoryTableViewController.swift
//  NewsCombined
//


import UIKit
import SVProgressHUD
import Firebase


/*
 This viewcontroller is charge of handling the Clusters page and everything about it
 */
class ClustersPerCategoryTableViewController: UITableViewController, cellDelegat{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet var messageTableView: UITableView!
    
    var observerId:Any?
    var type : String?
    var messagesCountArray : [MessagesCounter] = [MessagesCounter]()
    var topicArray : [String] = [String]()
    var clusterArray : [Cluster] = [Cluster]()
    // var Clustertosend : Cluster?
    var chosenRow:Int=0
    //old: var model:NewsFirebase?
    var cellHeight : CGFloat = 0
    var currentCategory : String = "politics"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //old: model=NewsFirebase.instance
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "IMAGEPREVIEW_00000.jpg"))
        refreshClusters(withChosenCategoty: currentCategory)
        sideMenus()
        messageTableView.register(UINib(nibName: "BlockCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureTableView()
        messageTableView.separatorStyle = .none
    }
    
    /*
     After category is picked and the process is instantiated to load a new set of clusters by sending notification
     to model
     */
    
    func refreshClusters(withChosenCategoty category: String){
        SVProgressHUD.show()
        navigationItem.title = category.capitalized
        let _ = ModelNotification.ClusterList.observe { (clusters) in
            if clusters != nil{
                if (!SVProgressHUD.isVisible()){
                    SVProgressHUD.show()
                }
                self.clusterArray = clusters!
                for clus in self.clusterArray {
                   var topicToAdd = clus.topic
                    self.topicArray.append(topicToAdd)
                }
               
                Model.instance.getMsgCounters(topicArray: self.topicArray, callback: { (msCounter) in
                    if msCounter != nil{
                    print(msCounter)
                    self.messagesCountArray = msCounter
                        self.tableView.reloadData()

                    }
                })
                self.tableView.reloadData()
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
        Model.instance.getAllClustersAndObserve(category: category)
        
    }
    
    
    /*
     Enters the comments section of the cluster - if a user is logged in goes to chat, else goes to register page
     Usses the protocol in the cell class
     */
    
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
    
    /*
     Section in charge of visually navigating between the side menus of right+left menu of SWreveal
     */
    
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
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clusterArray.count
    }
    
    
    
    
    
    
    /*
     Structures of the cell, first load it with no image than with the user image should one exist
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.clear
        let clus = clusterArray[indexPath.row]
        cell.setCluster(cluster: clus)
        cell.delegate = self
        cell.commentsBTN.tag = indexPath.row
        cell.avatarImageView.image = UIImage(named: "logo")
        cell.senderUsername.text = clusterArray[indexPath.row].clustertitle
        let urlKey = clusterArray[indexPath.row].clusterimgurl
        cell.avatarImageView.tag = indexPath.row
        ModelFileStore.getImageFromWeb (urlStr: urlKey) { (data) in
            if (cell.avatarImageView.tag == indexPath.row){
                cell.avatarImageView.image = data
            }
        }
        cell.messageBody.isHidden = true
        var topicNum = clusterArray[indexPath.row].topic
        var numOfComments = "0 Comments"
        for msgCount in messagesCountArray{
            if msgCount.topic == topicNum{
                numOfComments = msgCount.numOfComments + " Comments"
            }
        }
        
        cell.commentsBTN.setTitle(numOfComments, for: .normal)
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
