//
//  Message.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 06/11/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import Foundation


class Message: Codable{
    
    var senderId : String!
    var receiverId : String!
    var composerId : String!
     var type: String!
    var context  : String!
    var isDeleted : Bool!
    
}
