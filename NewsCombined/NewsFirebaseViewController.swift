//
//  NewsFirebaseViewController.swift
//  NewsCombined
//
//  Created by admin on 14/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class NewsFirebaseViewController: UIViewController {
    
    var NewsFBunit : NewsFirebase? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NewsFBunit == nil {
            NewsFBunit = NewsFirebase.init()
        }
        
        
        
        
        //To Get all Clusters in category
        NewsFBunit?.getAllClustersInCategory(byCategory: "politics", callback: { (data) in
            for cs in data! {
                print(cs.topic)
                
            }
        })
        
        
        
        
        
        //To Get 1 article with ID
       /*
        NewsFBunit?.getArticle(byId: "-L2u7HWTWwZGIhcrg69n", callback: { (article) in
            if let check = article {
                print(article!.author)
                
            }
            else {
                print(article?.author)
            }
        })
        */
        
        
        /*
        
        //THIS IS TO GET ALL ARTICLES IN CLUSTER
        let testo : Cluster = Cluster (insertcategory: "politics", inserttopic: "11", insertclusterimg: "", insertclustertitle: "")
        NewsFBunit?.getAllArticlesInCluster(byCluster: testo, callback: { (data) in
            for cs in data! {
                print(cs.author)
                
            }
        })
        
        */
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


