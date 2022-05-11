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
