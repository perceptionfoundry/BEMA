//
//  ManageWalletVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 07/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ManageWalletVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var currencyList : UITableView!
    
    var selectedIndex = 0
    
    let currency = ["USD", "EUR", "JPY", "CHF", "CAD", "INR", "GBP", "CNY", "MXN", "TRY", "BRL", "NOK", "SGD","NZD", "AUD"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currencyList.delegate = self
        currencyList.dataSource = self
        
        currencyList.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Currency", for: indexPath) as! CurrencyTableViewCell
        

        
        cell.currencyName.text  = currency[indexPath.row]
        
        if self.selectedIndex == indexPath.row{
            cell.currencyImage.isHidden = false
        }
        else{
            cell.currencyImage.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row

        self.currencyList.reloadData()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {

             self.navigationController?.popViewController(animated: true)
          
           }

}
