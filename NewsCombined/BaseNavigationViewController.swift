//
//  CategoryListBaseViewController.swift
//  NewsCombined
//


/*
 This class is a requierment for the SWreveal to function and load (its the initial screen)
 */

import UIKit

class BaseNavigationViewController: UINavigationController {
    var type:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let topVC = topViewController as! ClustersPerCategoryTableViewController
        topVC.type=self.type
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let dest = segue.destination as! CategoryTableViewController
        //dest.type = type
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    

}
