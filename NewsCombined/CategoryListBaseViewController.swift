//
//  CategoryListBaseViewController.swift
//  NewsCombined
//
//  Created by Adam Yablonka on 10/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class CategoryListBaseViewController: UINavigationController {
    var type:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! CategoryTableViewController
        dest.type = type
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
