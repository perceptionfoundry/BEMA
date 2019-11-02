//
//  SignInVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 01/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SCSDKLoginKit


let globalVariable = UIApplication.shared.delegate as! AppDelegate

class SignInVC: UIViewController {

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
        
        
        globalVariable.userSnapDetail = entity
        
        performSegue(withIdentifier: "Home_Segue", sender: nil)
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
