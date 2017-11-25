//
//  EventMgr.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/2/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class EventMgr: ManagerSuperType {
    func create (_ classType: Event, school: School) {
        let factory: Factory! = Factory()
        let eventSvc: IEventFirebaseSvc! = (factory.getService(serviceName: "EventSvcFirebaseImpl") as? IEventFirebaseSvc)
        eventSvc.create(classType, school: school)
    }
    
    func retrieveAll () -> [Event] {
        let factory: Factory! = Factory()
        let eventSvc: IEventFirebaseSvc! = (factory.getService(serviceName: "EventSvcFirebaseImpl") as? IEventFirebaseSvc)
        let events = eventSvc.retrieveAll()
        
        return events 
    }
    
    func update (_ classType: Event, _ oldClassType: Event, school: School) {
        let factory: Factory! = Factory()
        let eventSvc: IEventFirebaseSvc! = (factory.getService(serviceName: "EventSvcFirebaseImpl") as? IEventFirebaseSvc)
        eventSvc.update(classType, oldClassType, school: school)
    }
    
    func delete (_ classType: Event, school: School) {
        let factory: Factory! = Factory()
        let eventSvc: IEventFirebaseSvc! = (factory.getService(serviceName: "EventSvcFirebaseImpl") as? IEventFirebaseSvc)
        eventSvc.delete(classType, school: school)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let eventSvc: IEventFirebaseSvc! = (factory.getService(serviceName: "EventSvcFirebaseImpl") as? IEventFirebaseSvc)
        let count = eventSvc.getCount()
        
        return count
    }
    
    func getEvent(_ name: String, school: School) -> Event {
        let factory: Factory! = Factory()
        let eventSvc: IEventFirebaseSvc! = (factory.getService(serviceName: "EventSvcFirebaseImpl") as? IEventFirebaseSvc)
        let event: Event = eventSvc.getEvent(name, school: school)
        
        return event
    }
    
    func getMessage() -> String {
        let factory: Factory! = Factory()
        let eventSvc: IEventFirebaseSvc! = (factory.getService(serviceName: "EventSvcFirebaseImpl") as? IEventFirebaseSvc)
        let message = eventSvc.retrieveMessage()
        
        return message
    }
}
