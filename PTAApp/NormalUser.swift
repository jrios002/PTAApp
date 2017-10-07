//
//  NormalUser.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/9/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class NormalUser{
    var id: Int64?
    var name: String?
    var address: String?
    var city: String?
    var phone: String?
    var email: String?
    
    func GetDescription() -> String {
        return name! + "::" + address! + "::" + city! + "::" + phone! + "::" + email!
    }
}
