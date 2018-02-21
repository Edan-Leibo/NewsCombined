//
//  Cluster+sql.swift
//  NewsCombined
//
//  Created by admin on 20/02/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

extension Cluster{
    static let CL_TABLE = "CLUSTERS"
    static let CL_ID = "CL_ID"
    static let CL_TITLE = "CL_TITLE"
    static let CL_IMAGE_URL = "CL_IMAGE_URL"
    static let CL_LAST_UPDATE = "CL_LAST_UPDATE"
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + CL_TABLE + " ( "
            + CL_ID + " TEXT PRIMARY KEY, "
            + CL_TITLE + " TEXT, "
            + CL_IMAGE_URL + " TEXT, "
            + CL_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addClusterToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Cluster.CL_TABLE
            + "(" + Cluster.CL_ID + ","
            + Cluster.CL_TITLE + ","
            + Cluster.CL_IMAGE_URL + ","
            + Cluster.CL_LAST_UPDATE + ") VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let dbID = self.category+"_"+self.topic
            
            let id = dbID.cString(using: .utf8)
            let title = self.clustertitle.cString(using: .utf8)
            var imageUrl = "".cString(using: .utf8)
            //if self.clusterimgurl != nil {
                imageUrl = self.clusterimgurl.cString(using: .utf8)
            //}
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, imageUrl,-1,nil);
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 4, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllClustersFromLocalDb(insertCategory: String, database:OpaquePointer?)->[Cluster]{
        var clusters = [Cluster]()
        var sqlite3_stmt: OpaquePointer? = nil

        if (sqlite3_prepare_v2(database,"SELECT * from " + CL_TABLE + " WHERE "+Cluster.CL_ID + " LIKE '" + insertCategory+"%';",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let id =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let title =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let imageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,3))
                //print("read from filter st: \(stId) \(name) \(imageUrl)")
                //if (imageUrl != nil && imageUrl == ""){
                //    imageUrl = nil
                //}
                let idArr = id?.components(separatedBy: "_")
                
                let cluster = Cluster(insertcategory: idArr![0], inserttopic: idArr![1], insertclusterimg: imageUrl!, insertclustertitle: title!)
                cluster.lastUpdate = Date.fromFirebase(update)
                clusters.append(cluster)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return clusters
    }
    
}
