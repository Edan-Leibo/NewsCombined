//
//  ArticleTVC.swift
//  NewsCombined
//
//  Created by Himani Patel on 1/14/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class ArticlesInClusAndCatViewController: UITableViewController {

    var chosenRow: Int?
    var chosenCluster : Cluster?
    var allArticles : [Article] = [Article]()
    var model:NewsFirebase?
    var cellHeight : CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        model=NewsFirebase.instance
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //self.tableView.tableFooterView = UIView()
        
        
        //self.type = CATEGORIES[selected_Catedories]
        
        //self.tableView.tableFooterView = UIView()
        
        model!.getAllArticlesInCluster(byCluster: chosenCluster!, callback: { (articleArr) in
                if let aritcleArray = articleArr{
                    self.allArticles = aritcleArray
                    self.tableView.reloadData()
                }
        })

        //arrayNewsArticle.append(NewsArticle(title: "BCC Headlines1", description: "BCC Article 1",logo:#imageLiteral(resourceName: "bcc")))
        //arrayNewsArticle.append(NewsArticle(title: "BCC Headlines2", description: "BCC Article 2", logo: #imageLiteral(resourceName: "cnn")))
         //print(chosenRow)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allArticles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        // Configure the cell...

        cell.articleTitle.text = allArticles[indexPath.row].title
        //cell.article_title.sizeToFit()
        //Get the image
        //cell.logo.image = allArticles[indexPath.row].clusterimgurl
        cell.articleImage.image=#imageLiteral(resourceName: "NewsCombinedLogo")
        cell.articleDescription.text = allArticles[indexPath.row].description
        //cell.article_description.sizeToFit()
        return cell
    }
    
    /*
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenRow = indexPath.row
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsVC") as! NewsVC
        performSegue(withIdentifier: "moveToSpecificArticleSegue", sender: self)
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
    

}
