//
//  SaveImageViewModel.swift
//  Picture It
//
//  Created by Syed ShahRukh Haider on 08/08/2019.
//  Copyright © 2019 Ash Tech. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase

class SaveImageViewModel{

    func SaveImageViewModel(collectionID :String, Title : String, selectedImage : UIImage, completion: @escaping (_ uploadImageUrl: String?,_ Status : Bool,_ errorMsg : String?)->()){
    
//
//    print(Title)
//    print(selectedImage)
//    print(Auth.auth().currentUser?.uid)
    
    let storage  = Storage.storage()
    let storageRef = storage.reference()
    
    
    
    var imageData = Data()
    
    let uploadMetadata = StorageMetadata()
    uploadMetadata.contentType = "image/jpeg"
    
    imageData = selectedImage.jpegData(compressionQuality: 0.7)!
    
    // ******* Create Image Reference ************
    let uploadImageRef = storageRef.child(collectionID).child(Title)
    
    //  upload the image file to respective path
    
   uploadImageRef.putData(imageData, metadata: uploadMetadata) { (metaData, err) in
        
        if err  != nil{
            
            completion(nil, false, err?.localizedDescription)
        }
    
        else{
            uploadImageRef.downloadURL(completion: { (downloadUrl, downlodError) in
                
        
                if downlodError == nil{
                completion(downloadUrl?.absoluteString,true,nil)
            }
                else{
                     completion(nil, false, err?.localizedDescription)
                }
                
                
            })
        }
    }
    
    
    
}
}
