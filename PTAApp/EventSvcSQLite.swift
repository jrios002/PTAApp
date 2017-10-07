//
//  EventSvcSQLite.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/2/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class EventSvcSQLite: IEventSQLiteSvc {
    static let directory: NSString? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let databasePath = directory?.appendingPathComponent("ptaDB")
    
    var events = [Event]()

    init(){
        NSLog("Entering EventSvcSQLite.init")
        let filemgr = FileManager.default
        
        if !filemgr.fileExists(atPath: databasePath!) {
            // if db does not exist, create it
            let eventsDB: FMDatabase? = FMDatabase(path: databasePath! as String)
            
            // create the table
            NSLog("Creating Table")
            if (eventsDB?.open())! {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS events (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, date TEXT, time TEXT, location TEXT, description TEXT, volunteer TEXT)"
                if !((eventsDB?.executeStatements(sql_stmt))!) {
                    print("ERROR: \(eventsDB?.lastErrorMessage())")
                }
                eventsDB?.close()
            } else {
                print("ERROR: \(eventsDB?.lastErrorMessage())")
            }
        } else {
            
            let eventsDB: FMDatabase? = FMDatabase(path: databasePath! as String)
            if (eventsDB?.open())! {
                let querySQL = "SELECT * FROM events"
                let results: FMResultSet? = eventsDB?.executeQuery(querySQL, withArgumentsIn: [])
                
                if results != nil {
                    while results?.next() == true {
                        let event = Event()
                        event.id = (results?.longLongInt(forColumn: "ID"))!
                        event.name = (results?.string(forColumn: "name"))!
                        event.date = (results?.string(forColumn: "date"))!
                        event.time = (results?.string(forColumn: "time"))!
                        event.location = (results?.string(forColumn: "location"))!
                        event.description = (results?.string(forColumn: "description"))!
                        event.volunteer = (results?.string(forColumn: "volunteer"))!
                        events.append(event)
                    }
                }
                else {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS events (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, date TEXT, time TEXT, location TEXT, description TEXT, volunteer TEXT)"
                    if !((eventsDB?.executeStatements(sql_stmt))!) {
                        print("ERROR: \(eventsDB?.lastErrorMessage())")
                    }
                }
                
                eventsDB?.close()
            } else {
                print("ERROR: \(eventsDB?.lastErrorMessage())")
            }
        }
        print("count: \(events.count)")
        NSLog("exiting EventSvcSQLite.init")
    }
    
    func create(_ classType: Event) {
        let eventsDB = FMDatabase(path: databasePath! as String)
        
        if (eventsDB.open()){
            let insertSQL = "INSERT INTO events (name, date, time, location, description, volunteer) VALUES ('\(classType.name!.replacingOccurrences( of: "'", with: "''"))', '\(classType.date!.replacingOccurrences( of: "'", with: "''"))', '\(classType.time!.replacingOccurrences( of: "'", with: "''"))', '\(classType.location!.replacingOccurrences( of: "'", with: "''"))', '\(classType.description!.replacingOccurrences( of: "'", with: "''"))', '\(classType.volunteer!.replacingOccurrences( of: "'", with: "''"))');"
            
            let result = eventsDB.executeUpdate(insertSQL, withArgumentsIn: [])
            
            if !(result){
                NSLog("Failed to add event")
                NSLog("Error: \(eventsDB.lastErrorMessage())")
            } else{
                NSLog("Event added")
                classType.id = eventsDB.lastInsertRowId
                events.append(classType)
                print("count: \(events.count)")
            }
            eventsDB.close()
        } else{
            NSLog("Error: \(eventsDB.lastErrorMessage())")
        }
    }
    
    func retrieveAll() -> [Event] {
        return events
    }
    
    func update(_ classType: Event, index: Int) {
        
        let eventsDB: FMDatabase? = FMDatabase(path: databasePath! as String)
        
        if (eventsDB?.open())!{
            let updateSQL = "UPDATE events SET name = '\(classType.name!.replacingOccurrences( of: "'", with: "''"))', date = '\(classType.date!.replacingOccurrences( of: "'", with: "''"))', time = '\(classType.time!.replacingOccurrences( of: "'", with: "''"))', location = '\(classType.location!.replacingOccurrences( of: "'", with: "''"))', description = '\(classType.description!.replacingOccurrences( of: "'", with: "''"))', volunteer = '\(classType.volunteer!.replacingOccurrences( of: "'", with: "''"))', WHERE ID = \(classType.id);"
            let result = eventsDB?.executeUpdate(updateSQL, withArgumentsIn: [])
            if !result! {
                NSLog("Failed to update event")
                NSLog("Error: \(eventsDB?.lastErrorMessage())")
            } else {
                var number = 0
                for next in events {
                    if next.id == classType.id {
                        events[number] = classType
                        break
                    }
                    number += 1
                }
                NSLog("Event updated")
            }
            eventsDB?.close()
        } else {
            NSLog("Error: \(eventsDB?.lastErrorMessage())")
        }
    }
    
    func delete(_ classType: Event) {
        let eventsDB = FMDatabase(path: databasePath! as String)
        if (eventsDB.open()) {
            let deleteSQL = "DELETE FROM events WHERE ID = \(classType.id)"
            
            let result = eventsDB.executeUpdate(deleteSQL, withArgumentsIn: [])
            if !result {
                NSLog("Failed to delete event")
                NSLog("Error: \(eventsDB.lastErrorMessage())")
            } else {
                var index = 0
                for next in events {
                    if next.id == classType.id {
                        events.remove(at: index)
                        break
                    }
                    index += 1
                }
                NSLog("Event deleted")
            }
            eventsDB.close()
        } else {
            NSLog("Error: \(eventsDB.lastErrorMessage())")
        }
    }
    
    func getCount() -> Int {
        return events.count
    }
    
    func getEvent(_ index: Int) -> Event {
        return events[index]
    }
    
    
}
