//
//  SchoolMgr.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/5/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class SchoolMgr: ManagerSuperType {
    func create (_ classType: School) {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolFirebaseSvc! = (factory.getService(serviceName: "SchoolSvcFirebaseImpl") as? ISchoolFirebaseSvc)
        schoolSvc.create(classType)
    }
    
    func retrieveAll () -> [School] {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolFirebaseSvc! = (factory.getService(serviceName: "SchoolSvcFirebaseImpl") as? ISchoolFirebaseSvc)
        let schools = schoolSvc.retrieveAll()
        
        return schools
    }
    
    func update (_ classType: School, index: Int) {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolFirebaseSvc! = (factory.getService(serviceName: "SchoolSvcFirebaseImpl") as? ISchoolFirebaseSvc)
        schoolSvc.update(classType, index: index)
    }
    
    func delete (_ classType: School) {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolFirebaseSvc! = (factory.getService(serviceName: "SchoolSvcFirebaseImpl") as? ISchoolFirebaseSvc)
        schoolSvc.delete(classType)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolFirebaseSvc! = (factory.getService(serviceName: "SchoolSvcFirebaseImpl") as? ISchoolFirebaseSvc)
        let count = schoolSvc.getCount()
        
        return count
    }
    
    func getSchool(_ index: Int) -> School {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolFirebaseSvc! = (factory.getService(serviceName: "SchoolSvcFirebaseImpl") as? ISchoolFirebaseSvc)
        let school: School = schoolSvc.getSchool(index)
        
        return school
    }
    
    func getMessage() -> String {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolFirebaseSvc! = (factory.getService(serviceName: "SchoolSvcFirebaseImpl") as? ISchoolFirebaseSvc)
        let message = schoolSvc.retrieveMessage()
        
        return message
    }
}
