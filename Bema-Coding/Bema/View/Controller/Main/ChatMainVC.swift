//
//  ChatMainVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 02/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import CodableFirebase


class ChatMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // OUTLET
    
    @IBOutlet weak var contactList: UITableView!
    @IBOutlet weak var DisplayImage: UIImageView!
    
    var sender = ""
    var reciever = ""
    var chatRoomTitle = ""
    
    
    let dbStore = Firestore.firestore()
      
      var allMessage = [Message]()
    var alertCount = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true

        

        let tap = UITapGestureRecognizer(target: self, action: #selector(sideMenuAction))
        
        self.DisplayImage.addGestureRecognizer(tap)
        
        
        self.sender = (globalVariable.userSnapDetail?.userId)!
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.allMessage.removeAll()
        self.alertCount.removeAll()
        self.contactList.reloadData()

        //******* DP IMAGE ***
        
        
        
         let entity = globalVariable.userSnapDetail
        //
//                print(entity?.imageUrl)
                
                let urlString = (entity?.imageUrl)!
                
                let imageURL = URL(string: urlString)
                
                DisplayImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        
        
        self.fetchMessage()

    }
    
  
 //********** TABLE VIEW *****
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contact", for: indexPath) as! MessageTableViewCell
        
        cell.selectionStyle = .none
        
        
            print(self.alertCount)
         cell.countView.isHidden = true
        
        if allMessage[indexPath.row].readerID == self.sender{
            
            if alertCount[indexPath.row] == 0{
                cell.countView.isHidden = true
            }
            else{
                cell.countView.isHidden = false
                cell.count.text = "\(alertCount[indexPath.row])"
                
            }
            
        }
        
        if sender == allMessage[indexPath.row].composerId{
            
            cell.userName.text = allMessage[indexPath.row].recieverName
                  cell.message.text = allMessage[indexPath.row].context
                  
                  //****** IMAGE ********
            let urlString = (allMessage[indexPath.row].recieverImageURL)
            let imageURL = URL(string: urlString!)
            cell.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        }
        else{
            
            cell.userName.text = allMessage[indexPath.row].senderName
                  cell.message.text = allMessage[indexPath.row].context
                  
                  //****** IMAGE ********
            let urlString = (allMessage[indexPath.row].senderImageURL)
            let imageURL = URL(string: urlString!)
            cell.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
            
        }
        
        //
      
        
        
        //******** TIME **********
        let messageTime = allMessage[indexPath.row].addedOn
        let messageTime_Date = messageTime?.dateValue()
        let currentDate = Date()
        
      
//        print(messageTime)
//        print(currentDate)
        
        if messageTime_Date != nil{
            let diff = self.getTimeComponentString(olderDate: messageTime_Date!, newerDate: currentDate)
            cell.time.text = diff ?? ""

        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if sender == allMessage[indexPath.row].composerId{
            let receiverId = allMessage[indexPath.row].receiverId
            
            dbStore.collection("Users").whereField("userId", isEqualTo: receiverId!).getDocuments { (result, err) in
                
                guard let values = result?.documents else{return}
                
                values.forEach { (value) in
                    
                    let getdata = value.data()
                    
                    let user = try! FirestoreDecoder().decode(User.self, from: getdata)
                    
                    let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "CHAT") as! chatRoomVC
                    vc.recieverDetail = user
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
        else{
            let receiverId = allMessage[indexPath.row].senderId
            
            dbStore.collection("Users").whereField("userId", isEqualTo: receiverId!).getDocuments { (result, err) in
                
                guard let values = result?.documents else{return}
                
                values.forEach { (value) in
                 
                    
                    let getdata = value.data()
                    
                    let user = try! FirestoreDecoder().decode(User.self, from: getdata)
                    
                    let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "CHAT") as! chatRoomVC
                    vc.recieverDetail = user
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }

    @IBAction func walletButtonAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1

    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CONTACT", sender: nil)


       }
    
    
    
    
    //********** PERSONALIZE FUNCTION

      func fetchMessage(){
        
        allMessage.removeAll()
//        alertCount.removeAll()
        contactList.reloadData()
          
    
        self.dbStore.collection("Conversation").document(self.sender).addSnapshotListener { (converSnap, converErr) in
            
            
            
            guard let value = converSnap?.data() else{return}
            
           
            
            print(self.sender)
            print(value)
            
            let roomIds = value["chatRoom"] as! [String]
            
          
            self.allMessage.removeAll()
                          self.alertCount.removeAll()
                          self.contactList.reloadData()
            
            
            
            roomIds.forEach { (ID) in
                
                
               self.dbStore.collection("ChatRoom").whereField("roomId", isEqualTo: ID).order(by: "addedOn", descending: false).addSnapshotListener { (chatSnap, chatError) in

                    guard let fetchValue = chatSnap?.documents else{return}


//                print(fetchValue.count)
                
                
              
                
                    var index = 0
                    var count = 0
                    
                chatSnap?.documentChanges.forEach({ (diff) in
                    
                    if diff.type == .modified{
                        print("change")
                    }
                })
                    
            
                
                     fetchValue.forEach { (value) in
                        
                        let getData = value.data()
             
                        let msg = try! FirestoreDecoder().decode(Message.self, from: getData)
                        
                        
                        index += 1
                        
                        if msg.isRead == false  &&  msg.readerID == self.sender{
                            
                            count += 1
                        }
                     
                        
                        if index == fetchValue.count {
                            
                        
                            self.allMessage.append(msg)
                            self.alertCount.append(count)
                            self.contactList.delegate = self
                            self.contactList.dataSource = self
                            self.contactList.reloadData()
                        }
                        
                        
                        
                    }
                 

                }
                
                
            }
            

          }
      }

    
    
    
    
    
    @objc func sideMenuAction(){
        
        self.performSegue(withIdentifier: "Menu_Segue", sender: nil)
     
    }
    
    
    
    func getTimeComponentString(olderDate older: Date,newerDate newer: Date) -> (String?)  {
         let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
         
         let componentsLeftTime = Calendar.current.dateComponents([.minute , .hour , .day,.month, .weekOfMonth,.year], from: older, to: newer)
         
         let year = componentsLeftTime.year ?? 0
         if  year > 0 {
             formatter.allowedUnits = [.year]
             return formatter.string(from: older, to: newer)
         }
         
         
         let month = componentsLeftTime.month ?? 0
         if  month > 0 {
             formatter.allowedUnits = [.month]
             return formatter.string(from: older, to: newer)
         }
         
         let weekOfMonth = componentsLeftTime.weekOfMonth ?? 0
         if  weekOfMonth > 0 {
             formatter.allowedUnits = [.weekOfMonth]
             return formatter.string(from: older, to: newer)
         }
         
         let day = componentsLeftTime.day ?? 0
         if  day > 0 {
             formatter.allowedUnits = [.day]
             return formatter.string(from: older, to: newer)
         }
         
         let hour = componentsLeftTime.hour ?? 0
         if  hour > 0 {
             formatter.allowedUnits = [.hour]
             return formatter.string(from: older, to: newer)
         }
         
         let minute = componentsLeftTime.minute ?? 0
         if  minute > 0 {
             formatter.allowedUnits = [.minute]
             return formatter.string(from: older, to: newer) ?? ""
         }
        
         
         return nil
     }
    
    
    
}
