//
//  MemberMgr.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/4/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class MemberMgr: ManagerSuperType {
    func create (_ classType: Member) {
        let factory: Factory! = Factory()
        let memberSvc: IMemberSQLiteSvc! = (factory.getService(serviceName: "MemberSvcSQLiteImpl") as? IMemberSQLiteSvc)
        memberSvc.create(classType)
    }
    
    func retrieveAll () -> [Member] {
        let factory: Factory! = Factory()
        let memberSvc: IMemberSQLiteSvc! = (factory.getService(serviceName: "MemberSvcSQLiteImpl") as? IMemberSQLiteSvc)
        let members = memberSvc.retrieveAll()
        
        return members
    }
    
    func update (_ classType: Member, index: Int) {
        let factory: Factory! = Factory()
        let memberSvc: IMemberSQLiteSvc! = (factory.getService(serviceName: "MemberSvcSQLiteImpl") as? IMemberSQLiteSvc)
        memberSvc.update(classType, index: index)
    }
    
    func delete (_ classType: Member) {
        let factory: Factory! = Factory()
        let memberSvc: IMemberSQLiteSvc! = (factory.getService(serviceName: "MemberSvcSQLiteImpl") as? IMemberSQLiteSvc)
        memberSvc.delete(classType)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let memberSvc: IMemberSQLiteSvc! = (factory.getService(serviceName: "MemberSvcSQLiteImpl") as? IMemberSQLiteSvc)
        let count = memberSvc.getCount()
        
        return count
    }
    
    func getEvent(_ index: Int) -> Member {
        let factory: Factory! = Factory()
        let memberSvc: IMemberSQLiteSvc! = (factory.getService(serviceName: "MemberSvcSQLiteImpl") as? IMemberSQLiteSvc)
        let member: Member = memberSvc.getMember(index)
        
        return member
    }
}
