//
//  ProfileViewController.swift
//  NewsCombined
//
//  Created by admin on 20/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //self.revealViewController().revealToggle(animated: true)


        // Do any additional setup after loading the view.
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