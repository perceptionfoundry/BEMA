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
            
            UserDefaults.standard.set(false, forKey: "SIGN_IN")
            
            if #available(iOS 13.0, *) {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                           
                           let vc = storyBoard.instantiateViewController(withIdentifier: "NaviBarController")
                
                self.present(vc, animated: true, completion: nil)
                           
//                           self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                // Fallback on earlier versions
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
