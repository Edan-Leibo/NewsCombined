//
//  NewsArticleTableViewCell.swift
//  NewsCombined
//
//  Created by admin on 14/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class ClusterTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsHeadline: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
