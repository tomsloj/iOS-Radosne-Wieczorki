//
//  Display.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class DisplayController: UIViewController {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var gameName:String?
    
    let sService:SettingsService = SettingsService()
    let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseHelper = DataBaseHelper()
        
        titleLabel.text = gameName
        
        categoryLabel.text = "Kategoria: " + databaseHelper.getCategory(game: gameName!)
        
        textLabel.text = databaseHelper.getText(game: gameName!)
        
        titleLabel.font = titleLabel.font.withSize(CGFloat(sService.getTextSize() + 4.0))
        categoryLabel.font = categoryLabel.font.withSize(CGFloat(sService.getTextSize()))
        textLabel.font = textLabel.font.withSize(CGFloat(sService.getTextSize()))
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        titleLabel.font = titleLabel.font.withSize(CGFloat(sService.getTextSize() + 4.0))
        categoryLabel.font = categoryLabel.font.withSize(CGFloat(sService.getTextSize()))
        textLabel.font = textLabel.font.withSize(CGFloat(sService.getTextSize()))
    }
    
    @IBAction func addToList(_ sender: Any) {
        let dialog = alertService.displayCreateNewListDialog(game: gameName)
        {
            //Toast.showToast(message: "update", controller: self)
            //self.list = self.databaseFavorites.getFavoritesList()
            //self.update()
        }
        
        //dialog.tableView = tableView
        
        present(dialog, animated: true)
    }
       
}
