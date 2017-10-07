//
//  ManagerSuperType.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/26/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class ManagerSuperType{
    private var factory: Factory! = Factory()
    
    // Method each manager will inherit to get service desired
    public func getService(name: String!) -> IService! {
        return factory.getService(serviceName: name)
    }
}
