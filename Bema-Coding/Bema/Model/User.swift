//
//  User.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 05/11/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase


class User: Codable{
    
    
    var addedDate: Timestamp!
    var displayName : String!
    var imageUrl : String!
    var isActive : Bool!
    var isDeleted :Bool!
    var userId : String!
    
    
    static var userDetail = User()
}


//extension DocumentReference: DocumentReferenceType {}
//extension GeoPoint: GeoPointType {}
//extension FieldValue: FieldValueType {}
//extension Timestamp: TimestampType {}
