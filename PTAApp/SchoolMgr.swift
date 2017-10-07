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
        let schoolSvc: ISchoolSQLiteSvc! = (factory.getService(serviceName: "SchoolSvcSQLiteImpl") as? ISchoolSQLiteSvc)
        schoolSvc.create(classType)
    }
    
    func retrieveAll () -> [School] {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolSQLiteSvc! = (factory.getService(serviceName: "SchoolSvcSQLiteImpl") as? ISchoolSQLiteSvc)
        let schools = schoolSvc.retrieveAll()
        
        return schools
    }
    
    func update (_ classType: School, index: Int) {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolSQLiteSvc! = (factory.getService(serviceName: "SchoolSvcSQLiteImpl") as? ISchoolSQLiteSvc)
        schoolSvc.update(classType, index: index)
    }
    
    func delete (_ classType: School) {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolSQLiteSvc! = (factory.getService(serviceName: "SchoolSvcSQLiteImpl") as? ISchoolSQLiteSvc)
        schoolSvc.delete(classType)
    }
    
    func getCount() -> Int {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolSQLiteSvc! = (factory.getService(serviceName: "SchoolSvcSQLiteImpl") as? ISchoolSQLiteSvc)
        let count = schoolSvc.getCount()
        
        return count
    }
    
    func getSchool(_ index: Int) -> School {
        let factory: Factory! = Factory()
        let schoolSvc: ISchoolSQLiteSvc! = (factory.getService(serviceName: "SchoolSvcSQLiteImpl") as? ISchoolSQLiteSvc)
        let school: School = schoolSvc.getSchool(index)
        
        return school
    }
}
