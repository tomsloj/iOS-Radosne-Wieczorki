//
//  SelectFavoriteListController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 12/05/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit
//import DropDown
//import SwiftyMenu
//import SnapKit
import Dropper


class SelectFavoriteListController: UIViewController
{
    var listName:String!
    
    @IBOutlet weak var title1: UILabel!
//    @IBOutlet weak var dropdownMenu: DropDown!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var nameOfList: UITextField!
    
    let databaseFavorites:DatabaseFavorites = DatabaseFavorites()
    let alertService = AlertService()
    
    var list: [String] = []
    var gameName: String?
    
    var buttonAction: (() -> Void)?
    var parentController: UIViewController!
    
    var dropper = Dropper(width: 280, height: 210)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = databaseFavorites.getFavoritesList()
        dropper.items = list
        dropper.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func accept(_ sender: Any) {
        
        if listName == nil
        {
            Toast.showToast(message: "Wybierz listę do której dodać zabawę", controller: self)
        }
        else
        {
            if(gameName != nil)
            {
                databaseFavorites.addGametoFavorite(name: listName!, game: gameName!)
                Toast.showToast(message: "Dodano zabawę do listy " + listName, controller: parentController!)
            }
            dismiss(animated: true)
            buttonAction?()
        }
    }
    @IBAction func createNewList(_ sender: Any) {
        let databaseFavorites = DatabaseFavorites()
        
        let name = nameOfList.text
        
        if name != nil
        {
            if databaseFavorites.favoriteExist(name: name!)
            {
                Toast.showToast(message: "Istnieje już taka lista", controller: self)
            }
            else
            if name == ""
            {
                Toast.showToast(message: "Nazwa listy nie może być pusta", controller: self)
            }
            else
            {
                databaseFavorites.createFavorites(name: name!, game: gameName)
                dismiss(animated: true)
                buttonAction?()
            }
        }
    }
    
    @IBAction func selectListClicked(_ sender: Any) {
        if dropper.status == .hidden {
                    // Item displayed
                    dropper.theme = Dropper.Themes.white
                    dropper.delegate = self
                    dropper.cornerRadius = 3
                    dropper.showWithAnimation(0.15, options: Dropper.Alignment.center, button: dropdownButton)
                } else {
                    dropper.hideWithAnimation(0.1)
                }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension SelectFavoriteListController: DropperDelegate {
    func DropperSelectedRow(_: IndexPath, contents: String) {
        listName = contents
        dropdownButton.setTitle(contents, for: .normal)
    }
}
