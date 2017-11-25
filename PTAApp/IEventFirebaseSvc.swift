//
//  IEventFirebaseSvc.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/27/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol IEventFirebaseSvc: IService {
    func create (_ classType: Event, school: School)
    func retrieveAll () -> [Event]
    func update (_ classType: Event, _ oldClassType: Event, school: School)
    func delete (_ classType: Event, school: School)
    func getCount() -> Int
    func getEvent (_ name: String, school: School) -> Event
    func retrieveMessage() -> String
}
