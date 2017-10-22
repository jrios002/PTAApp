//
//  FirebaseMgr.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/26/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class FirebaseMgr: ManagerSuperType{
    
    func userLogin(email: String, password: String) {
        let factory: Factory! = Factory()
        let firebaseSvc: IFirebaseService! = (factory.getService(serviceName: "FirebaseLoginSvcImpl") as? IFirebaseService)
        firebaseSvc.loginUser(email: email, password: password)
    }
    
    func emailSignUp(email: String, password: String) {
        let factory: Factory! = Factory()
        let firebaseSvc: IFirebaseService! = (factory.getService(serviceName: "FirebaseLoginSvcImpl") as? IFirebaseService)
        firebaseSvc.emailSignUp(email: email, password: password)
    }
    
    func anonSignIn(){
        let factory: Factory! = Factory()
        let firebaseSvc: IFirebaseService! = (factory.getService(serviceName: "FirebaseLoginSvcImpl") as? IFirebaseService)
        firebaseSvc.anonymousSignIn()
    }
    
    func getMessage() -> String {
        let factory: Factory! = Factory()
        let firebaseSvc: IFirebaseService! = (factory.getService(serviceName: "FirebaseLoginSvcImpl") as? IFirebaseService)
        let message = firebaseSvc.retrieveMessage()
        
        return message
    }
    
    func signOutFirebase(){
        let factory: Factory! = Factory()
        let firebaseSvc: IFirebaseService! = (factory.getService(serviceName: "FirebaseLoginSvcImpl") as? IFirebaseService)
        firebaseSvc.firebaseSignOut()
    }
}
