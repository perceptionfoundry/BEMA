//
//  SettingVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 07/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonAction(_ sender: Any) {

          self.navigationController?.popViewController(animated: true)
       
        }

}
