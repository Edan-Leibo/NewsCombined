//
//  RightMenuTableViewCell.swift
//  NewsCombined
//
//  Created by admin on 17/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

protocol RightMenuTableViewCellDelegate {
    func cellPressed(numOfRow:Int)
}

class RightMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    var delegate:RightMenuTableViewCellDelegate?
    var numOfCell:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        delegate?.cellPressed(numOfRow: numOfCell!)

        // Configure the view for the selected state
    }

}
