//
//  CreateNewListController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class NotesController: UIViewController {
    
    var gameName: String?
    var listName: String?
    
    var parentController: UIViewController?
    var databaseFavorites = DatabaseFavorites()
    
    @IBOutlet weak var notesField: UITextView!
    
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesField.text =  databaseFavorites.getNotes(game: gameName!, playlist: listName!)
    }
    
    @IBAction func save(_ sender: Any) {
        let notesText = notesField.text
        databaseFavorites.updateNotes(notes: notesText ?? "", game: gameName!, playlist: listName!)
        
        dismiss(animated: true)
        buttonAction?()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
