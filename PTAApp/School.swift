//
//  School.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/6/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class School{
    var id: Int64?
    var name: String?
    var address: String?
    var city: String?
    var state: String?
    var phone: String?
    var adminCode: String?
    
    func GetDescription() -> String {
        return name! + "::" + address! + "::" + city! + "::" + phone!
    }
}
