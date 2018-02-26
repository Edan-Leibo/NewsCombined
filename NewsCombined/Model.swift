//
//  Model.swift
//  NewsCombined
//
//  Created by admin on 21/02/2018.
//


import Foundation
import UIKit

class ModelNotificationBase<T>{
    var name:String?
    
    init(name:String){
        self.name = name
    }
    
    func observe(callback:@escaping (T?)->Void)->Any{
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(name!), object: nil, queue: nil) { (data) in
            if let data = data.userInfo?["data"] as? T {
                callback(data)
            }
        }
    }
    
    func post(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
}

class ModelNotification{
    static let ClusterList = ModelNotificationBase<[Cluster]>(name: "ClusterListNotification")
    static let ArticleList = ModelNotificationBase<[Article]>(name: "ArticleListNotification")
    static let MessageList = ModelNotificationBase<[Message]>(name: "MessageListNotification")
    static let ImgDetailsList = ModelNotificationBase<[UserDetails]>(name: "ImgDetailsList")
    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
    }
}

class Model{
    static let instance = Model()
    
    lazy private var modelSql:ModelSql? = ModelSql()
    
    private init(){
    }
    
    
    func getAllClustersAndObserve(category: String){
        
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Cluster.CL_TABLE)
        
        // get all updated records from firebase
        ModelFirebase.getAllClustersAndObserve(byCategory: category, lastUpdateDate: lastUpdateDate, callback: { (clusters) in
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
    
    func getAllArticlesInClusterAndObserve(cluster: Cluster){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Cluster.CL_TABLE)
        
        // get all updated records from firebase
        ModelFirebase.getAllArticlesInClusterAndObserve(byCluster: cluster, lastUpdateDate: lastUpdateDate, callback: { (articles) in
            
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
    
    
    
    func getAllMessagesAndObserve(cluster: Cluster){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Message.MSG_TABLE)
        
        // get all updated records from firebase
        ModelFirebase.getAllMessagesAndObserve(insertCluster: cluster, lastUpdateDate: lastUpdateDate, callback: { (messages) in
            
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
    
    func addMessage(insertCluster: Cluster, insertMessageBody: String, completionBlock: @escaping (Error?) -> Void){
        ModelFirebase.addMessage(insertCluster: insertCluster, insertMessageBody: insertMessageBody, onCompletion:{(err, msg) in
            msg.addMassageToLocalDb(database: self.modelSql?.database)
            completionBlock(err)
        })
    }
    func addUserDetails(insertImageDetails: UserDetails) {
        ModelFirebase.addUserDetails(insertImageDetails: insertImageDetails, onCompletion: { (err, imgDetail) in
           
        })
    }
    
    
     func getImgDetailsFromUser(insertUser:String, callback:@escaping (UserDetails?)->Void){
        ModelFirebase.getImgDetailsFromUser(user: insertUser) { (imgd) in
        callback(imgd)
        }
           
 
     }

    func deleteMessage(clusterId: String, insertMessage:Message, callback:@escaping (String?)->Void){
        Message.deleteMessageFromLocalDB(insertMessage: insertMessage, database: self.modelSql?.database)
        ModelFirebase.deleteMessage(ClusterId: clusterId, insertMessage: insertMessage) { (err) in
            if (err == nil) {
                callback ("Deleted")
            }
            else {
               callback ("Error removing Message")
            }
        }
        
    }

    
    
    
    
    ////////AUTH_FB/////////
    
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

