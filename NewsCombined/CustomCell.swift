//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol cellDelegat {
    func didpressbutton (title: Any)
}

class CustomCell: UITableViewCell {

    var Clusteritem: Cluster!
    var delegate: cellDelegat?
    
    func setCluster(cluster:Cluster){
        Clusteritem = cluster
        Clusteritem.category = cluster.category
        Clusteritem.clusterimgurl = cluster.clusterimgurl
        Clusteritem.clustertitle = cluster.clustertitle
        Clusteritem.topic = cluster.topic

    }

    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    @IBOutlet weak var commentsBTN: UIButton!
    @IBAction func btnPressed(_ sender: Any) {
        SVProgressHUD.show()
        var tosend = commentsBTN.tag
        print(tosend)
        SVProgressHUD.dismiss(withDelay: 1)
        delegate?.didpressbutton(title: tosend)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
