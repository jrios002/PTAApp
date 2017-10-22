//
//  IFirebaseService.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/26/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

protocol IFirebaseService: IService {
    func loginUser(email: String, password: String) -> Void
    func emailSignUp (email: String, password: String) -> Void
    func anonymousSignIn() -> Void
    func retrieveMessage() -> String
    func firebaseSignOut() -> Void
}
