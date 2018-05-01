//
//  Message+firebase.swift
//  NewsCombined


/*
 This class is the Message Firebase class and all its data members - in charge of handling all firebase related tasks
 */

import Foundation

import Foundation
import Firebase
import FirebaseDatabase

extension CommentCounter
{
    
    
    /*
     for topic in topicArray{
     if messageCount.topic == topic{
     messageCounts.append(messageCount)
     }
     
     }
 */
    
    
    static func getAllMessagesCounterAndObserve(reference:DatabaseReference?,topicArray: [String], callback:@escaping ([CommentCounter])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var messageCounts = [CommentCounter]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let messageCount = CommentCounter(json: json)
                        for topic in topicArray{
                            if messageCount.topic == topic{
                                messageCounts.append(messageCount)
                            }
                            
                        }
                    }
                }
            }
            print(messageCounts)
            callback(messageCounts)
        }
        
       
        
    }
    
    
    
    
}

