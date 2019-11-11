//
//  ContactManagerVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 11/11/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SDWebImage

class ContactManagerVC: UIViewController {

        @IBOutlet weak var contactListTable: UITableView!
        @IBOutlet weak var searchTF: UITextField!
        
        
      
        var contactProtocol : ContactList_Protocol!
        var addedContact = [User]()
        var dbStore = Firestore.firestore()
        
        
    var userDetail : User?
    
        var allContact = [User]()
        var allFriends = [User]()
        var friendIndex = [Int]()
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()

            contactListTable.delegate = self
            contactListTable.dataSource = self
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            
            self.userDetail = (globalVariable.userSnapDetail)!
            
            self.getAllContact()
            self.getAllFriend()
            
        }
        
        
        //****** Personalize Functions ***
        
    
    //************ FRIENDS ************

    func getAllContact(){
        
        self.dbStore.collection("Users").getDocuments { (contactSnap, contactErr) in
            
            guard let fetchValue = contactSnap?.documents else{return}
            
            var tempContact = [User]()
            var index = 0
            
            fetchValue.forEach { (values) in
                
                let value = values.data()
                
                let getValue = try! FirestoreDecoder().decode(User.self, from: value)
                
            
                if getValue.userId != self.userDetail?.userId{
                
                    tempContact.append(getValue)
                    
                    
                    index += 1
                    if tempContact.count == index{
                        
                        self.allContact.removeAll()
                        self.allContact = tempContact
                        self.getAllFriend()

                    }
//                self.contactListTable.reloadData()
                }
            }
        }

    }
        
        
    
    //************ FRIENDS ************
    
    
    func getAllFriend(){
            let userId = (globalVariable.userSnapDetail?.userId)!
              
               let sourceLink = self.dbStore.collection("Friends").document(userId)
               
               // ***** GET FRIENDS
               
               sourceLink.collection("Directory").getDocuments { (snapResult, snapError) in
                   
                
                var tempFriend = [User]()

                var index = 0
                
                   guard let fetchValue = snapResult?.documents else{return}
                   
                   
                   fetchValue.forEach { (value) in
                       
                       let getValue = value.data()
                       
                       let id = getValue["friendId"] as! String
                       
                       
                       self.dbStore.collection("Users").document(id).getDocument { (contactResult, contactError) in
                           
                           let fetchData = contactResult?.data()
                           
                           
                           let friend = try! FirestoreDecoder().decode(User.self, from: fetchData!)
                           
                        tempFriend.append( friend)
                        index += 1
                        
                        if tempFriend.count == index{
                            
                            self.allFriends.removeAll()
                            self.allFriends = tempFriend
                            self.contactListTable.reloadData()


                        }
                        
                                                      
                           
                       }
                   }
               }
        }
        
    
    
    func removeList(index : Int){
        
        let selectUser = allContact[index]
        
        
        
    
   
        
    }
        
        
        
        //************** OUTLET ******************
        @IBAction func backButtonAction(_ sender: Any) {
            
            contactProtocol.FetchContact(userDetail: [:])
            self.navigationController?.popViewController(animated: true)
        }
}


extension ContactManagerVC:  UITableViewDelegate, UITableViewDataSource{
    //*********** TABLEVIEW DELEGATE FUNCTION *********
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContact.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CONTACT", for: indexPath) as! ContactManagerTableViewCell
        

        
        
        let status = allFriends.contains(where: { (contact_user) -> Bool in
            
        if contact_user.userId == allContact[indexPath.row].userId{  return true }
            
            else{ return false }
            
        })
        
        
        if status{
            
            
            cell.actionButton.tag = indexPath.row
            cell.actionButton.setTitle("Remove", for: .normal)
            cell.actionButton.backgroundColor = UIColor(red: 0.076, green: 0.463, blue: 1.0, alpha: 1)
        }
        else{
            cell.actionButton.tag = indexPath.row
            cell.actionButton.setTitle("Add", for: .normal)
            cell.actionButton.backgroundColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)

        }
        
        let imageString = (allContact[indexPath.row].imageUrl)!
        
        let imageURL = URL(string: imageString)
        
        cell.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        cell.userName.text = allContact[indexPath.row].displayName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           

        let cell = tableView.dequeueReusableCell(withIdentifier: "CONTACT", for: indexPath) as! ContactManagerTableViewCell
                

                
                
                let status = allFriends.contains(where: { (contact_user) -> Bool in
                    
                
                    
                    if contact_user.userId == allContact[indexPath.row].userId{
                        return true
                    }
                    
                    else{

                        return false

                    }
                    
                })
                
                
                if status{

                    cell.actionButton.isHidden  = true
                }
                else{
                    cell.actionButton.isHidden  = true

                }
        
        
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
}
