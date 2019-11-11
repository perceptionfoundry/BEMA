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
    
    var directory = [[String:Any]]()
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
        
        self.allContact.removeAll()
        self.contactListTable.reloadData()
        
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
                
                if snapResult?.count == 0 {
                    self.contactListTable.reloadData()
                }
                
                   guard let fetchValue = snapResult?.documents else{return}
                   
                   
                   fetchValue.forEach { (value) in
                       
                        
                       let getValue = value.data()
                    
                    if (getValue["isDeleted"] as! Bool ) == false{
                        
                        self.directory.append(getValue)
                        
                           
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
                    
//
                   }
               }
        }
        
    
    
    @objc func removeList(button:UIButton){
        
        let selectUser = allContact[button.tag]
        
       let indexOfFriend = allFriends.firstIndex(of: selectUser)
        
        
        
        
        let userID = (self.userDetail?.userId)!
        let directoryID = (directory[button.tag]["directoryId"]) as! String
        
        
        print(userID)
        print(directoryID)
        
        let newDict  = ["friendId": directory[button.tag]["friendId"] as! String,
                        "directoryId":directoryID,
                        "isDeleted":true
                        
            ] as [String : Any]
        
        self.dbStore.collection("Friends").document(userID).collection("Directory").document(directoryID).setData(newDict)
        
        
        
        allFriends.remove(at: indexOfFriend!)

        contactListTable.reloadData()
        
    
   
        
    }
        
    
    
    @objc func addlist(button:UIButton){
         
         let selectUser = allContact[button.tag]
         

        self.allFriends.append(selectUser)
        
         
         
         
         let userID = (self.userDetail?.userId)!
         
         
         print(userID)
        
        // ***** USER *******
        let collectionRef_USER =  self.dbStore.collection("Friends").document(userID).collection("Directory").document()
         
        let newDict  = ["friendId": selectUser.userId!,
                        "directoryId":collectionRef_USER.documentID,
                         "isDeleted":false
                         
             ] as [String : Any]
         
        collectionRef_USER.setData(newDict)
         
        
        //********** OTHER ********
        let collectionRef_OTHER =  self.dbStore.collection("Friends").document(selectUser.userId).collection("Directory").document()
               
        let newDict_Other  = ["friendId": userID,
                              "directoryId":collectionRef_OTHER.documentID,
                               "isDeleted":false
                               
                   ] as [String : Any]
               
              collectionRef_OTHER.setData(newDict_Other)
         
         

         contactListTable.reloadData()
         
     
    
         
     }
        
        
        //************** OUTLET ******************
        @IBAction func backButtonAction(_ sender: Any) {
            
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
            
            cell.actionButton.addTarget(self, action: #selector(removeList(button:)), for: .touchUpInside)

        }
        else{
            cell.actionButton.tag = indexPath.row
            cell.actionButton.setTitle("Add", for: .normal)
            cell.actionButton.backgroundColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
            
            cell.actionButton.addTarget(self, action: #selector(addlist(button:)), for: .touchUpInside)


        }
        
        let imageString = (allContact[indexPath.row].imageUrl)!
        
        let imageURL = URL(string: imageString)
        
        cell.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        cell.userName.text = allContact[indexPath.row].displayName
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CONTACT", for: indexPath) as! ContactManagerTableViewCell
//
//
//
//
//                let status = allFriends.contains(where: { (contact_user) -> Bool in
//
//
//
//                    if contact_user.userId == allContact[indexPath.row].userId{
//                        return true
//                    }
//
//                    else{
//
//                        return false
//
//                    }
//
//                })
//
//
//                if status{
//                }
//                else{
//
//                }
//
//
//       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
}
