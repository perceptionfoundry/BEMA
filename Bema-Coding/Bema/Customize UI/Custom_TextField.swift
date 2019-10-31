//
//  Custom_TextField.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 29/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class Custom_TextField: UITextView {

   
     @IBInspectable var C_Radius : CGFloat = 0 {
          didSet{
              layer.cornerRadius = C_Radius
              
              
          }
     
      }
    

}
