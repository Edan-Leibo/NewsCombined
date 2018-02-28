//
//  ModelSql.swift
//  NewsCombined


/*
 This class is in charge of the base for all SQL actions in the program
 */

import Foundation

extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,
                                                  repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}


class ModelSql{
    var database: OpaquePointer? = nil
    
    init?(){
        /*
         DBFile location
         */
        
        let dbFileName = "database15.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return nil
            }
        }
        
        
        /*
         SQL lists containting program data
         */
        
        if Cluster.createTable(database: database) == false{
            return nil
        }
        if Article.createTable(database: database) == false{
            return nil
        }
        if Message.createTable(database: database) == false{
            return nil
        }
        
        if LastUpdateTable.createTable(database: database) == false{
            return nil
        }
    }
}
