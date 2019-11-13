//
//  SignInVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 01/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import Firebase

let globalVariable = UIApplication.shared.delegate as! AppDelegate

class SignInVC: UIViewController {
    
    
    let saveImageVM = SaveImageViewModel()
    var dpImage : UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.fetchSnapUserInfo { (userEntity, userError) in
                           
                           if let userEntity = userEntity{
                               
                               DispatchQueue.main.async {
                                   
                                   self.goToLoginConfirm(userEntity)

                               }
                           }
                       } 

    }
    
    
    
    
    //*********** Personalize Function ***********
    
    
    // request UserInfo to SnapSDK.
    // If you haven't requested yet, it will jump to the SnapChat app and get auth.
    
    private func fetchSnapUserInfo(_ completion: @escaping ((UserEntity?, Error?) -> ())){
          let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
          
          SCSDKLoginClient
              .fetchUserData(
                  withQuery: graphQLQuery,
                  variables: nil,
                  success: { userInfo in
                      
                      if let userInfo = userInfo,
                          let data = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
                          let userEntity = try? JSONDecoder().decode(UserEntity.self, from: data) {
                          completion(userEntity, nil)
                      }
              }) { (error, isUserLoggedOut) in
                  completion(nil, error)
          }
      }
    
    
    
    // go to next ViewController
    private func goToLoginConfirm(_ entity: UserEntity){
        
        
//        globalVariable.userSnapDetail = entity
       
        //********** CREATE NEW USER NODE *******
        
        
        let dbStore = Firestore.firestore()

        
        dbStore.collection("Users").whereField("displayName", isEqualTo: (entity.displayName)!).addSnapshotListener { (snap, err) in
            
            let name = entity.displayName!
            let image = entity.avatar!
            
            
            print(name)
            print(image)
            
        //***** EXISTING USERS ***********
        
            print(snap?.documents.count)
            
            if let value = snap?.documents{

                // *********** LOCAL USER INFO STORE **************

                value.forEach { (data) in

                    let userDetail = data.data()

                    let userId = userDetail["userId"] as! String

                    let usr = User.userDetail
                    usr.imageUrl = image
                    usr.displayName = name
                    usr.userId = userId
                    globalVariable.userSnapDetail = usr


                    let detailDetail = ["Name": name,
                                        "Image":image,
                                        "Id":userId]


                    UserDefaults.standard.set(detailDetail, forKey: "USER")

                    UserDefaults.standard.set(true, forKey: "SIGN_IN")
                    self.performSegue(withIdentifier: "Home_Segue", sender: nil)
                }
            }
                               
                             
            
            
            // ************* NEW USERS ******
            
            else {
                let collectionRef = dbStore.collection("Users").document()
                
                let collectionID = collectionRef.documentID
                
                let imageUrl = URL(string: entity.avatar!)
                
                if let data = try? Data(contentsOf: imageUrl!)
                {
                    self.dpImage = UIImage(data: data)!
                    
                }
                
                
                
                
                self.saveImageVM.SaveImageViewModel(collectionID: collectionID, Title: "DP", selectedImage: self.dpImage!) { (imageURL, status, errMsg) in
                    
                    
                    
                    
                    if status{
//                        print(imageURL!)
                        
                        let dict = ["addedDate": FieldValue.serverTimestamp(),
                                    "displayName":entity.displayName!,
                                    "imageUrl": imageURL!,
                                    "isActive":true,
                                    "isDeleted":false,
                                    "userId":collectionID,] as [String : Any]
                        //
                        collectionRef.setData(dict)
                        
                        
                        let detailDetail = ["Name": name,
                                            "Image":image,
                                            "Id":collectionID]
                        
                        
                        
                        print(detailDetail)
                        
                        UserDefaults.standard.set(detailDetail, forKey: "USER")
                        
                        
                        UserDefaults.standard.set(true, forKey: "SIGN_IN")
                        self.performSegue(withIdentifier: "Home_Segue", sender: nil)
                        
                        
                    }
                }
                
            }
  
        }
        
        
        
//
//
        
    }

    
    //**************** OUTET ACTION ******************
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        SCSDKLoginClient.login(from: self) { (LoginStatus, loginErr) in
            
            //******* ERROR OCCUR
            if let err = loginErr{
                print(err.localizedDescription)
                return
            }
            
            //****** LOGIN SUCCESS
            
            if LoginStatus{
                
                self.fetchSnapUserInfo { (userEntity, userError) in
                    
                    if let userEntity = userEntity{
                        
                        DispatchQueue.main.async {
                            
                            self.goToLoginConfirm(userEntity)

                        }
                    }
                }
            }
            
        }
        
        
    
        
    }


}
