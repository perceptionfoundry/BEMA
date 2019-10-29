//
//  chatRoomVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 29/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class chatRoomVC: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var ChatTextField : UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var chatMsg_view: UIView!
     @IBOutlet weak var navi_view: UIView!
    var maxheight:CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(navi_view.center.y)
            print(chatMsg_view.center.y)
        
        ChatTextField.delegate = self
        
        ChatTextField.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
        
    }
    

    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        if textView.text == "Say Something..." {
            textView.text = ""
            ChatTextField.textColor = UIColor.black

        }
        
        print(navi_view.center.y)
        print(chatMsg_view.center.y)
            
        

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
     print(navi_view.center.y)
     print(chatMsg_view.center.y)
        
        return true
    }

}
