//
//  CategoryTableViewController.swift
//  NewsCombined
//
//  Created by Adam Yablonka on 10/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class ClustersPerCategoryTableViewController: UITableViewController {
    
    var type : String?
    var arrayNewsCluster : [Cluster] = [Cluster]()
    var chosenRow:Int?
    var model:NewsFirebase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model=NewsFirebase.instance
        //self.type = CATEGORIES[selected_Catedories]
        
        navigationItem.title = self.type
        self.tableView.tableFooterView = UIView()
        model!.getAllClustersInCategory(byCategory: type!, callback: { (allClusters) in
            if let clusterArr = allClusters{
                self.arrayNewsCluster = clusterArr
            }
        })
        //tableView.reloadData()
        //arrayNewsCluster.append(NewsCluster(title: "BCC Headlines", commentcount: 5,logo:#imageLiteral(resourceName: "bcc")))
        //arrayNewsCluster.append(NewsCluster(title: "CNN Healines", commentcount: 10, logo: #imageLiteral(resourceName: "cnn")))
        
        //print("/(type)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

        return arrayNewsCluster.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsArticleTableViewCell", for: indexPath) as! ClusterTableViewCell
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
        cell.newsHeadline.text = arrayNewsCluster[indexPath.row].clustertitle
        cell.newsDescription.numberOfLines = 0
        cell.newsImage.image=#imageLiteral(resourceName: "NewsCombinedLogo")
        cell.newsDescription.text = "2"//"\(arrayNewsCluster[indexPath.row].commentcount)"
        cell.newsDescription.sizeToFit()
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 107
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRow=indexPath.row
        performSegue(withIdentifier: "moveToSpecificClusterSegue", sender: self)
    
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleTVC") as! ArticleTVC
        //vc.type = arynewsCluster[indexPath.row].title
        //vc.tappedRow = indexPath.row
        //self.navigationController?.pushViewController(vc, animated: true)
        
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
            vc.type = self.title
            vc.chosenRow = chosenRow!
        }
    }
    
    func downloadImage(url: URL) {
        
    }
    

}
