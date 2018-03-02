//
//  NewsVC.swift
//  NewsCombined
//
//

/*
 Class in charge of displaying a specific article choosen in the program in a web browser
 */

import UIKit
import SVProgressHUD

class SpecificArticleViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    var article:Article?
    var url : String = ""
    var counter : Int = 0
    
    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage (named: "IMAGEPREVIEW_00000.jpg")
        myWebView.delegate = self as UIWebViewDelegate
     
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        url = article!.url
        let urlToDisplay = URL(string: url)
        myWebView.loadRequest(URLRequest(url:urlToDisplay!))
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Once page starts loading we want progresshud to show, seeing how the start
     loading appears more than once we wanted it to stop after first time with the counter
     */
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        if counter == 0 {
        SVProgressHUD.show()
        counter = 1
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        backgroundImage.isHidden = true
        SVProgressHUD.dismiss()
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
