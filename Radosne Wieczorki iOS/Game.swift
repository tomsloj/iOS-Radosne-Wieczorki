//
//  Game.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import Foundation

class Game
{
    private var name:String
    private var category:String
    private var txt:String
    
    init(name: String, category: String, txt: String) {
        self.name = name
        self.category = category
        self.txt = txt
    }
    
    func getName()->String
    {
        return name
    }
    
    func getCategory()->String
    {
        return category
    }
    
    func getTxt()->String
    {
        return txt
    }
}
