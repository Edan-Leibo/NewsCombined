//
//  NewsVC.swift
//  NewsCombined
//
//  Created by Himani Patel on 1/14/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SVProgressHUD

class SpecificArticleViewController: UIViewController {

    var article:Article?
    var url : String = ""
    //var chosenRow : Int = 0
    
    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        SVProgressHUD.show()

        super.viewDidLoad()
        
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        url = article!.url
        var urltodisplay = URL(string: url)
        SVProgressHUD.dismiss()
        myWebView.loadRequest(URLRequest(url:urltodisplay!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
