//
//  DatabaseManager.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import Foundation
import SQLite3

class DatabaseManager
{
    private let dbFileName = "database.db"
    private var database:FMDatabase!
    
    init()
    {
        openDatabase()
    }
    
    func openDatabase()
    {
        
    }
    
    func closeDatabase()
    {
        if database != nil
        {
            database.close()
        }
    }
    
    
    
}
