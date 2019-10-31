//
//  Custom_Label.swift
//  Doctor-End-APP
//
//  Created by Syed ShahRukh Haider on 02/07/2018.
//  Copyright © 2018 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class Custom_Label: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
       @IBInspectable var bottomInset: CGFloat = 5.0
       @IBInspectable var leftInset: CGFloat = 7.0
       @IBInspectable var rightInset: CGFloat = 7.0

       override func drawText(in rect: CGRect) {
           let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
           super.drawText(in: rect.inset(by: insets))
       }

       override var intrinsicContentSize: CGSize {
           let size = super.intrinsicContentSize
           return CGSize(width: size.width + leftInset + rightInset,
                         height: size.height + topInset + bottomInset)
       }    
    
    

    @IBInspectable var C_Radius : CGFloat = 0 {
        didSet{
            layer.cornerRadius = C_Radius
            
            
        }
        
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var border_color : UIColor = UIColor.clear {
        
        didSet{
            layer.borderWidth = 1
            
            layer.borderColor = border_color.cgColor
        }
    }
    
    @IBInspectable var border_width : CGFloat = 0{
        didSet{
            
            layer.borderWidth = border_width
        }
        
    }

}
