//
//  editProfileVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 07/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class editProfileVC: UIViewController {

    
    //********* OUTLET
    
    @IBOutlet weak var displayImage : Custom_ImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func changeImageButtonAction(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        let alertAction = UIAlertController(title: "Select Image Source", message: "Which Image source you want to use ?", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Gallery", style: .default) { (action) in
            
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
                   
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)

               }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertAction.addAction(library)
        alertAction.addAction(camera)
        alertAction.addAction(cancel)
        
        self.present(alertAction, animated: true, completion: nil)
        
        
    }

    @IBAction func backButtonAction(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
     
      }

}


extension editProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.displayImage.image = selectedImage
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
