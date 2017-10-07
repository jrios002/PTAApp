//
//  IEventSQLiteSvc.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/4/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol IEventSQLiteSvc: IService {
    func create (_ classType: Event)
    func retrieveAll () -> [Event]
    func update (_ classType: Event, index: Int)
    func delete (_ classType: Event)
    
    func getCount() -> Int
    func getEvent(_ index: Int) -> Event
}
