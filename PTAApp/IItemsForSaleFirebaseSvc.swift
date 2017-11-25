//
//  IItemsForSaleFirebaseSvc.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/13/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol IItemsForSaleFirebaseSvc: IService {
    func create (_ classType: ItemForSale, school: School)
    func retrieveAll () -> [ItemForSale]
    func update (_ classType: ItemForSale, _ oldClassType: ItemForSale, school: School)
    func delete (_ classType: ItemForSale, school: School)
    
    func getCount() -> Int
    func getItemForSale (_ name: String, school: School) -> ItemForSale
    func retrieveMessage() -> String
}
