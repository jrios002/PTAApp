//
//  Event.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/6/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class Event {
    var id: Int64?
    var name: String?
    var date: String?
    var time: String?
    var location: String?
    var description: String?
    var volunteer: String?
    
    init() {
        name = ""
        date = ""
        time = ""
        location = ""
        description = ""
        volunteer = ""
    }
    
    func GetDescription() -> String {
        return name! + "::" + date! + "::" + time! + "::" + location! + "::" + description! + "::" + volunteer!
    }
}
