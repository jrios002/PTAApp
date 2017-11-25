//
//  EventFirebaseDBService.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/23/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import Firebase

var eventDBmessage = ""

class EventFirebaseDBService: IEventFirebaseSvc {
    var events = [Event]()
    var eventRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    init(){
        
    }
    
    func create(_ classType: Event, school: School) {
        eventRef = FIRDatabase.database().reference()
        
        let schoolNameChild: String = (school.name?.lowercased())!
        let volunteers: String = (classType.volunteers?.joined(separator: ","))!
        let volunteersBeginTime: String = (classType.volunteersBeginTime?.joined(separator: ","))!
        let volunteersEndTime: String = (classType.volunteersEndTime?.joined(separator: ","))!
        let imageName = NSUUID().uuidString
        
        storageRef = FIRStorage.storage().reference(withPath: "images/eventImages/" + imageName + ".png")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/png"
        
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("name").setValue(classType.name)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("date").setValue(classType.date)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("beginTime").setValue(classType.beginTime)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("endTime").setValue(classType.endTime)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("location").setValue(classType.location)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("description").setValue(classType.description)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("volunteers").setValue(volunteers)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("volunteersBeginTime").setValue(volunteersBeginTime)
        eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("volunteersEndTime").setValue(volunteersEndTime)
        
        if classType.eventImage != nil {
            if let uploadImage = UIImagePNGRepresentation(classType.eventImage!) {
                
                storageRef.put(uploadImage, metadata: uploadMetadata, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let eventImgUrl = metadata?.downloadURL()?.absoluteString
                    self.eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!).child("eventImgUrl").setValue(eventImgUrl)
                    print(eventImgUrl!)
                })
            }
        }
    }
    
    func retrieveAll() -> [Event] {
        
        return events
    }
    
    func update(_ classType: Event, _ oldClassType: Event, school: School) {
        create(classType, school: school)
        
        DispatchQueue.main.async {
            self.delete(oldClassType, school: school)
        }
    }
    
    func delete(_ classType: Event, school: School) {
        eventRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference(forURL: classType.eventImgUrl!)
        let schoolNameChild: String = (school.name?.lowercased())!
        let ref = eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(classType.name!)
        ref.removeValue { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            
            message = "SUCCESS"
        }
        
        storageRef.delete { (error) in
            if error != nil {
                print(error!)
            }
            else {
                message = "SUCCESS"
            }
        }
    }
    
    func getCount() -> Int {
        return events.count
    }
    
    func getEvent(_ name: String, school: School) -> Event {
        let event: Event = Event()
        let schoolNameChild: String = (school.name?.lowercased())!
        eventRef = FIRDatabase.database().reference()
        let ref = eventRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("EventsList").child(name)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! [String: AnyObject]
            
            event.name = data["name"] as! String?
            event.date = data["date"] as! String?
            event.beginTime = data["beginTime"] as! String?
            event.endTime = data["endTime"] as! String?
            event.location = data["location"] as! String?
            event.description = data["description"] as! String?
            
            let volunteers: String = data["volunteers"]! as! String
            let volunteersBeginTime: String = data["volunteersBeginTime"]! as! String
            let volunteersEndTime: String = data["volunteersEndTime"]! as! String
            event.volunteers = volunteers.components(separatedBy: ",")
            event.volunteersBeginTime = volunteersBeginTime.components(separatedBy: ",")
            event.volunteersEndTime = volunteersEndTime.components(separatedBy: ",")
            event.eventImgUrl = data["eventImgUrl"] as! String?
            
            print("EVENT SUCCESS")
        })
        
        
        return event
    }
    
    func retrieveMessage() -> String {
        print("\(eventDBmessage)")
        return eventDBmessage
    }

    
}
