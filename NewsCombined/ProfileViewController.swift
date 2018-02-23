//
//  ProfileViewController.swift
//  NewsCombined
//
//  Created by admin on 20/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//ProfileViewController

import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var FBunit:ModelFirebase? //LESHANOT!!!!!!
    var user: String?
    var imageUrl:String?
    var selectedImage:UIImage?
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
  
    /*
     @IBAction func backToNews(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FBunit == nil {
            FBunit = ModelFirebase ()
        }
        user = FBunit?.getuser() as String! //LESHANOT!!!
        userLabel.text = "Hello" + user!
        loadUserimage()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    /*
     Model.instance.addMessage(insertCluster: clusterToHold!, insertMessageBody: messageTextfield.text!) { (err) in
     if err == nil{
     print("ERROR WITH MESSAGES!!!!!")
     }
     }
     
     Model.instance.addImageDetails(insertImageDetails: userimagedetail,
 */
    
    
    @IBAction func saveBTN(_ sender: Any) {
        
        if let image = self.selectedImage{
            ModelFileStore.saveImage(image: image, name: user!){(url) in
                self.imageUrl = url
                let userimagedetail = ImageDetails (insertsender: self.user!, insertimageurl: self.imageUrl!)
                Model.instance.addImageDetails(insertImageDetails: userimagedetail)
            }
           
            }
      else{
            print ("No image")
        }
    }
    
    
    
    
    func loadUserimage()
    {
        FBunit?.getImgDetailsFromUser(user: user!, callback: { (imgd) in
            if imgd != nil{
                self.imageUrl =   imgd?.imageurl
                ModelFileStore.getImage(urlStr: self.imageUrl!) { (data) in
                    self.imageView.image = data
            }
           
           
            }
            else{
            
            }
        })
       
    }
    
    
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController,animated:true, completion: nil)
            }
            else {
                print ("No camera")
            }
        }))
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet,animated: true, completion: nil)
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

