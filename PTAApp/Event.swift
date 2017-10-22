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
    var beginTime: String?
    var endTime: String?
    var location: String?
    var description: String?
    var volunteers: [String]?
    var volunteersBeginTime: [String]?
    var volunteersEndTime: [String]?
    
    init() {
        name = ""
        date = ""
        beginTime = ""
        endTime = ""
        location = ""
        description = ""
        volunteers = [String]()
        volunteersBeginTime = [String]()
        volunteersEndTime = [String]()
    }
    
    func GetDescription() -> String {
        return name! + "::" + date! + "::" + beginTime! + "::" + endTime! + "::" + location! + "::" + description!
    }
}
