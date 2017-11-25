//
//  MemberFirebaseDBService.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/1/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation
import FirebaseDatabase

var memberDBmessage = ""

class MemberFirebaseDBService: IMemberFirebaseSvc {
    var members = [Member]()
    var memberRef: FIRDatabaseReference!
    
    init(){
        
    }
    
    func create(_ classType: Member) {
        memberRef = FIRDatabase.database().reference()
        let email = classType.email
        let newEmail = email?.replacingOccurrences(of: ".", with: "Dot")
        
        memberRef.child("memberList").child(newEmail!).child("firstName").setValue(classType.firstName)
        memberRef.child("memberList").child(newEmail!).child("lastName").setValue(classType.lastName)
        memberRef.child("memberList").child(newEmail!).child("address").setValue(classType.address!)
        memberRef.child("memberList").child(newEmail!).child("city").setValue(classType.city)
        memberRef.child("memberList").child(newEmail!).child("state").setValue(classType.state)
        memberRef.child("memberList").child(newEmail!).child("phone").setValue(classType.phone)
        memberRef.child("memberList").child(newEmail!).child("email").setValue(classType.email)
        memberRef.child("memberList").child(newEmail!).child("ptaTitle").setValue(classType.ptaTitle)
        memberRef.child("memberList").child(newEmail!).child("adminRights").setValue(classType.adminRights)
        memberRef.child("memberList").child(newEmail!).child("schoolAdmin").setValue(classType.schoolAdmin)
    }
    
    func retrieveAll() -> [Member] {
        
        return members
    }
    
    func update(_ classType: Member) {
        memberRef = FIRDatabase.database().reference()
        let email = classType.email
        let newEmail = email?.replacingOccurrences(of: ".", with: "Dot")
        let ref = memberRef.child("memberList").child(newEmail!)
        ref.updateChildValues(["firstName": classType.firstName!, "lastName": classType.lastName!, "address": classType.address!, "city": classType.city!, "state": classType.state!, "phone": classType.phone!, "email": classType.email!, "ptaTitle": classType.ptaTitle!, "adminRights": classType.adminRights!, "schoolAdmin": classType.schoolAdmin!])
    }
    
    func delete(_ classType: Member) {
        memberRef = FIRDatabase.database().reference()
        let email = classType.email
        let newEmail = email?.replacingOccurrences(of: ".", with: "Dot")
        let ref = memberRef.child("memberList").child(newEmail!)
        ref.removeValue { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            
            message = "SUCCESS"
        }
    }
    
    func getCount() -> Int {
        return members.count
    }
    
    func getMember(_ email: String) -> Member {
        let member: Member = Member()
        memberRef = FIRDatabase.database().reference()
        let newEmail = email.replacingOccurrences(of: ".", with: "Dot")
        memberRef.child("memberList").child(newEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! [String: AnyObject]
            
            member.firstName = data["firstName"] as? String
            member.lastName = data["lastName"] as? String
            member.address = data["address"] as? String
            member.city = data["city"] as? String
            member.state = data["state"] as? String
            member.email = data["email"] as? String
            member.phone = data["phone"] as? String
            member.ptaTitle = data["ptaTitle"] as? String
            member.adminRights = data["adminRights"] as? Bool
            member.schoolAdmin = data["schoolAdmin"] as? String
            
            print("MEMBER SUCCESS")
        })
        
        
        return member
    }
    
    func retrieveMessage() -> String {
        print("\(memberDBmessage)")
        return memberDBmessage
    }
}

