//
//  Model.swift
//  NewsCombined
//
//  Created by admin on 21/02/2018.
//


import Foundation
import UIKit


/*
 This is the notification unit, it is alerted thanks to the observe func' posts data to the observable thanks to the post func
 */


class ModelNotificationBase<T>{
    var name:String?
    
    init(name:String){
        self.name = name
    }
    
    /*
     Can observe for article,cluster,message and Userdetails - we fill this in the viewcontroller demanding the data
     */
    
    func observe(callback:@escaping (T?)->Void)->Any{
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(name!), object: nil, queue: nil) { (data) in
            if let data = data.userInfo?["data"] as? T {
                callback(data)
            }
        }
    }
    /*
     Sends the data back to the viewcontroller demanding the data
     */
    func post(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
}

/*
 The different options for the observables
 */

class ModelNotification{
    static let ClusterList = ModelNotificationBase<[Cluster]>(name: "ClusterListNotification")
    static let ArticleList = ModelNotificationBase<[Article]>(name: "ArticleListNotification")
    static let MessageList = ModelNotificationBase<[Message]>(name: "MessageListNotification")
    static let ImgDetailsList = ModelNotificationBase<[UserDetails]>(name: "ImgDetailsList")
    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
    }
}

/*
 This class is the "heart of the program" instead of every view controller having a firebase import and communicates with the local memory the Model
 does it for him with notifications,local memory instances, firebase instances etc' etc'
 */


class Model{
    static let instance = Model()
    lazy private var modelSql:ModelSql? = ModelSql()
    private var modelFirebase:ModelFirebase? = ModelFirebase()
    
    /*
     Gets all the clusters - from firebase and locally and observes for changes while checking the last update
     */
    
    func getAllClustersAndObserve(category: String){
        
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Cluster.CL_TABLE)
        
        // get all updated records from firebase
        Cluster.getAllClustersAndObserve(reference: ModelFirebase.ref, byCategory: category, lastUpdateDate: lastUpdateDate, callback: { (clusters) in
            //update the local db
            var lastUpdate:Date?
            for cl in clusters{
                cl.addClusterToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = cl.lastUpdate
                }else{
                    if lastUpdate!.compare(cl.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = cl.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Cluster.CL_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Cluster.getAllClustersFromLocalDb(insertCategory: category, database: self.modelSql?.database)
            
            ModelNotification.ClusterList.post(data: totalList)
        })
    }
    
    /*
     Gets all the articles - from firebase and locally and observes for changes while checking the last update
     */
    
    func getAllArticlesInClusterAndObserve(cluster: Cluster){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Cluster.CL_TABLE)
        
        // get all updated records from firebase
        Article.getAllArticlesInClusterAndObserve(reference: ModelFirebase.ref, byCluster: cluster, lastUpdateDate: lastUpdateDate, callback: { (articles) in
            
            //update the local db
            var lastUpdate:Date?
            for ar in articles{
                ar.addArticleToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = ar.lastUpdate
                }else{
                    if lastUpdate!.compare(ar.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = ar.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Article.ART_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Article.getAllArticlesFromLocalDb(insertCluster: cluster, database: self.modelSql?.database)
            
            //return the list to the caller
            ModelNotification.ArticleList.post(data: totalList)
        })
    }
    
    /*
     Gets all the messages - from firebase and locally and observes for changes while checking the last update
     */
    
    func getAllMessagesAndObserve(cluster: Cluster){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Message.MSG_TABLE)
        
        // get all updated records from firebase
        Message.getAllMessagesAndObserve(reference: ModelFirebase.ref, insertCluster: cluster, lastUpdateDate: lastUpdateDate, callback: { (messages) in
            
            //update the local db
            var lastUpdate:Date?
            for msg in messages{
                msg.addMassageToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = msg.lastUpdate
                }else{
                    if lastUpdate!.compare(msg.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = msg.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Article.ART_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Message.getAllMassagesFromLocalDb(insertCluster: cluster, database: self.modelSql?.database)
            
            //return the list to the caller
            ModelNotification.MessageList.post(data: totalList)
        })
    }
    
    /*
     Adds amessage - to firebase and locally
     */
    
    func addMessage(insertCluster: Cluster, insertMessageBody: String, completionBlock: @escaping (Error?) -> Void){
        Message.addMessageToFirebase(reference: ModelFirebase.ref, insertCluster: insertCluster, insertMessageBody: insertMessageBody, onCompletion:{(err, msg) in
            msg.addMassageToLocalDb(database: self.modelSql?.database)
            completionBlock(err)
        })
    }
    
    /*
     Adds a user member - to firebase only (wouldnt wanna take precious cache for something that doesnt have anything to do with the personal user)
     */
    
    func addUserDetails(insertImageDetails: UserDetails, completionBlock: @escaping (Error?) -> Void) {
        ModelFirebase.addUserDetails(insertImageDetails: insertImageDetails, onCompletion: { (err, imgDetail) in
            completionBlock(err)
        })
    }
    
    /*
     Gets the image from the imageurl datamember of user details and saves it locally
     */
    
    func getImgDetailsFromUser(insertUser:String, callback:@escaping (UserDetails?)->Void){
        ModelFirebase.getImgDetailsFromUser(user: insertUser) { (imgd) in
            callback(imgd)
        }
        
    }
    
    /*
    Deletes message both locally and cloud
     */
    
    func deleteMessage(clusterId: String, insertMessage:Message, callback:@escaping (String?)->Void){
        Message.deleteMessageFromLocalDB(insertMessage: insertMessage, database: self.modelSql?.database)
        Message.deleteMessageFromFirebase(reference: ModelFirebase.ref, ClusterId: clusterId, insertMessage: insertMessage) { (err) in
            if (err == nil) {
                callback ("Deleted")
            }
            else {
                callback ("Error removing Message")
            }
        }
        
    }
    
    func getMsgCounters(topicArray: [String], callback:@escaping ([MessagesCounter]?)->Void){
        MessagesCounter.getMessagesCounter(topicArray: topicArray) { (msCounter) in
            if (msCounter != nil) {
                callback(msCounter!)
                
            }
            else {
                callback(nil)
                
            }
            
        }
    }
    
    
    
    
    
    ////////AUTH_FB/////////
    
    /*
     All functions related to the authentication part of Firebase - all are self explenatory
     */
    
    func logoutFB() {
        ModelFirebase.logoutFB()
    }
    
    func GetUser() -> String? {
        return ModelFirebase.getuser()
    }
    
    func RegisterUser(Email : String , Password : String, callback:@escaping (String)->Void){
        ModelFirebase.RegisterUser(Email: Email, Password: Password) { (res) in
            callback(res)
        }
    }
    
    func Login(Email : String , Password : String, callback:@escaping (String)->Void){
        ModelFirebase.LogInUser(Email: Email, Password: Password) { (res) in
            callback(res)
        }
    }

}

