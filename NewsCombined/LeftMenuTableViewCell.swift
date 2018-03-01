//
//  LeftMenuTableViewCell.swift
//  NewsCombined


/*
 The cell structure of the left menu of the SWreveal (categories)
 */

import UIKit

protocol LeftMenuTableViewCellDelegate {
    func cellPressed(numOfRow:Int)
}

class LeftMenuTableViewCell: UITableViewCell {
    
    var delegate:LeftMenuTableViewCellDelegate?
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
