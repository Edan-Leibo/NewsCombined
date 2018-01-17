//
//  CategoryTableViewController.swift
//  NewsCombined
//
//  Created by Adam Yablonka on 10/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class ClustersPerCategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet var messageTableView: UITableView!
    
    var type : String?
    var clusterArray : [Cluster] = [Cluster]()
    var chosenRow:Int=0
    var model:NewsFirebase?
    var cellHeight : CGFloat = 0
    var currentCategory : String = "politics"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model=NewsFirebase.instance
        refreshClusters(withChosenCategoty: currentCategory)
        sideMenus()
        messageTableView.register(UINib(nibName: "BlockCell", bundle: nil), forCellReuseIdentifier: "customCell")
       configureTableView()
        
        messageTableView.separatorStyle = .none
        model=NewsFirebase.instance

        navigationItem.title = currentCategory
        //self.tableView.tableFooterView = UIView()
        model!.getAllClustersInCategory(byCategory: currentCategory, callback: { (allClusters) in
            if let clusterArr = allClusters{
                //print(clusterArr)
                self.clusterArray = clusterArr
                self.tableView.reloadData()
            }
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func refreshClusters(withChosenCategoty category: String){
        navigationItem.title = category.capitalized
        //self.tableView.tableFooterView = UIView()
        model!.getAllClustersInCategory(byCategory: category, callback: { (allClusters) in
            if let clusterArr = allClusters{
                self.clusterArray = clusterArr
                self.tableView.reloadData()
            }
        })
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        /*
        //Getting the image
        //set the image URL
        let imageUrl = URL(string: arrayNewsCluster[indexPath.row].clusterimgurl)!
        //create a URL Session, this time a shared one since its a simple app
        let session = URLSession.shared
        //then create a URL data task since we are getting simple data
        let task = session.dataTask(with:imageUrl) { (data, response, error) in
            if error == nil {
                //incase of success, get the data and pass it to the UIImage class
                let downloadedImage = UIImage(data: data!)
                //then we run the UI updating on the main thread.
                DispatchQueue.main.async {
                    //cell.newsImage.image = downloadedImage
                }
            }
        }
        //then start the task or resume it
        task.resume()
        
*/
        
        
        // Configure the cell...
        //cell.newsHeadline.numberOfLines = 0
        cell.senderUsername.text = clusterArray[indexPath.row].clustertitle
        //cell.clusterTitle.sizeToFit()
       let urlKey = clusterArray[indexPath.row].clusterimgurl
        if let url = URL(string: urlKey){
            
            do {
                let data = try Data(contentsOf: url)
                 cell.avatarImageView.image = UIImage(data: data)
                
            }catch let err {
                print(" Error : \(err.localizedDescription)")
            }
            
            
        }
        
        
  
  
        
        
        cell.messageBody.text = "21"
        
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
    }
    

    

}
