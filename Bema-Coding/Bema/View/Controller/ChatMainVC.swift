//
//  ChatMainVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 02/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ChatMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // OUTLET
    
    @IBOutlet weak var contactList: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        contactList.delegate = self
        contactList.dataSource = self
        contactList.reloadData()
    }
    
 //********** TABLE VIEW *****
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contact", for: indexPath) as! ContactTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }

    @IBAction func walletButtonAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1

    }
    
}
