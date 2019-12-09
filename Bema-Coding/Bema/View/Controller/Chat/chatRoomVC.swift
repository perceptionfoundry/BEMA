//
//  chatRoomVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 29/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SCSDKCreativeKit
import SCSDKBitmojiKit
import IQKeyboardManagerSwift
import Firebase
import CodableFirebase
import SDWebImage

class chatRoomVC: UIViewController {
    
    
    //****** OUTLET *****
    
    @IBOutlet weak var recieverName : UILabel!
    @IBOutlet weak var recieverImage : Custom_ImageView!
    @IBOutlet weak var ChatTableView : UITableView!
    @IBOutlet weak var ChatTextField : UITextView!
    @IBOutlet weak var ChatBitmojiImage : UIImageView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatMsg_view: UIView!
    
    
    
    
    //****** VARIABLE *****
    
    private var bitmojiSelectionView: UIView?
    var textFieldMsgStatus = true
    var chatRoomTitle = ""
    var senderDetail = globalVariable.userSnapDetail
    var recieverDetail : User?
    var selectedBitMoji : UIImage?
    var maxheight:CGFloat = 80
    var bubbleHeight = [CGFloat]()
    
    
    var recieverId = ""
    var reciverImage : UIImage?
    var senderId = ""
    
    let dbStore = Firestore.firestore()
    
    var allMessage = [Message]()
    var sendMessage = ""
    
    var saveImageVC = SaveImageViewModel()
    
    var senderConversationId = [String]()
    var receiverConversationId = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchMessage()
        
        let urlString = (recieverDetail?.imageUrl)!
        
        let imageURL = URL(string: urlString)
        
        recieverImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        
        
        recieverName.text = (recieverDetail?.displayName)!
        
        
        self.recieverId = (self.recieverDetail?.userId)!
        self.senderId = (self.senderDetail?.userId)!
        
        if senderId > recieverId{
            
            self.chatRoomTitle = "\(senderId)_\(recieverId)"
        }
        else{
            self.chatRoomTitle = "\(recieverId)_\(senderId)"
        }
        
        
        
        
        //***** CONFIGURATION **********
        ChatBitmojiImage.isHidden = true
        
        ChatTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction))
        
        ChatTextField.delegate = self
        
        ChatTextField.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
        
        //********* NIB REGISTERATION *********
        
        //**** TEXT
        let senderTextXib = UINib(nibName: "SenderText_Cell", bundle: nil)
        ChatTableView.register(senderTextXib, forCellReuseIdentifier: "SenderText")
        
        let receiverTextXib = UINib(nibName: "RecieverText_Cell", bundle: nil)
        ChatTableView.register(receiverTextXib, forCellReuseIdentifier: "ReceiverText")
        
        
        //****** IMAGE
        let senderImageXib = UINib(nibName: "SenderImage_Cell", bundle: nil)
        ChatTableView.register(senderImageXib, forCellReuseIdentifier: "SenderImage")
        
        let receiverImageXib = UINib(nibName: "RecieverImage_Cell", bundle: nil)
        ChatTableView.register(receiverImageXib, forCellReuseIdentifier: "ReceiverImage")
        
        
        //****** CRYPTO
        let senderCryptoXib = UINib(nibName: "SenderAmount_Cell", bundle: nil)
        ChatTableView.register(senderCryptoXib, forCellReuseIdentifier: "SenderCrypto")
        
        let receiverCryptoXib = UINib(nibName: "ReceiverAmount_Cell", bundle: nil)
        ChatTableView.register(receiverCryptoXib, forCellReuseIdentifier: "ReceiverCrypto")
        
        
        
        self.pastConversation()
        self.fetchMessage()
        
        
    }
    
    
    
    //******** PERSONALIZE FUNCITON **********
    
    
    func makeRead(chatID : String){
        
        let dict = ["isRead": true]
        dbStore.collection("ChatRoom").document(chatID).updateData(dict)
        
    }
    
    
    func pastConversation(){
        
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
    
    func fetchMessage(){
        
        
        
        
        self.dbStore.collection("ChatRoom").whereField("roomId", isEqualTo: self.chatRoomTitle).order(by: "addedOn", descending: false).addSnapshotListener { (chatSnap, chatError) in
            
            guard let fetchValue = chatSnap?.documents else{return}
            
            self.allMessage.removeAll()
            
            fetchValue.forEach { (value) in
                
                let getData = value.data()
                
                
                
                let msg = try! FirestoreDecoder().decode(Message.self, from: getData)
                
                if msg.readerID == self.senderId{
                    self.makeRead(chatID: msg.chatId)
                }
                
                self.allMessage.append(msg)
                self.ChatTableView.delegate = self
                self.ChatTableView.dataSource = self
                self.ChatTableView.reloadData()
                
                let indexPath = NSIndexPath(item: self.allMessage.count - 1, section: 0)
                self.ChatTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                
                
                
            }
        }
    }
    
    
    func sendText(){
        
        
        
        let collectionRef = self.dbStore.collection("ChatRoom").document()
        
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
                         "context"  : self.sendMessage,
                         "composerId" : self.senderId,
                         "type": "TEXT",
                         "isDeleted": false,
                         "isRead" : false] as [String : Any]
        
        collectionRef.setData(basisDict)
        
        //************ CONVERSATION **********
        
        if senderConversationId.contains(chatRoomTitle) == false {
            self.senderConversationId.append(self.chatRoomTitle)
            dbStore.collection("Conversation").document(self.senderId).setData(["chatRoom":self.senderConversationId])
        }
        if receiverConversationId.contains(chatRoomTitle) == false{
            self.receiverConversationId.append(self.chatRoomTitle)
            dbStore.collection("Conversation").document(self.recieverId).setData(["chatRoom":self.receiverConversationId])
        }
        
        
        
        
        self.allMessage.removeAll()
        self.ChatTableView.reloadData()
    }
    
    
    
    //**************** SEND MEDIA FILE ***************
    func sendMedia(){
        
        
        
        let collectionRef = self.dbStore.collection("ChatRoom").document()
        
        let collectionId = collectionRef.documentID
        
        saveImageVC.SaveImageViewModel(collectionID: collectionId, Title: "IMG_\(collectionId)", selectedImage: self.selectedBitMoji!) { (imageURl, status, err) in
            
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
                
                collectionRef.setData(basisDict)
                
                
                if self.senderConversationId.contains(self.chatRoomTitle) == false {
                    self.senderConversationId.append(self.chatRoomTitle)
                    self.dbStore.collection("Conversation").document(self.senderId).setData(["chatRoom":self.senderConversationId])
                }
                if self.receiverConversationId.contains(self.chatRoomTitle) == false{
                    self.receiverConversationId.append(self.chatRoomTitle)
                    self.dbStore.collection("Conversation").document(self.recieverId).setData(["chatRoom":self.receiverConversationId])
                }
                
                
                
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    @objc func doneAction(){
        
        self.returnAction()
    }
    
    
    
    
    func returnAction(){
        if self.textFieldMsgStatus == false{
            
            self.ChatBitmojiImage.isHidden = true
            self.textViewHeight.constant = 40
            self.ChatTextField.isHidden = false
            self.textFieldMsgStatus = true
            self.ChatTableView.reloadData()
            
            self.sendMedia()
            
        }
            
        else{
            //
            self.sendMessage = ChatTextField.text!
            ChatTextField.text = "Say Something..."
            ChatTextField.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
            
            ChatTableView.reloadData()
            
            //************
            self.sendText()
        }
    }
    
    
    
    //********** OUTLET ACTION **********
    
    
    @IBAction func bitmojiButtonTapped(_ sender: Any) {
        // Make bitmoji background view
        let viewHeight: CGFloat = 300
        let screen: CGRect = UIScreen.main.bounds
        let backgroundView = UIView(
            frame: CGRect(
                x: 0,
                y: screen.height - viewHeight,
                width: screen.width,
                height: viewHeight
            )
        )
        view.addSubview(backgroundView)
        bitmojiSelectionView = backgroundView
        
        // add child ViewController
        let stickerPickerVC = SCSDKBitmojiStickerPickerViewController()
        stickerPickerVC.delegate = self
        
        present(stickerPickerVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func mediaButtonAction(_ sender: UIButton) {
        
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        let alertAction = UIAlertController(title: "Select Image Source", message: "Which Image source you want to use ?", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Gallery", style: .default) { (action) in
            
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertAction.addAction(library)
        alertAction.addAction(camera)
        alertAction.addAction(cancel)
        
        self.present(alertAction, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}






//********************************* SNAPKIT *********************************

extension chatRoomVC: SCSDKBitmojiStickerPickerViewControllerDelegate {
    
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String, image: UIImage?) {
        
        
        UIImage.load()
        
        if let image = UIImage.load(from: bitmojiURL) {
            DispatchQueue.main.async {
                //                self.setImageToScene(image: image)
                self.selectedBitMoji = image
                
                //
                
                self.textViewHeight.constant = 80
                self.ChatBitmojiImage.image = image
                self.ChatBitmojiImage.isHidden = false
                self.textFieldMsgStatus = false
                
                self.ChatTextField.becomeFirstResponder()
                self.ChatTextField.isHidden = true
                
                self.dismiss(animated: true, completion: nil)
                
                self.bitmojiSelectionView?.removeFromSuperview()
            }
        }
        
    }
    
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String) {
        
        bitmojiSelectionView?.removeFromSuperview()
        
        
        
        if let image = UIImage.load(from: bitmojiURL) {
            DispatchQueue.main.async {
                self.selectedBitMoji = image
                
                self.textViewHeight.constant = 100
                self.ChatBitmojiImage.image = image
                self.ChatBitmojiImage.isHidden = false
                
                
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, searchFieldFocusDidChangeWithFocus hasFocus: Bool) {
        
    }
}





//********************************* TABLEVIEW  *********************************


extension chatRoomVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        //******** TEXT *********
        if self.allMessage[indexPath.row].type! == "TEXT"{
            
            if self.senderId == self.allMessage[indexPath.row].composerId!{
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderText") as! SenderText_Cell
                
                cell.selectionStyle = .none
                
                
                
                cell.senderMessageLabel.text = (self.allMessage[indexPath.row].context!)
                
                return cell
                
            }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverText") as! RecieverText_Cell
                
                cell.selectionStyle = .none
                
                cell.receiverMessageLabel.text = (self.allMessage[indexPath.row].context!)
                
                return cell
            }
            
        }
        else if self.allMessage[indexPath.row].type! == "MEDIA"{
            
            if self.senderId == self.allMessage[indexPath.row].composerId!{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImage") as! SenderImage_Cell
                
                cell.selectionStyle = .none
                
                let imageLink = allMessage[indexPath.row].context
                let urlString = (imageLink)!
                
                
                let imageURL = URL(string: urlString)
                
                cell.senderImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
                
                return cell
                
            }
                
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImage") as! RecieverImage_Cell
                
                cell.selectionStyle = .none
                
                let imageLink = allMessage[indexPath.row].context
                let urlString = (imageLink)!
                
                let imageURL = URL(string: urlString)
                
                cell.recieverImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
                
                return cell
                
            }
        }
            
        else if self.allMessage[indexPath.row].type! == "CRYPTO"{
            
            if self.senderId == self.allMessage[indexPath.row].composerId!{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCrypto") as! SenderAmount_Cell
                
                cell.selectionStyle = .none
                
                var contxtArr = [String]()
                
                let splitContext = self.allMessage[indexPath.row].context.split(separator: "_")
                
               
                splitContext.forEach { (value) in
                    
                    let str = String(value)
                    contxtArr.append(str)
                    
                }
                
//                print(contxtArr)
                
                cell.senderName.text = senderDetail?.displayName
                cell.senderAmount.text = "sent \((contxtArr.last)!)"
                cell.senderCrypto.image =  UIImage(named: (contxtArr.first)!)
                
                
                return cell
                
            }
                
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCrypto") as! ReceiverAmount_Cell
                
                cell.selectionStyle = .none
                
                
                
                return cell
            }
            
            
            
        }
            
        else {
            return UITableViewCell()
            
        }
        
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if indexPath.row < allMessage.count{
            
            if allMessage[indexPath.row].type == "MEDIA"{
                return 300
                
            }
            else{
                return UITableView.automaticDimension
            }
        }
        else{
            return 0
        }
        
        //
    }
    
    
    
}

//********************************* TEXTFIELD DELEGATE *********************************


extension chatRoomVC: UITextViewDelegate{
    
    
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Say Something..." {
            textView.text = ""
            ChatTextField.textColor = UIColor.black
            
        }
        
        return true
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if ChatTextField.contentSize.height < maxheight{
            textViewHeight.constant = ChatTextField.contentSize.height
        }
        
        if (text == "\n") {
            
            
            
            self.returnAction()
            textView.resignFirstResponder()
            
            
        }
        
        return true
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "" {
            textView.text = "Say Something..."
            ChatTextField.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
            
        }
        
        
        return true
    }
    
}




//********************************* IMAGEPICKER DELEGATE *********************************


extension chatRoomVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        print(selectedImage)
        
        self.selectedBitMoji = selectedImage
        
        //
        
        self.textViewHeight.constant = 80
        self.ChatBitmojiImage.image = selectedImage
        self.ChatBitmojiImage.isHidden = false
        self.textFieldMsgStatus = false
        
        self.ChatTextField.becomeFirstResponder()
        self.ChatTextField.isHidden = true
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
}
