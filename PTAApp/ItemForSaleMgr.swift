//
//  ItemForSaleMgr.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/13/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class ItemForSaleMgr: ManagerSuperType {
    func create (_ classType: ItemForSale, school: School) {
        let factory: Factory! = Factory()
        let itemSvc: IItemsForSaleFirebaseSvc! = (factory.getService(serviceName: "ItemSvcFirebaseImpl") as? IItemsForSaleFirebaseSvc)
        itemSvc.create(classType, school: school)
    }
    
    func retrieveAll () -> [ItemForSale] {
        let factory: Factory! = Factory()
        let itemSvc: IItemsForSaleFirebaseSvc! = (factory.getService(serviceName: "ItemSvcFirebaseImpl") as? IItemsForSaleFirebaseSvc)
        let items = itemSvc.retrieveAll()
        
        return items
    }
    
    func update (_ classType: ItemForSale, _ oldClassType: ItemForSale, school: School) {
        let factory: Factory! = Factory()
        let itemSvc: IItemsForSaleFirebaseSvc! = (factory.getService(serviceName: "ItemSvcFirebaseImpl") as? IItemsForSaleFirebaseSvc)
        itemSvc.update(classType, oldClassType, school: school)
    }
    
    func delete (_ classType: ItemForSale, school: School) {
        let factory: Factory! = Factory()
        let itemSvc: IItemsForSaleFirebaseSvc! = (factory.getService(serviceName: "ItemSvcFirebaseImpl") as? IItemsForSaleFirebaseSvc)
        itemSvc.delete(classType, school: school)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let itemSvc: IItemsForSaleFirebaseSvc! = (factory.getService(serviceName: "ItemSvcFirebaseImpl") as? IItemsForSaleFirebaseSvc)
        let count = itemSvc.getCount()
        
        return count
    }
    
    func getItemForSale(_ name: String, school: School) -> ItemForSale {
        let factory: Factory! = Factory()
        let itemSvc: IItemsForSaleFirebaseSvc! = (factory.getService(serviceName: "ItemSvcFirebaseImpl") as? IItemsForSaleFirebaseSvc)
        let item: ItemForSale = itemSvc.getItemForSale(name, school: school)
        
        return item
    }
    
    func getMessage() -> String {
        let factory: Factory! = Factory()
        let itemSvc: IItemsForSaleFirebaseSvc! = (factory.getService(serviceName: "ItemSvcFirebaseImpl") as? IItemsForSaleFirebaseSvc)
        let message = itemSvc.retrieveMessage()
        
        return message
    }
}
