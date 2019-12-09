//
//  ContactListVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 21/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SDWebImage

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var contactListTable: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    
  
    var contactProtocol : ContactList_Protocol!
    var selectedIndex = -1
    var dbStore = Firestore.firestore()
    
    
    var allContact = [User]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactListTable.delegate = self
        contactListTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        print(globalVariable.userSnapDetail?.userId)
   
        
        self.getData()
        
    }
    
    
    //****** Personalize Functions ***
    
    
    func getData(){
        let userId = (globalVariable.userSnapDetail?.userId)!
          
           let sourceLink = self.dbStore.collection("Friends").document(userId)
           
           // ***** GET CONTACT
           
           sourceLink.collection("Directory").getDocuments { (snapResult, snapError) in
               
               guard let fetchValue = snapResult?.documents else{return}
               
               
               fetchValue.forEach { (value) in
                   
                   let getValue = value.data()
                   
                      if (getValue["isDeleted"] as! Bool ) == false{
                        
                   let id = getValue["friendId"] as! String
                   
                   print(id)
                   
                   self.dbStore.collection("Users").document(id).getDocument { (contactResult, contactError) in
                       
                       let fetchData = contactResult?.data()
                       
                       
                       let friend = try! FirestoreDecoder().decode(User.self, from: fetchData!)
                       
                       self.allContact.append(friend)
                       
                       self.contactListTable.reloadData()
                       
                   }
            }
               }
           }
    }
    
    //*********** TABLEVIEW DELEGATE FUNCTION *********
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContact.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CONTACT", for: indexPath) as! ContactTableViewCell
        
        
        if self.selectedIndex == indexPath.row{
            cell.tickImage.isHidden = false
        }
        else{
            cell.tickImage.isHidden = true
        }
        
        let imageString = (allContact[indexPath.row].imageUrl)!
        
        let imageURL = URL(string: imageString)
        
        cell.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        cell.userName.text = allContact[indexPath.row].displayName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        self.selectedIndex = indexPath.row
        
        let userDetail = allContact[indexPath.row]
        
        contactProtocol.FetchContact(userDetail: userDetail)
        self.navigationController?.popViewController(animated: true)


           self.contactListTable.reloadData()
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    
    //************** OUTLET ******************
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
   
    

}
