//
//  SideMenuVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 04/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SDWebImage



class SideMenuVC: UIViewController {
   
    
    

    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!


//    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
//    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

       let entity = globalVariable.userSnapDetail
//        
        print(entity?.imageUrl)
        
        let urlString = (entity?.imageUrl)!
        
        let imageURL = URL(string: urlString)
        
        displayImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        
        
        displayName.text = entity?.displayName!
        
        
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

    @IBAction func logoutButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "LOGOUT", sender: nil)
        
    }

    @IBAction func inviteButtonAction(_ sender: Any) {}

    
    @IBAction func backButtonAction(_ sender: Any) {

            self.dismiss(animated: true, completion: nil)
   
    }

    
    }
