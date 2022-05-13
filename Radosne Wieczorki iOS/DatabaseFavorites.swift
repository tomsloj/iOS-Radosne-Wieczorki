//
//  DatabaseFavorites.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import Foundation
import SQLite3
import os.log

class DatabaseFavorites
{
    
    let dbURL: URL
    
    let databaseName = "favoritesBase.sqlite"
    let tableName = "favorites"
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    // The database pointer.
    var db: OpaquePointer?
    var insertEntryStmt: OpaquePointer?
    var readEntryStmt: OpaquePointer?
    var updateEntryStmt: OpaquePointer?
    var deleteEntryStmt: OpaquePointer?
    
    let oslog = OSLog(subsystem: "codewithayush", category: "sqliteintegration")
    
    init()
    {
        do {
            do {
                dbURL = try FileManager.default
                    .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent(databaseName)
                os_log("URL: %s", dbURL.absoluteString)
            } catch {
                //TODO: Just logging the error and returning empty path URL here. Handle the error gracefully after logging
                os_log("Some error occurred. Returning empty path.")
                dbURL = URL(fileURLWithPath: "")
                return
            }
            
            try openDB()
            try createTables()
        } catch
        {
            //TODO: Handle the error gracefully after logging
            os_log("Some error occurred. Returning.")
            return
        }
    }
    
    func openDB() throws
    {
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK
        { // error mostly because of corrupt database
            os_log("error opening database at %s", log: oslog, type: .error, dbURL.absoluteString)
            //            deleteDB(dbURL: dbURL)
        }
    }
    
    func createTables() throws
    {
        let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS \(tableName) (name TEXT, game TEXT, number INT, notes TEXT)", nil, nil, nil)
        if (ret != SQLITE_OK)
        { // corrupt database.
            throw SqliteError(message: "unable to create table Records")
        }
        
    }
    
    //@return max number of favorite games(how many games is in favorite)
    func maxNumber(name:String)->Int
    {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "SELECT MAX(number) FROM \(tableName) WHERE name = '\(name)'", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let number = sqlite3_column_int(statement, 0)
            sqlite3_finalize(statement)
            statement = nil
            return Int(number)
        }
        else
        {
            return 0
        }
    }
    
    //add new game to favorite list
    public func addGametoFavorite(name:String, game:String)
    {
        var statement: OpaquePointer?
    
        var number:Int
        
        if game == "remove"
        {
            number = 0
        }
        else
        {
            number = maxNumber(name: name) + 1;
        }
        
        let insertQuery = "INSERT INTO \(tableName) (name, game, number, notes) VALUES (?, ?, ?, ?)"

        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
     
        if sqlite3_bind_text(statement, 1, name, -1, SQLITE_TRANSIENT) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
        }
    
        if sqlite3_bind_text(statement, 2, game, -1, SQLITE_TRANSIENT) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding game: \(errmsg)")
        }
        
        if sqlite3_bind_int(statement, 3, Int32(number)) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding number: \(errmsg)")
        }
    
        if sqlite3_bind_text(statement, 4, "", -1, SQLITE_TRANSIENT) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding notes: \(errmsg)")
        }
        if sqlite3_step(statement) != SQLITE_DONE
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        sqlite3_finalize(statement)

    }
    
    //@return number of game in favorite
    public func numberOfGame(name:String, game:String)->Int
    {
        var statement: OpaquePointer?
    
        if sqlite3_prepare_v2(db, "SELECT number FROM \(tableName) WHERE name = '\(name)' AND game = '\(game)'", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let number = sqlite3_column_int(statement, 0)
            sqlite3_finalize(statement)
            statement = nil
            return Int(number)
        }
        else
        {
        return 0
        }
    }
    
    public func gameFromNumber(number:Int, name:String)->String
    {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "SELECT game FROM \(tableName) WHERE name = '\(name)' AND number = '\(number)'", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let resultColumn = sqlite3_column_text(statement, 0)
            let gameName = String(cString: resultColumn!)
            sqlite3_finalize(statement)
            statement = nil
            return gameName
            
//            return String(cString: resultColumn!)
        }
        else
        {
            return "Error 17"
        }
    }
    
    //swap game with game which have lower number
    public func upGame(name:String, game:String)
    {
        var statement: OpaquePointer?
        let gameNumber = numberOfGame(name: name, game: game)
        
        if gameNumber <= 1
        {
            return
        }
        
    
        if sqlite3_prepare_v2(db, "UPDATE \(tableName) SET number = \(gameNumber) WHERE name = '\(name)' AND number = \(gameNumber - 1)", -1, &statement, nil) == SQLITE_OK
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
        
        if sqlite3_prepare_v2(db, "UPDATE \(tableName) SET number = \(gameNumber - 1) WHERE name = '\(name)' AND game = '\(game)'", -1, &statement, nil) == SQLITE_OK
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
    
    //swap game with game which have higher number
    public func downGame(name:String, game:String)
    {
        var statement: OpaquePointer?
        let gameNumber = numberOfGame(name: name, game: game)
        let max_Number = maxNumber(name: name)
        
        if gameNumber >= max_Number
        {
            return
        }
        
        
        if sqlite3_prepare_v2(db, "UPDATE \(tableName) SET number = \(gameNumber) WHERE name = '\(name)' AND number = \(gameNumber + 1)", -1, &statement, nil) == SQLITE_OK
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
        
        if sqlite3_prepare_v2(db, "UPDATE \(tableName) SET number = \(gameNumber + 1) WHERE name = '\(name)' AND game = '\(game)'", -1, &statement, nil) == SQLITE_OK
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
    
    //create empty list of favorite
    public func createFavorites(name:String, game:String?)
    {
        addGametoFavorite(name: name, game: "remove")
        if game != nil
        {
            addGametoFavorite(name: name, game: game!)
        }
    }
    
    //check if favorite exists
    public func favoriteExist(name:String)->Bool
    {
        var statement: OpaquePointer?
        
        var counted:Int = 0
        
        if sqlite3_prepare_v2(db, "SELECT count(*) FROM \(tableName) WHERE name = '\(name)'", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            counted = Int(sqlite3_column_int(statement, 0))
            sqlite3_finalize(statement)
            statement = nil
        }
        if counted == 0
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    //check if game is in favorite
    public func gameInFavoriteExists(name:String, game:String)->Bool
    {
        var statement: OpaquePointer?
        
        var counted:Int = 0
        
        if sqlite3_prepare_v2(db, "SELECT count(*) FROM \(tableName) WHERE name = '\(name)' AND game = '\(game)'", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            counted = Int(sqlite3_column_int(statement, 0))
            sqlite3_finalize(statement)
            statement = nil
        }
        if counted == 0
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    //@return list of games in favorite
    public func getGamesInFavorite(name:String)->[String]
    {
        var statement: OpaquePointer?
        
        var gamesArray:[String] = []
        
        if sqlite3_prepare_v2(db, "SELECT game FROM \(tableName) WHERE name = '\(name)' ORDER BY number", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW
        {
            let resultColumn = sqlite3_column_text(statement, 0)
            let gameName = String(cString: resultColumn!)
            if gameName != "remove"
            {
                gamesArray.append(gameName)
            }
        }
        sqlite3_finalize(statement)
        statement = nil
        return gamesArray
    }
    
    //@return list of favorite lists
    public func getFavoritesList()->[String]
    {
        var statement: OpaquePointer?
        
        var favoritesList:[String] = []
        
        if sqlite3_prepare_v2(db, "SELECT name FROM \(tableName) GROUP BY name", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW
        {
            let resultColumn = sqlite3_column_text(statement, 0)
            favoritesList.append(String(cString: resultColumn!))
        }
        sqlite3_finalize(statement)
        statement = nil
        return favoritesList
        
    }
    
    public func deleteFavorite(name:String)
    {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "DELETE FROM \(tableName) WHERE name = '\(name)'", -1, &statement, nil) == SQLITE_OK
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
    
    public func deleteGame(name:String, game:String)
    {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "DELETE FROM \(tableName) WHERE name = '\(name)' AND game = '\(game)'", -1, &statement, nil) == SQLITE_OK
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
        
        let number = numberOfGame(name: name, game: game)
        
        if sqlite3_prepare_v2(db, "UPDATE \(tableName) SET number = number - 1 WHERE name = '\(name) AND number > \(number)", -1, &statement, nil) == SQLITE_OK
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
    
    public func editNameOfFavorite(name:String, newName:String)
    {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "UPDATE \(tableName) SET name = '\(name) WHERE name = '\(name)'", -1, &statement, nil) == SQLITE_OK
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
    
    public func getNotes( game:String, playlist:String )->String
    {
        var statement: OpaquePointer?
    
        if sqlite3_prepare_v2(db, "SELECT notes FROM \(tableName) WHERE name = '\(playlist)' AND game = '\(game)'", -1, &statement, nil) != SQLITE_OK
        {
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let notes = sqlite3_column_text(statement, 0)
            sqlite3_finalize(statement)
            statement = nil
            if notes != nil
            {
                return String(cString:notes!)
            }
            else
            {
                return ""
            }
            
        }
        else
        {
            return ""
        }
    }
    
    public func updateNotes( notes:String, game:String, playlist:String )
    {
        var statement: OpaquePointer?
    
        if sqlite3_prepare_v2(db, "UPDATE \(tableName) SET notes = '\(notes) WHERE name = '\(playlist)' AND game = '\(game)'", -1, &statement, nil) == SQLITE_OK
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
    
    func getJSON( favoriteListName:String ) -> String
    {
        do
        {
            let dbHelper = DataBaseHelper()
            let gamesNamesList:[String] = getGamesInFavorite(name: favoriteListName)
            
            var gamesList:[GameStruct] = []
            for gameName in gamesNamesList {
                gamesList.append(GameStruct(name: gameName, category: dbHelper.getCategory(game: gameName), text: dbHelper.getText(game: gameName), note: getNotes(game: gameName, playlist: favoriteListName)))
            }
            let favorite = FavoriteStruct(name: favoriteListName, games: gamesList)
            let jsonData = try JSONEncoder().encode(favorite)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        }
        catch {
            print(error)
            return ""
        }
    }
    
    func importJSON(json: String) -> Bool
    {
        let dbHelper = DataBaseHelper()
        let jsonData = json.data(using: .utf8)!
        let favorite: FavoriteStruct = try! JSONDecoder().decode(FavoriteStruct.self, from: jsonData)
        if favoriteExist(name: favorite.name)
        {
            return false
        }
        createFavorites(name: favorite.name, game: nil)
        for game in favorite.games {
            //jeśli nie mieliśmy takiej gry w bazie to ją dodajemy
            if !dbHelper.gameExist(game: game.name)
            {
                dbHelper.addGame(category: game.category, game: game.name, text: game.text)
            }
            addGametoFavorite(name: favorite.name, game: game.name)
        }
        return true
    }
}

class SqliteError : Error {
    var message = ""
    var error = SQLITE_ERROR
    init(message: String = "") {
        self.message = message
    }
    init(error: Int32) {
        self.error = error
    }
}
struct GameStruct : Codable
{
    let name : String
    let category : String
    let text : String
    let note : String
}
struct FavoriteStruct : Codable
{
    let name : String
    let games : [GameStruct]
}
