//
//  IMemberSQLiteSvc.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/4/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol IMemberSQLiteSvc: IService {
    func create (_ classType: Member)
    func retrieveAll () -> [Member]
    func update (_ classType: Member, index: Int)
    func delete (_ classType: Member)
    
    func getCount() -> Int
    func getMember(_ index: Int) -> Member
}
