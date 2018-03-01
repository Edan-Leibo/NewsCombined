//
//  CustomMessageCell.swift
//  Flash Chat
//

/*
 This class is in charge of of the physical nib look thats displayed on screen throught the program depending
 on the instance buttons/layouts are hidden/activated
 */

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
        let tosend = commentsBTN.tag
        print(tosend)
        SVProgressHUD.dismiss(withDelay: 1)
        delegate?.didpressbutton(title: tosend)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
