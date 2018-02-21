//
//  NewsCluster.swift
//  NewsCombined
//
//  Created by admin on 05/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import UIKit

class NewsCluster {
   
    var title : String = ""
    var commentcount : Int = 0
    var logo : UIImage!
    
    init(title:String,commentcount:Int,logo:UIImage) {
        
        self.title = title
        self.commentcount = commentcount
        self.logo = logo
    }
}

class NewsArticle {
    
    var title : String = ""
    var description : String = ""
    var logo : UIImage!
    
    init(title:String,description:String,logo:UIImage) {
        
        self.title = title
        self.description = description
        self.logo = logo
    }
}

