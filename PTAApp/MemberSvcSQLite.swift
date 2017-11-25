//
//  MemberSvcSQLite.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/4/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation

class MemberSvcSQLite: IMemberSQLiteSvc {
    static let directory: NSString? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let databasePath = directory?.appendingPathComponent("ptaDB")
    
    var members = [Member]()
    
    init(){
        NSLog("Entering MemberSvcSQLite.init")
        let filemgr = FileManager.default
        
        if !filemgr.fileExists(atPath: databasePath!) {
            // if db does not exist, create it
            let membersDB: FMDatabase? = FMDatabase(path: databasePath! as String)
            
            // create the table
            NSLog("Creating Table")
            if (membersDB?.open())! {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS members (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, firstName TEXT, lastName TEXT, address TEXT, city TEXT, state TEXT, phone TEXT, email TEXT, adminRights BOOLEAN, ptaTitle TEXT)"
                if !((membersDB?.executeStatements(sql_stmt))!) {
                    print("ERROR: \(membersDB?.lastErrorMessage())")
                }
                membersDB?.close()
            } else {
                print("ERROR: \(membersDB?.lastErrorMessage())")
            }
        } else {
            
            let membersDB: FMDatabase? = FMDatabase(path: databasePath! as String)
            if (membersDB?.open())! {
                let querySQL = "SELECT * FROM members"
                let results: FMResultSet? = membersDB?.executeQuery(querySQL, withArgumentsIn: [])
                
                if results != nil {
                    while results?.next() == true {
                        let member = Member()
                        member.id = (results?.longLongInt(forColumn: "ID"))!
                        member.firstName = (results?.string(forColumn: "firstName"))!
                        member.lastName = (results?.string(forColumn: "lastName"))!
                        member.address = (results?.string(forColumn: "address"))!
                        member.city = (results?.string(forColumn: "city"))!
                        member.state = (results?.string(forColumn: "state"))!
                        member.phone = (results?.string(forColumn: "phone"))!
                        member.adminRights = (results?.bool(forColumn: "adminRights"))!
                        member.ptaTitle = (results?.string(forColumn: "ptaTitle"))!
                        members.append(member)
                    }
                }
                else {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS members (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, firstName TEXT, lastName TEXT, address TEXT, city TEXT, state TEXT, phone TEXT, email TEXT, adminRights BOOLEAN, ptaTitle TEXT)"
                    if !((membersDB?.executeStatements(sql_stmt))!) {
                        print("ERROR: \(membersDB?.lastErrorMessage())")
                    }
                }
                membersDB?.close()
            } else {
                print("ERROR: \(membersDB?.lastErrorMessage())")
            }
        }
        print("count: \(members.count)")
        NSLog("exiting MemberSvcSQLite.init")
    }
    
    func create(_ classType: Member) {
        let membersDB = FMDatabase(path: databasePath! as String)
        
        if (membersDB.open()){
            let insertSQL = "INSERT INTO members (firstName, lastName, address, city, state, phone, email, adminRights, ptaTitle) VALUES ('\(classType.firstName!.replacingOccurrences( of: "'", with: "''"))', '\(classType.lastName!.replacingOccurrences( of: "'", with: "''"))', '\(classType.address!.replacingOccurrences( of: "'", with: "''"))', '\(classType.city!.replacingOccurrences( of: "'", with: "''"))', '\(classType.state!.replacingOccurrences( of: "'", with: "''"))', '\(classType.phone!.replacingOccurrences( of: "'", with: "''"))', '\(classType.email!.replacingOccurrences( of: "'", with: "''"))', '\(classType.adminRights)', '\(classType.ptaTitle!.replacingOccurrences( of: "'", with: "''"))');"
            
            let result = membersDB.executeUpdate(insertSQL, withArgumentsIn: [])
            
            if !(result){
                NSLog("Failed to add member")
                NSLog("Error: \(membersDB.lastErrorMessage())")
            } else{
                NSLog("Member added")
                classType.id = membersDB.lastInsertRowId
                members.append(classType)
                print("count: \(members.count)")
            }
            membersDB.close()
        } else{
            NSLog("Error: \(membersDB.lastErrorMessage())")
        }
    }
    
    func retrieveAll() -> [Member] {
        return members
    }
    
    func update(_ classType: Member, index: Int) {
        
        let membersDB: FMDatabase? = FMDatabase(path: databasePath! as String)
        
        if (membersDB?.open())!{
            let updateSQL = "UPDATE members SET firstName = '\(classType.firstName!.replacingOccurrences( of: "'", with: "''"))', lastName = '\(classType.lastName!.replacingOccurrences( of: "'", with: "''"))', address ='\(classType.address!.replacingOccurrences( of: "'", with: "''"))', city = '\(classType.city!.replacingOccurrences( of: "'", with: "''"))', state = '\(classType.state!.replacingOccurrences( of: "'", with: "''"))', phone = '\(classType.phone!.replacingOccurrences( of: "'", with: "''"))', email = '\(classType.email!.replacingOccurrences( of: "'", with: "''"))', adminRights = '\(classType.adminRights)', ptaTitle = '\(classType.ptaTitle!.replacingOccurrences( of: "'", with: "''"))');"
            let result = membersDB?.executeUpdate(updateSQL, withArgumentsIn: [])
            if !result! {
                NSLog("Failed to update member")
                NSLog("Error: \(membersDB?.lastErrorMessage())")
            } else {
                var number = 0
                for next in members {
                    if next.id == classType.id {
                        members[number] = classType
                        break
                    }
                    number += 1
                }
                NSLog("Member updated")
            }
            membersDB?.close()
        } else {
            NSLog("Error: \(membersDB?.lastErrorMessage())")
        }
    }
    
    func delete(_ classType: Member) {
        let membersDB = FMDatabase(path: databasePath! as String)
        if (membersDB.open()) {
            let deleteSQL = "DELETE FROM members WHERE ID = \(classType.id)"
            
            let result = membersDB.executeUpdate(deleteSQL, withArgumentsIn: [])
            if !result {
                NSLog("Failed to delete member")
                NSLog("Error: \(membersDB.lastErrorMessage())")
            } else {
                var index = 0
                for next in members {
                    if next.id == classType.id {
                        members.remove(at: index)
                        break
                    }
                    index += 1
                }
                NSLog("Member deleted")
            }
            membersDB.close()
        } else {
            NSLog("Error: \(membersDB.lastErrorMessage())")
        }
    }
    
    func getCount() -> Int {
        return members.count
    }
    
    func getMember(_ index: Int) -> Member {
        return members[index]
    }
}
