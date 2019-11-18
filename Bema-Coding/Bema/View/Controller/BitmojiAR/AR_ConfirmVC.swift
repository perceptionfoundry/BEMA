//
//  AR_ConfirmVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 28/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import LocalAuthentication
import Firebase

class AR_ConfirmVC: UIViewController {
    
    
    @IBOutlet weak var confirmView: Custom_View!
    @IBOutlet weak var successfulView: Custom_View!
    @IBOutlet weak var screenShot: UIImageView!
    
    
    
    
    var chatRoomTitle = ""
    var senderDetail = globalVariable.userSnapDetail
    var recieverDetail : User?
    var arImage : UIImage?
    let saveImageVM = SaveImageViewModel()
    var recieverId = ""
    var reciverImage : UIImage?
    var senderId = ""
    var senderConversationId = [String]()
    var receiverConversationId = [String]()
    
    
    
    var cryptoCurrency = ""
    var tranferAmount = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        screenShot.image = arImage!
        
        successfulView.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        self.recieverId = (self.recieverDetail?.userId)!
        self.senderId = (self.senderDetail?.userId)!
        
        if senderId > recieverId{
            
            self.chatRoomTitle = "\(senderId)_\(recieverId)"
        }
        else{
            self.chatRoomTitle = "\(recieverId)_\(senderId)"
        }
        
        self.pastConversation()

        
    }
    
    @IBAction func yesButtonAction(_ sender: Any) {
        
        successfulView.isHidden = false
        confirmView.isHidden = true
        
        localAuth()
        
    }
    
    
    
    @IBAction func noButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    //******** PERSONALIZE FUNCTION ******
    
    
    private func localAuth(){
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To have an confirm transaction via FaceID/TouchID ") { (state, err) in
                
                if state{
                    // SEGUE
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        //                                self.navigationController?.popViewController(animated: true)
                        
                        self.sendMedia()
                        
                        //                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        //
                        //                        let vc = storyBoard.instantiateViewController(withIdentifier: "CHAT")
                        //
                        //                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    
                    
                }
                else{
                    self.ShowAlert(Title: "Incorrect Credentials", Message: "Please try again")
                }
            }
        }
            
        else{
            self.ShowAlert(Title: "FaceID / TouchID not Configured", Message: "Please go to setting and configure it")
        }
    }
    
    
    
    
    //**************** SEND MEDIA FILE ***************
    func sendMedia(){
        
        let dbStore = Firestore.firestore()
        
        
        let collectionRef = dbStore.collection("ChatRoom").document()
        
        let collectionId = collectionRef.documentID
        
        saveImageVM.SaveImageViewModel(collectionID: collectionId, Title: "IMG_\(collectionId)", selectedImage: self.arImage!) { (imageURl, status, err) in
            
            if status{
                let urlString = imageURl!
                
                // ****** CREATE MESSAGE INFO *****
                
                let basisDict = ["addedOn": FieldValue.serverTimestamp(),
                                 "chatId": collectionRef.documentID,
                                 "roomId": self.chatRoomTitle,
                                 "senderId" : self.senderId,
                                 "receiverId" : self.recieverId,
                                 "senderName": (self.senderDetail?.displayName)!,
                                 "recieverName" : (self.recieverDetail?.displayName)!,
                                 "senderImageURL" : (self.senderDetail?.imageUrl)!,
                                 "recieverImageURL" : (self.recieverDetail?.imageUrl)!,
                                 "readerID":self.recieverId,
                                 "context"  : urlString,
                                 "composerId" : self.senderId,
                                 "type": "MEDIA",
                                 "isDeleted": false,
                                 "isRead" : false] as [String : Any]
                
                
                print(basisDict)
                
                collectionRef.setData(basisDict)
                
                
                //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                //
                //                let vc = storyBoard.instantiateViewController(withIdentifier: "CHAT")
                //
                //                self.navigationController?.pushViewController(vc, animated: true)
                //
                //
                if self.senderConversationId.contains(self.chatRoomTitle) == false {
                    self.senderConversationId.append(self.chatRoomTitle)
                    dbStore.collection("Conversation").document(self.senderId).setData(["chatRoom":self.senderConversationId])
                }
                if self.receiverConversationId.contains(self.chatRoomTitle) == false{
                    self.receiverConversationId.append(self.chatRoomTitle)
                    dbStore.collection("Conversation").document(self.recieverId).setData(["chatRoom":self.receiverConversationId])
                }
                
                self.sendAmount()
                
            }
        }
        
        
        
        
    }
    
    
    func sendAmount(){
        
        let dbStore = Firestore.firestore()
        
        
        let collectionRef = dbStore.collection("ChatRoom").document()
        
        let collectionId = collectionRef.documentID
        
        // ****** CREATE MESSAGE INFO *****
        
        let basisDict = ["addedOn": FieldValue.serverTimestamp(),
                         "chatId": collectionId,
                         "roomId": self.chatRoomTitle,
                         "senderId" : self.senderId,
                         "receiverId" : self.recieverId,
                         "senderName": (self.senderDetail?.displayName)!,
                         "recieverName" : (self.recieverDetail?.displayName)!,
                         "senderImageURL" : (self.senderDetail?.imageUrl)!,
                         "recieverImageURL" : (self.recieverDetail?.imageUrl)!,
                         "readerID":self.recieverId,
                         "context"  : "\(self.cryptoCurrency)_\(self.tranferAmount)",
            "composerId" : self.senderId,
            "type": "CRYPTO",
            "isDeleted": false,
            "isRead" : false] as [String : Any]
        
        
        print(basisDict)
        
        collectionRef.setData(basisDict)
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyBoard.instantiateViewController(withIdentifier: "CHAT")

        self.navigationController?.pushViewController(vc, animated: true)
        
       
        
        
        
        
        if self.senderConversationId.contains(self.chatRoomTitle) == false {
            self.senderConversationId.append(self.chatRoomTitle)
            dbStore.collection("Conversation").document(self.senderId).setData(["chatRoom":self.senderConversationId])
        }
        if self.receiverConversationId.contains(self.chatRoomTitle) == false{
            self.receiverConversationId.append(self.chatRoomTitle)
            dbStore.collection("Conversation").document(self.recieverId).setData(["chatRoom":self.receiverConversationId])
        }
        
        
//        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func pastConversation(){
          
        let dbStore = Firestore.firestore()

        
          dbStore.collection("Conversation").document(self.senderId).addSnapshotListener { (conversationSnap, conversationErr) in
              
              guard let  value = conversationSnap?.data() else{return}
              
              self.senderConversationId = value["chatRoom"]  as! [String]
              
              
              print("*****************")
              print(self.senderConversationId)
              print("**************")
          }
          
          
          dbStore.collection("Conversation").document(self.recieverId).addSnapshotListener { (conversationSnap, conversationErr) in
              
              guard let  value = conversationSnap?.data() else{return}
              
              self.receiverConversationId = value["chatRoom"]  as! [String]
              
              
              print("*****************")
              print(self.receiverConversationId)
              print("**************")
          }
          
      }
    
    func ShowAlert(Title : String, Message: String){
        let alertVC = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let Dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertVC.addAction(Dismiss)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
