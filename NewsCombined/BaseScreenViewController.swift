//
//  NewsClustersViewController.swift
//  NewsCombined
//
//  Created by admin on 13/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

let NUM_OF_CATEGORIES=8
let CATEGORIES = ["general","sport", "business", "entertainment", "science", "tech", "music", "gaming"]
//var selected_Catedories = 0
class BaseScreenViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var generalButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var businessButton: UIButton!
    @IBOutlet weak var entertainmentButton: UIButton!
    @IBOutlet weak var scienceButton: UIButton!
    @IBOutlet weak var techButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var gamingButton: UIButton!
    
    var childControllers = [BaseNavigationViewController]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instansiate all view controllers
        for i in 0...CATEGORIES.count-1{
            let navViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryListBaseViewController") as! BaseNavigationViewController
                navViewController.type = CATEGORIES[i]
            navViewController.view.frame = viewContainer.frame
            navViewController.view.frame.origin = CGPoint(x:0, y:0)
            addChildViewController(navViewController)
            childControllers.append(navViewController)

        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generalButtonPressed(_ sender: UIButton) {
        
       //selected_Catedories = 0
       viewContainer.addSubview((childControllers[0].view)!)
        
    }
    
    @IBAction func sportButtonPressed(_ sender: UIButton) {
        //selected_Catedories = 1
        viewContainer.addSubview((childControllers[1].view)!)
    }
    
    @IBAction func businessButtonPressed(_ sender: UIButton) {
        //selected_Catedories = 2
        viewContainer.addSubview((childControllers[2].view)!)
    }
    
    @IBAction func entertainmentButtonPressed(_ sender: UIButton) {
        //selected_Catedories = 3
        viewContainer.addSubview((childControllers[3].view)!)
    }
    
    @IBAction func scienceButtonPressed(_ sender: UIButton) {
        //selected_Catedories = 4
        viewContainer.addSubview((childControllers[4].view)!)
    }
    
    @IBAction func techButtonPressed(_ sender: UIButton) {
        //selected_Catedories = 5
        viewContainer.addSubview((childControllers[5].view)!)
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        //selected_Catedories = 6
        viewContainer.addSubview((childControllers[6].view)!)
    }
    
    @IBAction func gamingButtonPressed(_ sender: UIButton) {
        //selected_Catedories = 7
        viewContainer.addSubview((childControllers[7].view)!)
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
