//
//  AllProtocols.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 21/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import Foundation



protocol ContactList_Protocol {
    
    func FetchContact(userDetail:[String:Any])
}


protocol cryptoTransition {
    func ConfiguredCrypto(value: [String : String])
}


protocol DoubleSegueProtocol {
    func quit()
}
