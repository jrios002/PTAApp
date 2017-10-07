//
//  EventMgr.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/2/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class EventMgr: ManagerSuperType {
    func create (_ classType: Event) {
        let factory: Factory! = Factory()
        let eventSvc: IEventSQLiteSvc! = (factory.getService(serviceName: "EventSvcSQLiteImpl") as? IEventSQLiteSvc)
        eventSvc.create(classType)
    }
    
    func retrieveAll () -> [Event] {
        let factory: Factory! = Factory()
        let eventSvc: IEventSQLiteSvc! = (factory.getService(serviceName: "EventSvcSQLiteImpl") as? IEventSQLiteSvc)
        let events = eventSvc.retrieveAll()
        
        return events 
    }
    
    func update (_ classType: Event, index: Int) {
        let factory: Factory! = Factory()
        let eventSvc: IEventSQLiteSvc! = (factory.getService(serviceName: "EventSvcSQLiteImpl") as? IEventSQLiteSvc)
        eventSvc.update(classType, index: index)
    }
    
    func delete (_ classType: Event) {
        let factory: Factory! = Factory()
        let eventSvc: IEventSQLiteSvc! = (factory.getService(serviceName: "EventSvcSQLiteImpl") as? IEventSQLiteSvc)
        eventSvc.delete(classType)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let eventSvc: IEventSQLiteSvc! = (factory.getService(serviceName: "EventSvcSQLiteImpl") as? IEventSQLiteSvc)
        let count = eventSvc.getCount()
        
        return count
    }
    
    func getEvent(_ index: Int) -> Event {
        let factory: Factory! = Factory()
        let eventSvc: IEventSQLiteSvc! = (factory.getService(serviceName: "EventSvcSQLiteImpl") as? IEventSQLiteSvc)
        let event: Event = eventSvc.getEvent(index) 
        
        return event
    }
}
