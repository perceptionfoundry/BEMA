//
//  ContactListVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 21/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var contactListTable: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    
  
    var contactProtocol : ContactList_Protocol!
    var selectedIndex = 0
    var dbStore = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactListTable.delegate = self
        contactListTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(globalVariable.userSnapDetail?.userId)
        
        self.dbStore.collection("Friend")
    }
    
    
    //*********** TABLEVIEW DELEGATE FUNCTION *********
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CONTACT", for: indexPath) as! ContactTableViewCell
        
        
        if self.selectedIndex == indexPath.row{
            cell.tickImage.isHidden = false
        }
        else{
            cell.tickImage.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           self.selectedIndex = indexPath.row

           self.contactListTable.reloadData()
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    
    //************** OUTLET ******************
    @IBAction func backButtonAction(_ sender: Any) {
        
        contactProtocol.FetchContact(userDetail: [:])
        self.navigationController?.popViewController(animated: true)
    }
    
    
   
    

}
