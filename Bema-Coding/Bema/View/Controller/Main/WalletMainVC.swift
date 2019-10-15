//
//  WalletMainVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 02/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import LocalAuthentication

class WalletMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    //****** Outlet
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var crytoList: UITableView!
    @IBOutlet weak var touchArea: UIView!
    @IBOutlet weak var walletListView: Custom_View!
    @IBOutlet weak var selectedCrypto: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    
    //********* KEYBOARD COMPONENT *******
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet var keyboardKeys: [Custom_Button]!
    
    
    
    
    // variable
    var cryptoAbrevia = ["ETH","BAT","MKR","MANA"]
    var cryptoName = ["Ethereum","Basic Attention Token", "Maker","Decentraland"]
    
    
    var currentViewStatus = false
    var lastY : CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.keyboardView.isHidden = true

        
    self.tabBarController?.tabBar.isHidden = true

   
    let tapWalletView = UITapGestureRecognizer(target: self, action: #selector(MoveUp))
    self.touchArea.addGestureRecognizer(tapWalletView)

        self.amountTF.delegate  = self
        
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
    
    
    
    //********** TEXTFIELD DELEGATE FUNNCTION **

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == amountTF{
            
            amountTF.inputView = keyboardView
            
            self.keyboardView.isHidden = false
            
        }
        
        else{
            
            amountTF.inputView = nil
            self.keyboardView.isHidden = true
            

        }
        return true
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

    }
    
    
    func ShowAlert(Title : String, Message: String){
        let alertVC = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let Dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertVC.addAction(Dismiss)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //******** CHAT BUTTON ACTION ***********

    @IBAction func chatButtonAction(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 0
     }

    
    
    private func localAuth(){
             let context = LAContext()
                        
                        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
                            
                            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To have an confirm transaction via FaceID/TouchID ") { (state, err) in
                                
                                if state{
                                    // SEGUE
                                  DispatchQueue.main.async {
                                    
                                    self.crytoList.reloadData()
                                    self.tabbarView.isHidden = false
                                    self.walletListView.isHidden = false
                                    
                                    self.performSegue(withIdentifier: "Next", sender: nil)
                                    }
                                }
                                else{
//                                    self.ShowAlert(Title: "Incorrect Credentials", Message: "Please try again")
                                }
                            }
                        }
                       
                        else{
                            self.ShowAlert(Title: "FaceID / TouchID not Configured", Message: "Please go to setting and configure it")
                        }
    }
    
    
    //******** SEND BUTTON ACTION ***********
    @IBAction func sendButtonAction(_ sender: Any) {
        
        if amountTF.text?.isEmpty == false && userNameTF.text?.isEmpty == false{
            
            self.amountTF.endEditing(true)
            self.keyboardView.isHidden = true
            
            if amountTF.text!.contains(".") == false{
                let temp = self.amountTF.text ?? ""
                self.amountTF.text = "\(temp).0"
                
                self.localAuth()
            }
            else{
                self.localAuth()

            }
        }
     }
    
    
    
    //******** KEYBOARD ACTION **************
    @IBAction func keyboardKeyAction(_ sender: UIButton) {
        
        if sender.tag == 0{
            let temp = self.amountTF.text ?? ""
            self.amountTF.text = "\(temp)\(sender.tag)"
               }
            
    else if sender.tag == 1{
          let temp = self.amountTF.text ?? ""
                       self.amountTF.text = "\(temp)\(sender.tag)"
         }
    
            else if sender.tag == 2{
                let temp = self.amountTF.text ?? ""
                           self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 3{
            let temp = self.amountTF.text ?? ""
                          self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 4{
                 let temp = self.amountTF.text ?? ""
                            self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 5{
              let temp = self.amountTF.text ?? ""
                         self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 6{
              let temp = self.amountTF.text ?? ""
                           self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 7{
               let temp = self.amountTF.text ?? ""
                          self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 8{
            let temp = self.amountTF.text ?? ""
                         self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 9{
               let temp = self.amountTF.text ?? ""
                           self.amountTF.text = "\(temp)\(sender.tag)"
                 }
            
            else if sender.tag == 10{
            
            if amountTF.text?.isEmpty == true{
                self.amountTF.text = "0."
            }
            
            else{
                
                 let temp = self.amountTF.text
                
                if temp!.contains("."){
                    
                }
                
                else{
                    self.amountTF.text = "\((temp)!)."
                }
            }
            
                 }
            
            
            else if sender.tag == 11{
            self.amountTF.text?.removeLast()
                
                }
        
    }
    
}
