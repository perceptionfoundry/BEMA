//
//  AR_ConfirmVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 28/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class AR_ConfirmVC: UIViewController {

    
    @IBOutlet weak var confirmView: Custom_View!
    @IBOutlet weak var successfulView: Custom_View!

    
    var quitProtocol: DoubleSegueProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successfulView.isHidden = true
    }
    
    @IBAction func yesButtonAction(_ sender: Any) {
        
        successfulView.isHidden = false
        confirmView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
            self.quitProtocol.quit()
            
        
            

        }

    }
    
    
    
    @IBAction func noButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
