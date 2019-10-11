//
//  WalletMainVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 02/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class WalletMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //****** Outlet
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var crytoList: UITableView!
    @IBOutlet weak var touchArea: UIView!
    @IBOutlet weak var walletListView: Custom_View!
    @IBOutlet weak var selectedCrypto: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    
    
    
    // variable
    var cryptoAbrevia = ["ETH","BAT","MKR","MANA"]
    var cryptoName = ["Ethereum","Basic Attention Token", "Maker","Decentraland"]
    
    
    var currentViewStatus = false
    var lastY : CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            self.tabBarController?.tabBar.isHidden = true

   
    let tapWalletView = UITapGestureRecognizer(target: self, action: #selector(MoveUp))
    self.touchArea.addGestureRecognizer(tapWalletView)

  
        
        self.crytoList.delegate = self
        self.crytoList.dataSource = self
        self.crytoList.reloadData()

    }
    // ********* TABLE VIEW DELEGATE FUNCTION ****
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CRYPTO", for: indexPath) as! Wallet_CryptoTableView
        cell.cryptoLogo.image = UIImage(named: "\(cryptoAbrevia[indexPath.row])")
        cell.cryptoFull.text = cryptoName[indexPath.row]
        cell.cryptoAbreviation.text = cryptoAbrevia[indexPath.row]
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.walletListView.isHidden = true
        self.tabbarView.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //******** PERSONALIZE FUNCTION ***********
    
    @objc func MoveUp(){
        
        
        print(self.walletListView.frame.origin.y)
        print(currentViewStatus)
        
        if currentViewStatus == false{
            self.currentViewStatus = true
            
            UIView.animate(withDuration: 1) {
                self.lastY = self.walletListView.frame.origin.y
                self.walletListView.frame.origin.y =  (self.view.frame.origin.y + 40)
                 }
        }
        else{
            self.currentViewStatus = false
            UIView.animate(withDuration: 1) {
                self.walletListView.frame.origin.y = self.lastY!
                 }
        }
        
        
        
        
     
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
