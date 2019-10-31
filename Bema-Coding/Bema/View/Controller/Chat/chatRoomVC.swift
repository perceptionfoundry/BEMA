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

class chatRoomVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var ChatTableView : UITableView!
    @IBOutlet weak var ChatTextField : UITextView!
    @IBOutlet weak var ChatBitmojiImage : UIImageView!

    @IBOutlet weak var textViewHeight: NSLayoutConstraint!

    @IBOutlet weak var chatMsg_view: UIView!
    
    
    
    var selectedBitMoji : UIImage?
    private var bitmojiSelectionView: UIView?

    
    var maxheight:CGFloat = 80
    
    var dumpMsg = [["Type":"Sender","msg":"hi Shahrukh"],
                    ["Type":"Reciever","msg":"hi Gray"],
    ["Type":"Sender","msg":"i have job for you"],
    ["Type":"Sender","msg":"it is iOS developmsd fg sd fg sd fg sd fg s dfg s dfg s gent with snapkit integration"],
    ["Type":"Reciever","msg":"ok"],
    ["Type":"Reciever","msg":"what's your budget"]]
    var bubbleHeight = [CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ChatBitmojiImage.isHidden = true
        
        ChatTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction))
        
        ChatTextField.delegate = self
        
        ChatTextField.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
        
        //********* NIB REGISTERATION *********
        let senderTextXib = UINib(nibName: "SenderText_Cell", bundle: nil)
        ChatTableView.register(senderTextXib, forCellReuseIdentifier: "SenderText")
        
        let receiverTextXib = UINib(nibName: "RecieverText_Cell", bundle: nil)
        ChatTableView.register(receiverTextXib, forCellReuseIdentifier: "ReceiverText")
        
        
        
        let senderImageXib = UINib(nibName: "SenderImage_Cell", bundle: nil)
           ChatTableView.register(senderImageXib, forCellReuseIdentifier: "SenderImage")
        
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        ChatTableView.reloadData()
    }
    

    @objc func doneAction(){
        
        self.ChatBitmojiImage.isHidden = true
        self.textViewHeight.constant = 35
        self.ChatTextField.isHidden = false
        self.ChatTableView.reloadData()
    }

    
    
    //********* TABLEVIEW DELEGATE ************

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dumpMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if dumpMsg[indexPath.row]["Type"] == "Sender"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderText") as! SenderText_Cell
            
            cell.selectionStyle = .none
            

            
            cell.senderMessageLabel.text = dumpMsg[indexPath.row]["msg"]
//
            return cell
        }
        
        else if dumpMsg[indexPath.row]["Type"] == "Reciever"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverText") as! RecieverText_Cell
            
            cell.selectionStyle = .none

            cell.receiverMessageLabel.text = dumpMsg[indexPath.row]["msg"]

            return cell

        }
        
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImage") as! SenderImage_Cell
                   
                   cell.selectionStyle = .none

                    cell.senderImage.image = self.selectedBitMoji
//                   self.bubbleHeight.append(500)
                   return cell
        }
       
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {


        if indexPath.row < dumpMsg.count{

            if dumpMsg[indexPath.row]["Type"] == "Image"{
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
        
        if (text == "\n") {
            self.ChatBitmojiImage.isHidden = true
            self.textViewHeight.constant = 35
            textView.resignFirstResponder()
            self.ChatTextField.isHidden = false
            self.ChatTableView.reloadData()

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
    
    
    
    
    //********** OUTLET **********
    
    
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

    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}



extension chatRoomVC: SCSDKBitmojiStickerPickerViewControllerDelegate {
    
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String, image: UIImage?) {
        
        
        UIImage.load()
        
        if let image = UIImage.load(from: bitmojiURL) {
            DispatchQueue.main.async {
//                self.setImageToScene(image: image)
                self.selectedBitMoji = image
                
                let dict  = ["Type":"Image","image": "demo"]
                self.dumpMsg.append(dict)
                
                self.textViewHeight.constant = 80
                self.ChatBitmojiImage.image = image
                self.ChatBitmojiImage.isHidden = false
                
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
