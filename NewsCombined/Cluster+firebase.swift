//
//  Cluster+firebase.swift
//  NewsCombined
//
//  Created by admin on 28/02/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

extension Cluster{
    static func getAllClustersAndObserve(reference:DatabaseReference?, byCategory:String, lastUpdateDate:Date? , callback:@escaping ([Cluster])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var clusters = [Cluster]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let st = Cluster(fromJson: json)
                        clusters.append(st)
                    }
                }
            }
            callback(clusters)
        }
        
        let myRef = reference?.child("Clusters").child(byCategory)
        if (lastUpdateDate != nil){
            let fbQuery = myRef!.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(.value, with: handler)
        }else{
            myRef!.observe(.value, with: handler)
        }
    }
}
