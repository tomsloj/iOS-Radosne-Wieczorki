//
//  CreateNewListController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class CreateNewListController: UIViewController {
    
    @IBOutlet weak var nameOfList: UITextField!
    
    var buttonAction: (() -> Void)?
    
    var tableView:UITableView?
    
    var gameName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createClicked(_ sender: Any) {
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
                if tableView != nil
                {
                    //tableView!.reloadData()
                    
                }
                dismiss(animated: true)
                
                buttonAction?()
            }
        }
        
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
