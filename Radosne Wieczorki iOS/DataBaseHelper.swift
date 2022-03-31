//
//  DataBaseHelper.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import Foundation
import SQLite3
import os.log

class DataBaseHelper
{
    public let dbPath = Bundle.main.path(forResource: "baza", ofType:"sqlite")
    private var database:FMDatabase!
    var db:OpaquePointer?
    
    let tableName = "DANE"
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    
    init()
    {
        openDatabase()
    }
    
    private func openDatabase()
    {
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("OK")
        }
    }
    
    func closeDatabase() {
        if (database != nil) {
            database.close()
        }
    }
    
    func getText(game:String)->String
    {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "SELECT tekst FROM \(tableName) WHERE zabawa = '\(game)'", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let result = sqlite3_column_text(statement, 0)
            
            let tekst = String(cString: result!)
            
            sqlite3_finalize(statement)
            statement = nil
    
            return tekst
        }
        else
        {
            return "-1"
        }
    }
    
    func addGame(category:String, game:String, text:String)
    {
        var statement: OpaquePointer?
        
        let insertQuery = "INSERT INTO \(tableName) (zabawa, kategoria, tekst) VALUES (?, ?, ?)"
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, game, -1, SQLITE_TRANSIENT) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 2, category, -1, SQLITE_TRANSIENT) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, text, -1, SQLITE_TRANSIENT) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        sqlite3_finalize(statement)
        
    }
    
    func getGamesInCategory(category:String)->[String]
    {
        var statement: OpaquePointer?
        
        var list:[String] = []
        
        var query:String
        
        if category == "all"
        {
            query = "SELECT zabawa FROM \(tableName) WHERE kategoria <> 'zz'"
        }
        else
        {
            query = "SELECT zabawa FROM \(tableName) WHERE kategoria = '\(category)'"
        }
        
        query = query + " ORDER BY zabawa"//COLLATE UNICODE"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW
        {
            let resultColumn = sqlite3_column_text(statement, 0)
            let toAdd = String(cString: resultColumn!)
            list.append(toAdd)
        }
        sqlite3_finalize(statement)
        statement = nil
        return list
    }
    
    func nextGame(category:String, game:String)->String
    {
        var list = getGamesInCategory(category: category)
        
        for i in 0..<list.count
        {
            if list[i] == game
            {
                if i < list.count - 1
                {
                    return list[i+1]
                }
                else
                {
                    return ""
                }
            }
        }
        return ""
    }
    
    func prevGame(category:String, game:String)->String
    {
        var list = getGamesInCategory(category: category)
        
        for i in 0..<list.count
        {
            if list[i] == game
            {
                if i == 0
                {
                    return ""
                }
                else
                {
                    return list[i-1]
                }
            }
        }
        return ""
    }
    
    private func getList(query:String)->[String]
    {
        var statement: OpaquePointer?
        
        var list:[String] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW
        {
            let resultColumn = sqlite3_column_text(statement, 0)
            let toAdd = String(cString: resultColumn!)
            list.append(toAdd)
        }
        sqlite3_finalize(statement)
        statement = nil
        return list
    }
    
    func find(toFind:String, name:Bool, text:Bool)->[String]
    {
        var query = "SELECT zabawa FROM \(tableName) WHERE "
        
        if name
        {
            query = query + "zabawa Like '%\(toFind)%'"
            if text
            {
                query = query + " OR "
            }
        }
        if text
        {
            query = query + " tekst Like '%\(toFind)%'"
        }
        
        query = query + " ORDER BY zabawa"
        
        return getList(query: query)
    }
    
    private func count()->Int
    {
        var statement:OpaquePointer?
        
        let query = "SELECT count(*) FROM \(tableName)"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let result = sqlite3_column_int(statement, 0)
            
            return Int(result)
        }
        else
        {
            return 0
        }
    }
    
    func gameExist(game:String)->Bool
    {
        let query = "SELECT zabawa FROM \(tableName)"
        
        var list = getList(query: query)
        
        for element in list
        {
            if element == game
            {
                return true
            }
        }
        return false
    }
    
    func getCategory(game:String)->String
    {
        let query = "SELECT kategoria FROM \(tableName) WHERE zabawa = '\(game)'"
        
        var list = getList(query: query)
        
        return list[0]
    }
    
    func remove(game:String)
    {
        var statement:OpaquePointer?
        
        let query = "DELETE FRON \(tableName) WHERE zabawa = '\(game)'"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("DONE")
            }
        }
        else
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
}
