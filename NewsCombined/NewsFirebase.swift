//

//  ModelFirebase.swift

//  SqliteDemo_6_12

//

//  Created by Eliav Menachi on 13/12/2017.

//  Copyright © 2017 menachi. All rights reserved.

//



import Foundation

import Firebase

import FirebaseDatabase


class NewsFirebase{
    let ref:DatabaseReference?
    var databaseHandle : DatabaseHandle?
    var Data : [Article] = [Article] ()
    var results : String = ""
    static let instance = NewsFirebase()
    
    
    
    init(){
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        ref = Database.database().reference()

    }
    
    
    //TO GET SINGLE ARTICLE!
    func getArticle(byId:String, callback: @escaping (Article?)->Void){
        let myRef = ref?.child("Articles").child(byId)
        myRef?.observeSingleEvent(of: .value, with: { (snapshot ) in
            if let val = snapshot.value as? [String:Any]{
                let arc = Article (fromJson: val)
                callback(arc)
            }else{
                callback(nil)
            }
        })
    }
    
    
    func getAllClustersInCategory(byCategory:String,callback:@escaping ([Cluster]?)->Void){
        let myRef = ref?.child("Clusters").child(byCategory)
        myRef?.observe(.value, with: { (snapshot) in
            var clusterArray = [Cluster]()
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snaps {
                    if let clusterDict = snap.value as? Dictionary<String,AnyObject> {
                        if let clusterCategory = clusterDict["category"] as? String {
                            print(clusterCategory)
                            if let clusterimg = clusterDict["clusterimgurl"] as? String{
                                print (clusterimg)
                                if let clustertitle = clusterDict["clustertitle"] as? String{
                                    print (clustertitle)
                                    if let clustertopic = clusterDict["topic"] as? String{
                                        print(clustertopic)
                                        let clus = Cluster(insertcategory: clusterCategory, inserttopic: clustertopic, insertclusterimg: clusterimg, insertclustertitle: clustertitle)
                                        clusterArray.append(clus)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                callback(clusterArray)
            }else{
                callback(nil)
            }
        })
    }
    
    
    //TO GET ALL ARTICLES FROM CLUSTER
    func getAllArticlesInCluster(byCluster: Cluster ,callback:@escaping ([Article]?)->Void){
        let profileRef = ref?.child("Articles")
        // profileRef?.queryOrdered(byChild: "clusterKey").queryEqual(toValue: "politics_11")
        profileRef?.observe( .value, with: { snapshot in
            if let values = snapshot.value as? [String:[String:Any]]{
                var articleArray = [Article]()
                for csJson in values{
                    let article = Article(fromJson: csJson.value)
                    if article.clusterKey == byCluster.category+"_"+byCluster.topic
                    {
                        articleArray.append(article)
                        
                    }
                }
                callback(articleArray)
            }else{
                callback(nil)
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func WriteDummyToDatabase() {
        let ClusterDB = ref?.child("Clusters")
        let ArticlesDB = ref?.child("Articles")
        
        var ClusterArray : [Cluster] = [Cluster]()
        var ArticleArray : [Article] = [Article]()
        let Cluster1 = Cluster (insertcategory: "politics", inserttopic: "11",insertclusterimg : "", insertclustertitle : "")
        let Cluster3 = Cluster (insertcategory: "politics", inserttopic: "2",insertclusterimg : "", insertclustertitle : "")
        let Cluster2 = Cluster  (insertcategory: "sport", inserttopic: "10",insertclusterimg : "", insertclustertitle : "")
        
        
        let article1 = Article (inserturl: "http://www.breitbart.com/big-government/2017/12/11/roy-moore-its-difficult-to-drain-the-swamp-when-youre-up-to-your-neck-in-alligators/", inserttitle: "Roy Moore: ‘It’s Difficult to Drain the Swamp When You’re Up to Your Neck in Alligators’", insertimageURL: "http://media.breitbart.com/media/2017/12/Roy-Moore-Rally-GETTY-IMAGES-NORTH-AMERICAAFPFile-JOE-RAEDLE-.jpg", insertdescription: "Republican Senate candidate Roy Moore vowed to drain the swamp if he is elected to office, making his final argument to win voters in Alabama on Monday night.", insertauthor: "Charlie Spiering", insertsource: "breitbart-news", insertpublishdate: "2017-12-11T19:04:40Z", insertcontent: "“It’s difficult to drain the swamp when you’re up to your neck in alligators,” he said after taking the stage.......", insertclusterkey : Cluster1.category+"_"+Cluster1.topic)
        
        
        let article11 = Article (inserturl: "http://www.breitbart.com/big-government/2017/12/11/roy-moore-vietnam-buddy-offers-moving-character-testimony-defends-political-vietcong-ambush/", inserttitle: "Roy Moore Vietnam Buddy Offers Moving Character Testimony, Defends Him from ‘Political Vietcong Ambush’", insertimageURL: "http://media.breitbart.com/media/2017/12/Bill-staehle-vietnam-vet-roy-moore-rally-youtube.jpg", insertdescription: "Bill Staehle, who served with Alabama Senate candidate Judge Roy Moore in Vietnam, stood onstage Monday night during a rally in Midland City, Alabama, delivering a rousing character testimony of his war buddy and defending him from what he saw as incoming political fire.", insertauthor: "Kristina Wong", insertsource: "breitbart-news", insertpublishdate: "2017-12-11T21:19:56Z", insertcontent: "“I looked into his eyes. Last time I had seen him he was wearing jungle fatigues,” he said. “And I tell you, people of Alabama, he’s the same guy",insertclusterkey : Cluster1.category+"_"+Cluster1.topic)
        
        
        let article2 = Article(inserturl: "http://espn.go.com/blog/boston/new-england-patriots/post/_/id/4809116/tom-brady-patriots-offense-out-of-rhythm-without-rob-gronkowski-in-loss", inserttitle: "Patriots, Tom Brady struggle without Gronk; on to Pittsburgh", insertimageURL: "http://a4.espncdn.com/combiner/i?img=%2Fphoto%2F2017%2F1211%2Fr301562_1296x729_16%2D9.jpg", insertdescription: "During a loss on Monday night to the Dolphins, the Patriots looked out of sync and vulnerable ahead of their showdown next week with the Steelers.", insertauthor: "Mike ReissESPN Staff Writer", insertsource: "espn", insertpublishdate: "2017-12-12T04:50:40Z", insertcontent: "AMI GARDENS, Fla. -- The New England Patriots have turned to the next man up and had continued success, which almost makes it a surprise when it doesn't happen.That's what unfolded Monday night in a 27-20 loss to the Miami Dolphins.",insertclusterkey : Cluster2.category+"_"+Cluster2.topic)
        
        
        ClusterArray.append(Cluster1)
        ClusterArray.append(Cluster2)
        ClusterArray.append(Cluster3)
        ArticleArray.append(article1)
        ArticleArray.append(article11)
        ArticleArray.append(article2)
        
        for Cluster in ClusterArray {
            ClusterDB?.child(Cluster.category).child(Cluster.topic).setValue(Cluster.toJson())
            {
                (error,ref) in
                
                if error != nil{
                    print(error)
                }
                else {
                    print("No Problem with saving Clusters")
                    
                }
            }
        }
        for Article in ArticleArray {
            ArticlesDB?.childByAutoId().setValue(Article.toJson())
            {
                (error,ref) in
                
                if error != nil{
                    print(error)
                }
                else {
                    print("No Problem with saving Clusters")
                    
                }
            }
        }
        
        
        
    }
    
    
    
}



