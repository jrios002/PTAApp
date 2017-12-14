//
//  MemberCartMgr.swift
//  PTAApp
//
//  Created by Jacob Rios on 12/10/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class MemberCartMgr: ManagerSuperType {
    func create (_ classType: ItemForSale, member: Member, quantity: Int, cost: Float) {
        let factory: Factory! = Factory()
        let itemSvc: MemberCartItemFirebaseSvc! = (factory.getService(serviceName: "MemberCartItemFirebaseImpl") as? MemberCartItemFirebaseSvc)
        itemSvc.create(classType, member: member, quantity: quantity, cost: cost)
    }
    
    func retrieveAll () -> [ItemForSale] {
        let factory: Factory! = Factory()
        let itemSvc: MemberCartItemFirebaseSvc! = (factory.getService(serviceName: "MemberCartItemFirebaseImpl") as? MemberCartItemFirebaseSvc)
        let items = itemSvc.retrieveAll()
        
        return items
    }
    
    func update (_ classType: ItemForSale, _ oldClassType: ItemForSale, member: Member, quantity: Int, cost: Float) {
        let factory: Factory! = Factory()
        let itemSvc: MemberCartItemFirebaseSvc! = (factory.getService(serviceName: "MemberCartItemFirebaseImpl") as? MemberCartItemFirebaseSvc)
        itemSvc.update(classType, oldClassType, member: member, quantity: quantity, cost: cost)
    }
    
    func delete (_ classType: ItemForSale, member: Member) {
        let factory: Factory! = Factory()
        let itemSvc: MemberCartItemFirebaseSvc! = (factory.getService(serviceName: "MemberCartItemFirebaseImpl") as? MemberCartItemFirebaseSvc)
        itemSvc.delete(classType, member: member)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let itemSvc: MemberCartItemFirebaseSvc! = (factory.getService(serviceName: "MemberCartItemFirebaseImpl") as? MemberCartItemFirebaseSvc)
        let count = itemSvc.getCount()
        
        return count
    }
    
    func getCartItem(_ name: String, member: Member) -> MemberCartItem {
        let factory: Factory! = Factory()
        let itemSvc: MemberCartItemFirebaseSvc! = (factory.getService(serviceName: "MemberCartItemFirebaseImpl") as? MemberCartItemFirebaseSvc)
        let cartItem: MemberCartItem = itemSvc.getCartItem(name, member: member)
        
        return cartItem
    }
    
    func getMessage() -> String {
        let factory: Factory! = Factory()
        let itemSvc: MemberCartItemFirebaseSvc! = (factory.getService(serviceName: "MemberCartItemFirebaseImpl") as? MemberCartItemFirebaseSvc)
        let message = itemSvc.retrieveMessage()
        
        return message
    }
}
