//
//  CreateNewListController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit
import Dropper
import MessageUI

class NewGameController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var gameName: String?
    var categoryName: String?
    var gameDescription: String?
    
    var parentController: UIViewController?
    var databaseHelper = DataBaseHelper()
    
    var buttonAction: (() -> Void)?
    
    let dropper = Dropper(width: 280, height: 200)
    
    @IBOutlet weak var gameNameField: UITextField!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var descriptionField: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropper.items = ["tańce", "rywalizacja", "integracyjne", "piosenki", "refleks", "sprawnościowe"]
        dropper.delegate = self
    }
    @IBAction func selectCategoryClicked(_ sender: Any) {
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
    
    @IBAction func save(_ sender: Any) {
        gameName = gameNameField.text
        gameDescription = descriptionField.text
        
        if gameName == nil || gameName == ""
        {
            Toast.showToast(message: "Podaj nazwę zabawy", controller: self)
        }
        else if categoryName == nil || categoryName == ""
        {
            Toast.showToast(message: "Wybierz kategorię", controller: self)
        }
        else
        {
            let ret = databaseHelper.addGame(category: categoryName!, game: gameName!, text: gameDescription!)
            
            if ret
            {
                Toast.showToast(message: "Zabawa została dodana", controller: parentController ?? self)
            }
            else
            {
                Toast.showToast(message: "Dodawanie zabawy zakończone niepowodzeniem", controller: parentController ?? self)
            }
            
            dismiss(animated: true)
            buttonAction?()
        }
    }
    
    @IBAction func saveAndShare(_ sender: Any) {
        gameName = gameNameField.text
        gameDescription = descriptionField.text
        
        if gameName == nil || gameName == ""
        {
            Toast.showToast(message: "Podaj nazwę zabawy", controller: self)
        }
        else if categoryName == nil || categoryName == ""
        {
            Toast.showToast(message: "Wybierz kategorię", controller: self)
        }
        else
        {
            let ret = databaseHelper.addGame(category: categoryName!, game: gameName!, text: gameDescription!)
            
            if ret
            {
                Toast.showToast(message: "Zabawa została dodana", controller: parentController ?? self)
                let mailComposeViewController = configureMailComposer(gameName: gameName ?? "", category: categoryName ?? "", description: gameDescription ?? "")
                    if MFMailComposeViewController.canSendMail(){
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    }else{
                        Toast.showToast(message: "Nie można wysłać maila", controller: self)
                    }
            }
            else
            {
                Toast.showToast(message: "Dodawanie zabawy zakończone niepowodzeniem", controller: parentController ?? self)
            }
            
            dismiss(animated: true)
            buttonAction?()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
        buttonAction?()
    }
    
    func configureMailComposer(gameName: String, category: String, description: String) -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["300268@pw.edu.pl"])
        mailComposeVC.setSubject("Radosne Wieczorki - nowa zabawa")
        mailComposeVC.setMessageBody(gameName + "\n" + category + "\n" + description + "\n", isHTML: false)
        return mailComposeVC
    }
}

extension NewGameController: DropperDelegate {
    func DropperSelectedRow(_: IndexPath, contents: String) {
        categoryName = contents
        dropdownButton.setTitle(contents, for: .normal)
    }
}
