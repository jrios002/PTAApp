//
//  ISchoolSQLiteSvc.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/5/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol ISchoolSQLiteSvc: IService {
    func create (_ classType: School)
    func retrieveAll () -> [School]
    func update (_ classType: School, index: Int)
    func delete (_ classType: School)
    
    func getCount() -> Int
    func getSchool(_ index: Int) -> School
}