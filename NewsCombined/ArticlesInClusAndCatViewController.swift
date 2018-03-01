//
//  ArticleTVC.swift
//  NewsCombined
//


import UIKit
import SVProgressHUD



/*
 This viewcontroller is charge of handling the Articles page and everything about it
 */

class ArticlesInClusAndCatViewController: UITableViewController {
    
    var chosenRow: Int?
    var chosenCluster : Cluster?
    var allArticles : [Article] = [Article]()
    //   var cellHeight : CGFloat = 0
    
    @IBOutlet var messageTablieView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "Preview.jpg"))
      SVProgressHUD.show()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        messageTablieView.register(UINib(nibName: "BlockCell", bundle: nil), forCellReuseIdentifier: "customCell")
        messageTablieView.separatorStyle = .none
        ModelNotification.ArticleList.observe { (articleArr) in
            if let aritcleArray = articleArr{
                if (!SVProgressHUD.isVisible()){
                    SVProgressHUD.show()
                }
                self.allArticles = aritcleArray
                self.tableView.reloadData()
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }

                
        Model.instance.getAllArticlesInClusterAndObserve(cluster: chosenCluster!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allArticles.count
    }
    
    /*
     Section in charge of visually navigating between the side menus of right+left menu of SWreveal
     */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.clear
        cell.commentsBTN.isHidden = true
        cell.senderUsername.text = allArticles[indexPath.row].title
        cell.avatarImageView.image = UIImage(named: "logo")

        
        let urlKey = allArticles[indexPath.row].imageURL
        cell.avatarImageView.tag = indexPath.row
        ModelFileStore.getImageFromWeb (urlStr: urlKey) { (data) in
            if (cell.avatarImageView.tag == indexPath.row){
                cell.avatarImageView.image = data
            }
        }
        
        cell.messageBody.text = allArticles[indexPath.row].description
        return cell
    }
    

    /*
     Goes to the article in the web browser using the URL in the article cell choosen
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenRow = indexPath.row
        performSegue(withIdentifier: "moveToSpecificArticleSegue", sender: self)
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier=="moveToSpecificArticleSegue"){
            let vc = segue.destination as! SpecificArticleViewController
            vc.article = allArticles[chosenRow!]
            //vc.chosenRow = chosenRow
        }
    }
    
    
    //DESIGN FUNCTIONS FOR CELLS!
    func configureTableView(){
        messageTablieView.rowHeight = UITableViewAutomaticDimension
        messageTablieView.estimatedRowHeight = 120
        
    }
    
    
}

