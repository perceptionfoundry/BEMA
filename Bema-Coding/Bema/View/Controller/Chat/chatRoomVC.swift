//
//  chatRoomVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 29/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class chatRoomVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var ChatTableView : UITableView!
    @IBOutlet weak var ChatTextField : UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatMsg_view: UIView!
    
    
    
    var maxheight:CGFloat = 80
    
    var dumpMsg  = [["Type":"Sender","msg":"hi there"],
                    ["Type":"Reciever","msg":"hi there"],
    ["Type":"Sender","msg":"i have job for you"],
    ["Type":"Sender","msg":"it is iOS development with snapkit integration"],
    ["Type":"Reciever","msg":"ok"],
    ["Type":"Reciever","msg":"what's your budget"],]
    var bubbleHeight = [CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      
        
        ChatTextField.delegate = self
        
        ChatTextField.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
        
        //********* NIB REGISTERATION *********
        let senderXib = UINib(nibName: "SenderText_Cell", bundle: nil)
        ChatTableView.register(senderXib, forCellReuseIdentifier: "SenderText")
        
        let receiverXib = UINib(nibName: "RecieverText_Cell", bundle: nil)
        ChatTableView.register(receiverXib, forCellReuseIdentifier: "ReceiverText")
        
        
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        ChatTableView.reloadData()
    }
    

    

    
    
    //********* TABLEVIEW DELEGATE ************

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dumpMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if dumpMsg[indexPath.row]["Type"] == "Sender"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderText") as! SenderText_Cell
            
            cell.selectionStyle = .none
            
            cell.senderMessageText.text  = dumpMsg[indexPath.row]["msg"]
            self.bubbleHeight.append(cell.senderMessageText.contentSize.height)
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverText") as! RecieverText_Cell
            
            cell.selectionStyle = .none

            cell.receiverMessageText.text  = dumpMsg[indexPath.row]["msg"]
            self.bubbleHeight.append(cell.receiverMessageText.contentSize.height)
            return cell

        }
        
        
       
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

        if indexPath.row < dumpMsg.count{
            return self.bubbleHeight[indexPath.row] + 25
        }
        else{
            return 0
        }

        
    }
    
    
    
    
    //********* TEXTFIELD DELEGATE ************
    
    
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
