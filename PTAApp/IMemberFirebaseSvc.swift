//
//  IMemberFirebaseSvc.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/1/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol IMemberFirebaseSvc: IService {
    func create (_ classType: Member)
    func retrieveAll () -> [Member]
    func update (_ classType: Member)
    func delete (_ classType: Member)
    
    func getCount() -> Int
    func getMember (_ email: String) -> Member
    func retrieveMessage() -> String
}
