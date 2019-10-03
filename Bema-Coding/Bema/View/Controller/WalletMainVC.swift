//
//  WalletMainVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 02/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class WalletMainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true

    }
    
    @IBAction func chatButtonAction(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 0
     }


}
