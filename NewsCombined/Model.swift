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

    //static let Student = ModelNotificationBase<Student>(name: "StudentNotificatio")
    
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
    /*
     func getAllStudentsAndObserve(){
     print("Model.getAllStudentsAndObserve")
     // get last update date from SQL
     let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Student.ST_TABLE)
     
     // get all updated records from firebase
     ModelFirebase.getAllStudentsAndObserve(lastUpdateDate, callback: { (students) in
     //update the local db
     print("got \(students.count) new records from FB")
     var lastUpdate:Date?
     for st in students{
     st.addStudentToLocalDb(database: self.modelSql?.database)
     s    if lastUpdate == nil{
     lastUpdate = st.lastUpdate
     }else{
     if lastUpdate!.compare(st.lastUpdate!) == ComparisonResult.orderedAscending{
     lastUpdate = st.lastUpdate
     }
     }
     }
     
     //upadte the last update table
     if (lastUpdate != nil){
     LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Student.ST_TABLE, lastUpdate: lastUpdate!)
     }
     
     //get the complete list from local DB
     let totalList = Student.getAllStudentsFromLocalDb(database: self.modelSql?.database)
     print("\(totalList)")
     
     ModelNotification.StudentList.post(data: totalList)
     })
     }*/
}

