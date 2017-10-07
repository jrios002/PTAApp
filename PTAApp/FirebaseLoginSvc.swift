//
//  FirebaseLoginService.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/24/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation
import FirebaseAuth

var message: String = ""

class FireLoginSvc: IFirebaseService {
    
    var email: String
    var password: String
    
    required init () {
        email = ""
        password = ""
        try! FIRAuth.auth()!.signOut()
    }
    
    func loginUser (email: String, password: String) -> Void {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
            if user != nil
            {
                message = "SUCCESS"
                print("SUCCESS")
            }
            else
            {
                message = "ERROR"
                if let myError = error?.localizedDescription
                {
                    print(myError)
                }
                else
                {
                    print("ERROR")
                }
            }
        })
    }
    
    func emailSignUp (email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
            if user != nil
            {
                message = "SUCCESS"
                print("SUCCESS")
            }
            else
            {
                if let myError = error?.localizedDescription
                {
                    print(myError)
                    message = "ERROR"
                }
                else
                {
                    message = "ERROR"
                    print("ERROR")
                }
            }
        })
    }
    
    func anonymousSignIn() -> Void {
        FIRAuth.auth()?.signInAnonymously(completion: {(user, error) in
            if let err = error {
                NSLog("EXCEPTION: \(err.localizedDescription)")
                return
            }
        })
    }
    
    func retrieveMessage() -> String {
        print("\(message)")
        return message
    }
}
