//
//  MemberCartItemFirebaseSvc.swift
//  PTAApp
//
//  Created by Jacob Rios on 12/7/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol MemberCartItemFirebaseSvc: IService {
    func create (_ classType: ItemForSale, member: Member, quantity: Int, cost: Float)
    func retrieveAll () -> [ItemForSale]
    func update (_ classType: ItemForSale, _ oldClassType: ItemForSale, member: Member, quantity: Int, cost: Float)
    func delete (_ classType: ItemForSale, member: Member)
    
    func getCount() -> Int
    func getCartItem (_ name: String, member: Member) -> MemberCartItem
    func retrieveMessage() -> String
}
