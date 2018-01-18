//
//  CustomCellCluster.swift
//  NewsCombined
//
//  Created by admin on 18/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class CustomCellCluster: UITableViewCell {

    @IBOutlet var clusterImage: UIImageView!
    
    @IBOutlet var clusterLabel1: UILabel!
    
    
    @IBOutlet var commentsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
