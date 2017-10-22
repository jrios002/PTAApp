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
                let sql_stmt = "CREATE TABLE IF NOT EXISTS events (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, date TEXT, beginTime TEXT, endTime TEXT, location TEXT, description TEXT, volunteers TEXT, volunteersBeginTime TEXT, volunteersEndTime)"
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
                        event.beginTime = (results?.string(forColumn: "beginTime"))!
                        event.endTime = (results?.string(forColumn: "endTime"))!
                        event.location = (results?.string(forColumn: "location"))!
                        event.description = (results?.string(forColumn: "description"))!
                        let volunteers: String = (results?.string(forColumn: "volunteers"))!
                        let volunteersBeginTime: String = (results?.string(forColumn: "volunteersBeginTime"))!
                        let volunteersEndTime: String = (results?.string(forColumn: "volunteersEndTime"))!
                        event.volunteers = volunteers.components(separatedBy: ",")
                        event.volunteersBeginTime = volunteersBeginTime.components(separatedBy: ",")
                        event.volunteersEndTime = volunteersEndTime.components(separatedBy: ",")
                        events.append(event)
                    }
                }
                else {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS events (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, date TEXT, beginTime TEXT, endTime TEXT, location TEXT, description TEXT, volunteers TEXT, volunteersBeginTime TEXT, volunteersEndTime TEXT)"
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
        let volunteers: String = (classType.volunteers?.joined(separator: ","))!
        let volunteersBeginTime: String = (classType.volunteersBeginTime?.joined(separator: ","))!
        let volunteersEndTime: String = (classType.volunteersEndTime?.joined(separator: ","))!
        let eventsDB = FMDatabase(path: databasePath! as String)
        
        if (eventsDB.open()){
            let insertSQL = "INSERT INTO events (name, date, beginTime, endTime, location, description, volunteers, volunteersBeginTime, volunteersEndTime) VALUES ('\(classType.name!.replacingOccurrences( of: "'", with: "''"))', '\(classType.date!.replacingOccurrences( of: "'", with: "''"))', '\(classType.beginTime!.replacingOccurrences( of: "'", with: "''"))', '\(classType.endTime!.replacingOccurrences( of: "'", with: "''"))', '\(classType.location!.replacingOccurrences( of: "'", with: "''"))', '\(classType.description!.replacingOccurrences( of: "'", with: "''"))', '\(volunteers.replacingOccurrences( of: "'", with: "''"))', '\(volunteersBeginTime.replacingOccurrences( of: "'", with: "''"))', '\(volunteersEndTime.replacingOccurrences( of: "'", with: "''"))');"
            
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
        let volunteers: String = (classType.volunteers?.joined(separator: ","))!
        let volunteersBeginTime: String = (classType.volunteersBeginTime?.joined(separator: ","))!
        let volunteersEndTime: String = (classType.volunteersEndTime?.joined(separator: ","))!
        let eventsDB: FMDatabase? = FMDatabase(path: databasePath! as String)
        
        if (eventsDB?.open())!{
            let location: String = (classType.id?.description)!
            let updateSQL = "UPDATE events SET name = '\(classType.name!.replacingOccurrences( of: "'", with: "''"))', date = '\(classType.date!.replacingOccurrences( of: "'", with: "''"))', beginTime = '\(classType.beginTime!.replacingOccurrences( of: "'", with: "''"))', endTime = '\(classType.endTime!.replacingOccurrences( of: "'", with: "''"))', location = '\(classType.location!.replacingOccurrences( of: "'", with: "''"))', description = '\(classType.description!.replacingOccurrences( of: "'", with: "''"))', volunteers = '\(volunteers.replacingOccurrences( of: "'", with: "''"))', volunteersBeginTime = '\(volunteersBeginTime.replacingOccurrences( of: "'", with: "''"))', volunteersEndTime = '\(volunteersEndTime.replacingOccurrences( of: "'", with: "''"))' WHERE ID = \(location)"
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
            let location: String = (classType.id?.description)!
            let deleteSQL = "DELETE FROM events WHERE ID = \(location)"
            
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
