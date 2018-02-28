//
//  NewsVC.swift
//  NewsCombined
//
//

import UIKit
import SVProgressHUD

class SpecificArticleViewController: UIViewController {

    var article:Article?
    var url : String = ""
    
    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        url = article!.url
        let urlToDisplay = URL(string: url)
        myWebView.loadRequest(URLRequest(url:urlToDisplay!))
        SVProgressHUD.dismiss()
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
