//
//  Articlecell.swift
//  NewsCombined
//
//  Created by Himani Patel on 1/14/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class Articlecell: UITableViewCell {

    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var article_description: UILabel!
    @IBOutlet weak var article_title: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
