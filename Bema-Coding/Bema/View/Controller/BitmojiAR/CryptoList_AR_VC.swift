//
//  CryptoList_AR_VC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 21/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class CryptoList_AR_VC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    //**** outlet
     @IBOutlet weak var crytoList: UITableView!
    @IBOutlet weak var searchView: Custom_View!
     @IBOutlet weak var amountView: Custom_View!
    @IBOutlet weak var amountTF: UILabel!
     @IBOutlet weak var balanceAmountTF: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var cryptoImage : Custom_ImageView!
    @IBOutlet weak var cryptoAbbrev : UILabel!
    @IBOutlet weak var cryptoFull : UILabel!
    

    
    
    // variable
       var cryptoAbrevia = ["ETH","BAT","MKR","MANA"]
       var cryptoName = ["Ethereum","Basic Attention Token", "Maker","Decentraland"]
    
    var selectedCrypto = ""
    
    
    
    var cryptoProtocol : cryptoTransition!
    
        var selectedIndex = 0
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amountView.isHidden = true
        self.confirmButton.isHidden = true
        
        crytoList.delegate = self
        crytoList.dataSource = self

        crytoList.reloadData()
    }
    
    
    
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
           
        
        self.selectedIndex = indexPath.row

        self.crytoList.isHidden = true
        self.searchView.isHidden =  true
        self.amountView.isHidden = false
        self.confirmButton.isHidden = false
        
        self.selectedCrypto = (cryptoAbrevia[self.selectedIndex])
        self.cryptoImage.image = UIImage(named: "\(cryptoAbrevia[self.selectedIndex])")
        self.cryptoFull.text = cryptoName[self.selectedIndex]
        self.cryptoAbbrev.text = cryptoAbrevia[self.selectedIndex]


       }
       
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100
       }
    
    
    //*********** OUTLET ACTION ******
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        
        let dict = ["NAME":self.selectedCrypto,
                    "AMOUNT":amountTF.text!]
        
        cryptoProtocol.ConfiguredCrypto(value: dict)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    
    //******** KEYBOARD ACTION **************
    @IBAction func keyboardKeyAction(_ sender: UIButton) {
        
        if self.amountTF.text == "0"{
            self.amountTF.text = ""
        }
        
        
        
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
            
            if self.amountTF.text == ""{
                self.amountTF.text = "0"
            }
                
                }
        
    }


}
