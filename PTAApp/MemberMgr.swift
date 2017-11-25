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
        let memberSvc: IMemberFirebaseSvc! = (factory.getService(serviceName: "MemberSvcFirebaseImpl") as? IMemberFirebaseSvc)
        memberSvc.create(classType)
    }
    
    func retrieveAll () -> [Member] {
        let factory: Factory! = Factory()
        let memberSvc: IMemberFirebaseSvc! = (factory.getService(serviceName: "MemberSvcFirebaseImpl") as? IMemberFirebaseSvc)
        let members = memberSvc.retrieveAll()
        
        return members
    }
    
    func update (_ classType: Member) {
        let factory: Factory! = Factory()
        let memberSvc: IMemberFirebaseSvc! = (factory.getService(serviceName: "MemberSvcFirebaseImpl") as? IMemberFirebaseSvc)
        memberSvc.update(classType)
    }
    
    func delete (_ classType: Member) {
        let factory: Factory! = Factory()
        let memberSvc: IMemberFirebaseSvc! = (factory.getService(serviceName: "MemberSvcFirebaseImpl") as? IMemberFirebaseSvc)
        memberSvc.delete(classType)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let memberSvc: IMemberFirebaseSvc! = (factory.getService(serviceName: "MemberSvcFirebaseImpl") as? IMemberFirebaseSvc)
        let count = memberSvc.getCount()
        
        return count
    }
    
    func getMember(_ email: String) -> Member {
        let factory: Factory! = Factory()
        let memberSvc: IMemberFirebaseSvc! = (factory.getService(serviceName: "MemberSvcFirebaseImpl") as? IMemberFirebaseSvc)
        let member: Member = memberSvc.getMember(email)
        
        return member
    }
    
    func getMessage() -> String {
        let factory: Factory! = Factory()
        let memberSvc: IMemberFirebaseSvc! = (factory.getService(serviceName: "MemberSvcFirebaseImpl") as? IMemberFirebaseSvc)
        let message = memberSvc.retrieveMessage()
        
        return message
    }
}
