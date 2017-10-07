//
//  SchoolSvcSQLite.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/5/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class SchoolSvcSQLite: ISchoolSQLiteSvc {
    static let directory: NSString? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let databasePath = directory?.appendingPathComponent("ptaDB")
    
    var schools = [School]()
    
    init(){
        NSLog("Entering SchoolSvcSQLite.init")
        let filemgr = FileManager.default
        
        if !filemgr.fileExists(atPath: databasePath!) {
            // if db does not exist, create it
            let schoolsDB: FMDatabase? = FMDatabase(path: databasePath! as String)
            
            // create the table
            NSLog("Creating Table")
            if (schoolsDB?.open())! {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS schools (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, address TEXT, city TEXT, state TEXT, phone TEXT, adminCode TEXT)"
                if !((schoolsDB?.executeStatements(sql_stmt))!) {
                    print("ERROR: \(schoolsDB?.lastErrorMessage())")
                }
                schoolsDB?.close()
            } else {
                print("ERROR: \(schoolsDB?.lastErrorMessage())")
            }
        } else {
            
            let schoolsDB: FMDatabase? = FMDatabase(path: databasePath! as String)
            if (schoolsDB?.open())! {
                let querySQL = "SELECT * FROM schools"
                let results: FMResultSet? = schoolsDB?.executeQuery(querySQL, withArgumentsIn: [])
                
                if results != nil {
                    while results?.next() == true {
                        let school = School()
                        school.id = (results?.longLongInt(forColumn: "ID"))!
                        school.name = (results?.string(forColumn: "name"))!
                        school.address = (results?.string(forColumn: "address"))!
                        school.city = (results?.string(forColumn: "city"))!
                        school.state = (results?.string(forColumn: "state"))!
                        school.phone = (results?.string(forColumn: "phone"))!
                        school.adminCode = (results?.string(forColumn: "adminCode"))
                        schools.append(school)
                    }
                }
                else {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS schools (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, address TEXT, city TEXT, state TEXT, phone TEXT, adminCode TEXT)"
                    if !((schoolsDB?.executeStatements(sql_stmt))!) {
                        print("ERROR: \(schoolsDB?.lastErrorMessage())")
                    }
                }
                
                schoolsDB?.close()
            } else {
                print("ERROR: \(schoolsDB?.lastErrorMessage())")
            }
        }
        print("count: \(schools.count)")
        NSLog("exiting SchoolSvcSQLite.init")
    }
    
    func create(_ classType: School) {
        let schoolsDB = FMDatabase(path: databasePath! as String)
        
        if (schoolsDB.open()){
            let insertSQL = "INSERT INTO schools (name, address, city, state, phone, adminCode) VALUES ('\(classType.name!.replacingOccurrences( of: "'", with: "''"))', '\(classType.address!.replacingOccurrences( of: "'", with: "''"))', '\(classType.city!.replacingOccurrences( of: "'", with: "''"))', '\(classType.state!.replacingOccurrences( of: "'", with: "''"))', '\(classType.phone!.replacingOccurrences( of: "'", with: "''"))', '\(classType.adminCode!.replacingOccurrences( of: "'", with: "''"))');"
            
            let result = schoolsDB.executeUpdate(insertSQL, withArgumentsIn: [])
            
            if !(result){
                NSLog("Failed to add school")
                NSLog("Error: \(schoolsDB.lastErrorMessage())")
            } else{
                NSLog("School added")
                classType.id = schoolsDB.lastInsertRowId
                schools.append(classType)
                print("count: \(schools.count)")
            }
            schoolsDB.close()
        } else{
            NSLog("Error: \(schoolsDB.lastErrorMessage())")
        }
    }
    
    func retrieveAll() -> [School] {
        return schools
    }
    
    func update(_ classType: School, index: Int) {
        
        let schoolsDB: FMDatabase? = FMDatabase(path: databasePath! as String)
        
        if (schoolsDB?.open())!{
            let updateSQL = "UPDATE schools SET name = '\(classType.name!.replacingOccurrences( of: "'", with: "''"))', address = '\(classType.address!.replacingOccurrences( of: "'", with: "''"))', city = '\(classType.city!.replacingOccurrences( of: "'", with: "''"))', state = '\(classType.state!.replacingOccurrences( of: "'", with: "''"))', phone = '\(classType.phone!.replacingOccurrences( of: "'", with: "''"))', adminCode = '\(classType.adminCode!.replacingOccurrences( of: "'", with: "''"))', WHERE ID = \(classType.id);"
            let result = schoolsDB?.executeUpdate(updateSQL, withArgumentsIn: [])
            if !result! {
                NSLog("Failed to update school")
                NSLog("Error: \(schoolsDB?.lastErrorMessage())")
            } else {
                var number = 0
                for next in schools {
                    if next.id == classType.id {
                        schools[number] = classType
                        break
                    }
                    number += 1
                }
                NSLog("School updated")
            }
            schoolsDB?.close()
        } else {
            NSLog("Error: \(schoolsDB?.lastErrorMessage())")
        }
    }
    
    func delete(_ classType: School) {
        let schoolsDB = FMDatabase(path: databasePath! as String)
        if (schoolsDB.open()) {
            let deleteSQL = "DELETE FROM schools WHERE ID = \(classType.id)"
            
            let result = schoolsDB.executeUpdate(deleteSQL, withArgumentsIn: [])
            if !result {
                NSLog("Failed to delete school")
                NSLog("Error: \(schoolsDB.lastErrorMessage())")
            } else {
                var index = 0
                for next in schools {
                    if next.id == classType.id {
                        schools.remove(at: index)
                        break
                    }
                    index += 1
                }
                NSLog("School deleted")
            }
            schoolsDB.close()
        } else {
            NSLog("Error: \(schoolsDB.lastErrorMessage())")
        }
    }
    
    func getCount() -> Int {
        return schools.count
    }
    
    func getSchool(_ index: Int) -> School {
        return schools[index]
    }
}
