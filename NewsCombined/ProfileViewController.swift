//
//  ProfileViewController.swift
//  NewsCombined


/*
 This viewcontroller is in charge of the the personal profile page of the user
 here, the user changes his profile picture and can log out of the program
 */

import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    /*
     Buttons had to be deleted/stopped so we needed the IBoutlets as well as actions
     */
    
    var user: String?
    var imageUrl:String?
    var selectedImage:UIImage?
    @IBOutlet weak var backNewsiBtn: UIBarButtonItem!
    @IBOutlet weak var saveBTN: UIButton!
    @IBOutlet weak var chooseImage: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBAction func backNewsiBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        user = Model.instance.GetUser()
        userLabel.text = "Hello " + user!
        loadUserimage()
        
    }
    
 
    
    /*
     Alert to inform of program execution like log out and image change
     */
    
    func createalert(todo: String, titletext: String, messageText : String)
    {
        let alert = UIAlertController(title: titletext, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if todo == "LogOut" {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Action for logging out the user
     */
    @IBAction func logOutBtn(_ sender: Any) {
        Model.instance.logoutFB()
        createalert(todo: "LogOut", titletext: "You have been successfully logged out!", messageText: "Returning to news page")
    }
    
    /*
       Action for saving user image
     */
    @IBAction func saveBTN(_ sender: Any) {
        SVProgressHUD.show()
        self.deActivateBTNs()
        if let image = self.selectedImage{
            ModelFileStore.saveImage(image: image, name: user!){(url) in
                self.imageUrl = url
                let userimagedetail = UserDetails (insertsender: self.user!, insertimageurl: self.imageUrl!)
                Model.instance.addUserDetails(insertImageDetails: userimagedetail, completionBlock: { (err) in
                    if (err != nil) {
                        self.errorLbl.text = "Error Updating Image"
                    }
                })
                self.reactivateBTNs()
                SVProgressHUD.dismiss(withDelay: 1)
                self.createalert(todo: "saveImage", titletext: "Image changed successfully!", messageText: "")
            }
        }
        else{
            errorLbl.text = "No New Photo Selected"
            self.reactivateBTNs()
            SVProgressHUD.dismiss(withDelay: 1)
            
        }
    }
    
    
    /*
     Save function takes a long time so we need to lock the buttons to prevent multiple I/O's
     */
    func deActivateBTNs(){
        backNewsiBtn.isEnabled = false
        saveBTN.isEnabled = false
        chooseImage.isEnabled = false
        logOutBtn.isEnabled = false
        
    }
    
    /*
     Reactivates the buttons after the save process ended
     */
    func reactivateBTNs(){
        backNewsiBtn.isEnabled = true
        saveBTN.isEnabled = true
        chooseImage.isEnabled = true
        logOutBtn.isEnabled = true
        
    }
    
    /*
     Loads the current image of user for display in viewcontroller
     */
    func loadUserimage()
    {
        Model.instance.getImgDetailsFromUser(insertUser: user!, callback: { (imgd) in
            if imgd != nil{
                self.imageUrl =   imgd?.imageurl
                ModelFileStore.getImage(urlStr: self.imageUrl!) { (data) in
                    self.imageView.image = data
                }
            }
        })
        
    }
    
    /*
     Action for loading the image with ImagePicker
     */
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController,animated:true, completion: nil)
            }
            else {
                self.errorLbl.text = "No camera"
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet,animated: true, completion: nil)
    }
    
    
    /*
         Event handler of image selected from picker
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = (info[UIImagePickerControllerOriginalImage] as! UIImage)
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

