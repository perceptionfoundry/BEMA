//
//  LogoutVc.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 08/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class LogoutVc: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 //******** OUTLET ACTION
    
    @IBAction func yesButtonAction(_ sender: Any) {

        SCSDKLoginClient.unlinkCurrentSession { (status) in
            
            
            print(status)
            
            if status{
                
                
                UserDefaults.standard.set(false, forKey: "SIGN_IN")
                
                
                
                
                //********* LOGUT SEGUE
                DispatchQueue.main.async { () -> Void in
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let vc = storyBoard.instantiateViewController(withIdentifier: "NaviBarController")
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    globalVariable.window?.rootViewController = vc
                    
                }
                
            }
            
            else{
                print("***************")
                print("Failed")
                print("***************")

            }

            
        }
                }
    
      @IBAction func noButtonAction(_ sender: Any) {

               self.dismiss(animated: true, completion: nil)
            
             }

}


/*
 SCSDKLoginClient.unlinkCurrentSessionWithCompletion { (success: Bool) in
   // do something
 }
 */
