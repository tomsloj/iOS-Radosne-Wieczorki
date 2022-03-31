//
//  GamesArray.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import Foundation

class GamesArray {
    private var array:[Game] = []
    
    init()
    {
        self.add(game: Game(name:"taniec2", category: "tańce", txt: "text tańca 2"))
        self.add(game: Game(name:"taniec3", category: "tańce", txt: "text tańca 3"))
        self.add(game: Game(name:"integr1", category: "integracyjne", txt: "text integracyjne 1"))
        self.add(game: Game(name:"integr2", category: "integracyjne", txt: "text integracyjne 2"))
        self.add(game: Game(name:"piosenka1", category: "piosenki", txt: "text piosenka 1"))
        self.add(game: Game(name:"piosenka2", category: "piosenki", txt: "text piosenka 2"))
        self.add(game: Game(name:"refleks1", category: "refleks", txt: "text refleks 1"))
        self.add(game: Game(name:"taniec1", category: "tańce", txt: "text tańca 1"))
    }
    
    private func add(game: Game)
    {
        array.append(game)
    }
    
    func numberOfGames(category: String)->Int
    {
        var counter = 0
        
        if category == "all"
        {
            return array.count
        }
        
        for game in array
        {
            if game.getCategory() == category
            {
                counter += 1
        
            }
        }
        return counter
    }
    
    func getGameName(indeks: Int)->String
    {
        if indeks >= array.count || indeks < 0
        {
            return ""
        }
        else
        {
            return array[indeks].getName()
        }
    }
    
    func getGames(category: String)->[Game]
    {
        var games:[Game] = []
        for game in array
        {
            if (game.getCategory() == category || category == "all")
            {
                games.append(game)
            }
        }
        return games
    }
    
    
}
