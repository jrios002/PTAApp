//
//  School.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/6/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class School{
    var id: Int64?
    var name: String?
    var address: String?
    var city: String?
    var state: String?
    var phone: String?
    var adminCode: String?
    var zipCode: String?
    var schoolImage: UIImage?
    var schoolImgUrl: String?
    
    init(){
        name = ""
        address = ""
        city = ""
        state = ""
        phone = ""
        adminCode = ""
        zipCode = ""
        schoolImgUrl = ""
    }
    
    func GetDescription() -> String {
        return name! + "::" + address! + "::" + city! + "::" + phone! + "::" + zipCode! + "::" + schoolImgUrl!
    }
}
