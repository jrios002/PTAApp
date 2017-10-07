//
//  Member.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/6/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class Member {
    var id: Int64?
    var name: String?
    var address: String?
    var city: String?
    var state: String?
    var phone: String?
    var email: String?
    var adminRights: Bool?
    var ptaTitle: String?
    
    func GetDescription() -> String {
        let adminRightToString: String? = adminRights?.description
        return name! + "::" + address! + "::" + city! + "::" + phone! + "::" + email! + "::" + ptaTitle! + "::" + adminRightToString!
    }
}
