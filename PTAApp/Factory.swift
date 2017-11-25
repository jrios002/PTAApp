//
//  Factory.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/25/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class Factory {
    
    func getService (serviceName: String) -> IService {
        let plistString: String = getImplName(serviceName: serviceName)
        
        switch plistString {
        case "FireLoginSvc":
            return FireLoginSvc()
            
        case "EventSvcSQLite":
            return EventSvcSQLite()
            
        case "MemberSvcSQLite":
            return MemberSvcSQLite()
            
        case "SchoolSvcSQLite":
            return SchoolSvcSQLite()
            
        case "SchoolFirebaseDBService":
            return SchoolFirebaseDBService()
            
        case "EventFirebaseDBService":
            return EventFirebaseDBService()
            
        case "MemberFirebaseDBService":
            return MemberFirebaseDBService()
            
        case "ItemForSaleFirebaseDBService":
            return ItemForSaleFirebaseDBService()
        
        default:
            return FireLoginSvc()
        }
    }
    
    func getImplName(serviceName: String) -> String{
        var className: String = ""
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist"){
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot as? [String: AnyObject] {
                className = dict[serviceName] as! String
            }
            else {
                print("Unable to get className")
            }
        }
        
        return className
    }
    
}
