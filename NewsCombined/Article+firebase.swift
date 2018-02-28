//
//  Article+firebase.swift
//  NewsCombined
//
//  Created by admin on 28/02/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

extension Article{
    static func getAllArticlesInClusterAndObserve(reference:DatabaseReference?, byCluster: Cluster, lastUpdateDate:Date? , callback:@escaping ([Article])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var articles = [Article]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let ar = Article(insertId: childData.key,fromJson: json)
                        if ar.clusterKey == byCluster.category+"_"+byCluster.topic
                        {
                            articles.append(ar)
                        }
                    }
                }
            }
            callback(articles)
        }
        
        let myRef = reference?.child("Articles")
        if (lastUpdateDate != nil){
            let fbQuery = myRef!.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(.value, with: handler)
        }else{
            myRef!.observe(.value, with: handler)
        }
    }
}
