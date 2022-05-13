//
//  AlertService.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class AlertService {
    
    func displayCreateNewListDialog (game: String?, completion: @escaping () -> Void) -> CreateNewListController
    {
        let storyboard = UIStoryboard(name: "CreateNewListStoryboard", bundle: .main)
        
        let createNewListController = storyboard.instantiateViewController(withIdentifier: "CreateNewListController" ) as! CreateNewListController
        
        createNewListController.buttonAction = completion
        createNewListController.gameName = game
        
        return createNewListController
    }
    
    func displaySelectFavoriteListDialog (game: String?, parent: UIViewController, completion: @escaping () -> Void) -> SelectFavoriteListController
    {
        let storyboard = UIStoryboard(name: "SelectFavoriteListDialog", bundle: .main)
        
        let selectFavoriteListController = storyboard.instantiateViewController(withIdentifier: "SelectFavoriteListController" ) as! SelectFavoriteListController
        
        selectFavoriteListController.buttonAction = completion
        selectFavoriteListController.gameName = game
        selectFavoriteListController.parentController = parent
        
        return selectFavoriteListController
    }
    
    func displayNotesDialog (game: String?, listName: String?, parent: UIViewController, completion: @escaping () -> Void) -> NotesController
    {
        let storyboard = UIStoryboard(name: "NotesStoryboard", bundle: .main)
        
        let notesController = storyboard.instantiateViewController(withIdentifier: "NotesStoryboard" ) as! NotesController
        
        notesController.buttonAction = completion
        notesController.gameName = game
        notesController.listName = listName
        notesController.parentController = parent
        
        return notesController
    }
    
    func displayNewGameDialog (parent: UIViewController, completion: @escaping () -> Void) -> NewGameController
    {
        let storyboard = UIStoryboard(name: "NewGameDialog", bundle: .main)
        
        let newGameDialog = storyboard.instantiateViewController(withIdentifier: "NewGameDialog" ) as! NewGameController
        
        newGameDialog.parentController = parent
        
        return newGameDialog
    }
    
    func displayAddToFavoritesDialog (completion: @escaping () -> Void) -> AddToFavoritesController
    {
        let storyboard = UIStoryboard(name: "AddToFavoritesStoryboard", bundle: .main)
        
        let createNewListController = storyboard.instantiateViewController(withIdentifier: "AddToFavoritesStoryboard" ) as! AddToFavoritesController
        
        //createNewListController.buttonAction = completion
        
        return createNewListController
    }
    
    func displayAddNotesDialog (game: String?, completion: @escaping () -> Void) -> CreateNewListController
    {
        let storyboard = UIStoryboard(name: "CreateNewListStoryboard", bundle: .main)
        
        let createNewListController = storyboard.instantiateViewController(withIdentifier: "CreateNewListController" ) as! CreateNewListController
        
        createNewListController.buttonAction = completion
        createNewListController.gameName = game
        
        return createNewListController
        
    }
    
}
