//
//  SideMenuVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 04/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        sideMenuView.frame = CGRect(x: -20, y: 164, width: 0, height: view.frame.height * 0.9)
//
//
//
//               self.open()
    }
    

    //************ OUTLET ACTION *************
    
    @IBAction func profileButtonAction(_ sender: Any) {
        
        
//        let story = UIStoryboard.init(name: "Profile", bundle: nil)
//        
//        let vc = story.instantiateViewController(withIdentifier: "Profile") as! UIViewController
//        
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        self.performSegue(withIdentifier: "Profile", sender: nil)
        
    }
    
    
    @IBAction func bitmojiButtonAction(_ sender: Any) {}

    @IBAction func walletButtonAction(_ sender: Any) {}

    @IBAction func settingButtonAction(_ sender: Any) {}

    @IBAction func logoutButtonAction(_ sender: Any) {}

    @IBAction func inviteButtonAction(_ sender: Any) {}

    
    @IBAction func backButtonAction(_ sender: Any) {

            self.dismiss(animated: true, completion: nil)
   
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//          sideMenuView.frame = CGRect(x: 0, y: 164, width: 0, height: view.frame.height * 0.8)
//    }
    
}
