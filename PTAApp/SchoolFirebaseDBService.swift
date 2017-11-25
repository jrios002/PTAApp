//
//  SchoolFirebaseDBService.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/23/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation
import Firebase

var firDBmessage = ""

class SchoolFirebaseDBService: ISchoolFirebaseSvc {
    var schools = [School]()
    var schoolRef: FIRDatabaseReference!
    var schoolStorageRef: FIRStorageReference!
    
    init(){
        
    }
    
    func create(_ classType: School) {
        schoolRef = FIRDatabase.database().reference()
        
        let schoolNameChild: String = (classType.name?.lowercased())!
        let imageName = NSUUID().uuidString
        
        schoolStorageRef = FIRStorage.storage().reference(withPath: "images/schoolImages/" + imageName + ".png")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/png"
        
        schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("name").setValue(classType.name)
        schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("address").setValue(classType.address)
        schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("city").setValue(classType.city)
        schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("state").setValue(classType.state)
        schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("zip").setValue(classType.zipCode)
        schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("phone").setValue(classType.phone)
        schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("adminCode").setValue(classType.adminCode)
        
        if classType.schoolImage != nil {
            if let uploadImage = UIImagePNGRepresentation(classType.schoolImage!) {
                
                schoolStorageRef.put(uploadImage, metadata: uploadMetadata, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let schoolImgUrl = metadata?.downloadURL()?.absoluteString
                    self.schoolRef.child("schoolList").child(schoolNameChild + classType.zipCode!).child("schoolImgUrl").setValue(schoolImgUrl)
                    print(schoolImgUrl!)
                })
            }
        }
    }
    
    func retrieveAll() -> [School] {
        
        return schools
    }
    
    func update(_ classType: School, index: Int) {
        
    }
    
    func delete(_ classType: School) {
        schoolRef = FIRDatabase.database().reference()
        schoolStorageRef = FIRStorage.storage().reference(forURL: classType.schoolImgUrl!)
        let child = classType.name?.lowercased()
        let ref = schoolRef.child("schoolList").child(child! + classType.zipCode!)
        ref.removeValue { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            
            firDBmessage = "SUCCESS"
        }
        
        schoolStorageRef.delete { (error) in
            if error != nil {
                print(error!)
                return
            }
            else {
                firDBmessage = "SUCCESS"
            }
        }
    }
    
    func getCount() -> Int {
        return schools.count
    }
    
    func getSchool(_ index: Int) -> School {
        return schools[index]
    }
    
    func retrieveMessage() -> String {
        print("\(firDBmessage)")
        return firDBmessage
    }
}
