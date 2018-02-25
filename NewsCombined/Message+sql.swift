//
//  Message+sql.swift
//  NewsCombined
//
//  Created by admin on 22/02/2018.
//

import Foundation

extension Message{
    static let MSG_TABLE = "MESSAGES"
    static let MSG_ID = "MSG_ID"
    static let MSG_SENDER = "MSG_SENDER"
    static let MSG_BODY = "MSG_BODY"
    static let MSG_CATEGORY_TOPIC = "MSG_CATEGORY_TOPIC"
    static let MSG_LAST_UPDATE = "MSG_LAST_UPDATE"
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + MSG_TABLE + " ( " + MSG_ID + " TEXT PRIMARY KEY, "
            + MSG_SENDER + " TEXT, "
            + MSG_BODY + " TEXT, "
            + MSG_CATEGORY_TOPIC + " TEXT, "
            + MSG_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addMassageToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Message.MSG_TABLE
            + "(" + Message.MSG_ID + ","
            + Message.MSG_SENDER + ","
            + Message.MSG_BODY + ","
            + Message.MSG_CATEGORY_TOPIC + ","
            + Message.MSG_LAST_UPDATE + ") VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            
            let id = self.id.cString(using: .utf8)
            let sender = self.sender.cString(using: .utf8)
            let body = self.body.cString(using: .utf8)
            let categoryTopic = self.categoryTopic.cString(using: .utf8)
            
            
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, sender,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, body,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, categoryTopic,-1,nil);
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 5, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllMassagesFromLocalDb(insertCluster:Cluster, database:OpaquePointer?)->[Message]{
        var messages = [Message]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from "+MSG_TABLE+" WHERE " + MSG_CATEGORY_TOPIC + " = '" + insertCluster.category+"_"+insertCluster.topic+"';",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let id =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let sender =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let body =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let categoryTopic = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,4))
                let message = Message(insertId: id!, insertSender : sender!, insertBody: body!, InsertCategotyTopic: categoryTopic!)
                
                message.lastUpdate = Date.fromFirebase(update)
                messages.append(message)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return messages
    }
    
    /*
     DELETE FROM employees
     WHERE last_name = 'Smith';
 */
    
    
    static func deleteMessageFromLocalDB(insertId:String, database:OpaquePointer?){
        //var messages = [Message]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"DELETE FROM"+MSG_TABLE+" WHERE " + MSG_ID + " = '" + insertId + "';",-1,&sqlite3_stmt,nil) == SQLITE_OK){
          print("Message" + insertId + " Deleted")
        }
        sqlite3_finalize(sqlite3_stmt)
    
    }
    
    
}
