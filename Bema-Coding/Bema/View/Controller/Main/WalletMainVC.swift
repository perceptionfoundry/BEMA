//
//  WalletMainVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 02/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class WalletMainVC: UIViewController {

    
    @IBOutlet weak var walletListView: Custom_View!
    
    @IBOutlet weak var walletListViewConstant: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        
//        let scrollWalletView = UIPanGestureRecognizer(target: self, action: #selector(MoveUp))
        
    let tapWalletView = UITapGestureRecognizer(target: self, action: #selector(MoveUp))
        self.walletListView.addGestureRecognizer(tapWalletView)

    }
    
    @objc func MoveUp(){
        
        print("yes")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        self.walletListViewConstant.constant += -20

            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                   self.walletListViewConstant.constant += -20

                   }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                   self.walletListViewConstant.constant += -20

                   }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                   self.walletListViewConstant.constant += -20

                   }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            self.walletListViewConstant.constant += -20

            }
        }
        
//        UIView.animate(withDuration: 2) {
//            self.walletListViewConstant.constant = -120
//        }
//        }
//        else if moveStatus.direction == .down{
//
//            self.walletListViewConstant.constant = -30
//        }
//
    }
    @IBAction func chatButtonAction(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 0
     }


}
