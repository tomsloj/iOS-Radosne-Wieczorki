//
//  Display.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit
import youtube_ios_player_helper


class DisplayController: UIViewController {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var playersView: UIStackView!
    @IBOutlet weak var ytPlayer1: YTPlayerView!
    @IBOutlet weak var ytPlayer2: YTPlayerView!
    @IBOutlet weak var ytPlayer3: YTPlayerView!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    var gameName:String?
    var categoryName:String?
    var isFavorite:Bool?
    
    let sService:SettingsService = SettingsService()
    let alertService = AlertService()
    let databaseHelper = DataBaseHelper()
    let databaseFavorite = DatabaseFavorites()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = gameName
        // usunięcie marginesu w opisie
        textLabel.textContainer.lineFragmentPadding = 0
        
        titleLabel.text = gameName
        
        categoryLabel.text = "Kategoria: " + databaseHelper.getCategory(game: gameName!)
        
        // podświetlenie linków
        textLabel.text = databaseHelper.getText(game: gameName!)
        textLabel.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        textLabel.isSelectable = true
        textLabel.isEditable = false
        textLabel.isUserInteractionEnabled = true
        textLabel.dataDetectorTypes = .link
        
        // ustawienie środkowego przycisku na wierzch
        self.view.bringSubviewToFront(addToFavoritesButton)
        
        //ustawienie rozmiaru czcionki
        titleLabel.font = titleLabel.font.withSize(CGFloat(sService.getTextSize() + 4.0))
        categoryLabel.font = categoryLabel.font.withSize(CGFloat(sService.getTextSize()))
        textLabel.font = textLabel.font?.withSize(CGFloat(sService.getTextSize()))
        
        //przycisk notatek
        if (isFavorite ?? false)
        {
            let floatingButton = UIButton()
            floatingButton.setImage(UIImage(systemName: "message.fill"), for: .normal)
            floatingButton.tintColor = UIColor.white
            floatingButton.scalesLargeContentImage = true
            floatingButton.backgroundColor = .red
            floatingButton.layer.cornerRadius = 25
            
            view.addSubview(floatingButton)
            floatingButton.translatesAutoresizingMaskIntoConstraints = false

            floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -100).isActive = true

            floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
            floatingButton.addTarget(self, action: #selector(floatingButtonClicked), for: UIControl.Event.touchUpInside)
        }
        loadYTPlayer()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        titleLabel.font = titleLabel.font.withSize(CGFloat(sService.getTextSize() + 4.0))
        categoryLabel.font = categoryLabel.font.withSize(CGFloat(sService.getTextSize()))
        textLabel.font = textLabel.font?.withSize(CGFloat(sService.getTextSize()))
        updateLeftRightButtons()
    }
    
    @IBAction func addToList(_ sender: Any) {
        let dialog = alertService.displaySelectFavoriteListDialog(game: gameName, parent: self)
        {
        }
        
        present(dialog, animated: true)
    }
    
    @IBAction func leftClicked(_ sender: Any) {
        if !(isFavorite ?? false)
        {
            let prevGame = databaseHelper.prevGame(category: categoryName!, game: gameName ?? "")
            if databaseHelper.nextGame(category: categoryName!, game: gameName!).isEmpty
            {
                rightButton.isEnabled = false
            }
            else
            {
                rightButton.isEnabled = true
            }
            if prevGame.isEmpty
            {
                leftButton.isEnabled = false
            }
            else
            {
                gameName = prevGame
                titleLabel.text = gameName
                textLabel.text = databaseHelper.getText(game: gameName ?? "")
                if databaseHelper.nextGame(category: categoryName!, game: gameName ?? "").isEmpty
                {
                    rightButton.isEnabled = false
                }
                else
                {
                    rightButton.isEnabled = true
                }
            }
            if databaseHelper.prevGame(category: categoryName!, game: gameName ?? "").isEmpty
            {
                leftButton.isEnabled = false
            }
            else
            {
                leftButton.isEnabled = true
            }
        }
        else
        {
            let gameNumber = databaseFavorite.numberOfGame(name: categoryName!, game: gameName!)
            if gameNumber - 1 >= 0
            {
                gameName = databaseFavorite.gameFromNumber(number: gameNumber - 1, name: categoryName!)
                titleLabel.text = gameName
                categoryLabel.text = databaseHelper.getCategory(game: gameName ?? "")
                textLabel.text = databaseHelper.getText(game: gameName ?? "")
                updateLeftRightButtons()
            }
        }
        self.title = gameName
        loadYTPlayer()
    }
    @IBAction func rightClicked(_ sender: Any) {
        if !(isFavorite ?? false)
        {
            let nextGame = databaseHelper.nextGame(category: categoryName!, game: gameName ?? "")
            if databaseHelper.prevGame(category: categoryName!, game: gameName!).isEmpty
            {
                leftButton.isEnabled = false
            }
            else
            {
                leftButton.isEnabled = true
            }
            if nextGame.isEmpty
            {
                rightButton.isEnabled = false
            }
            else
            {
                gameName = nextGame
                titleLabel.text = gameName
                textLabel.text = databaseHelper.getText(game: gameName ?? "")
                if databaseHelper.prevGame(category: categoryName!, game: gameName ?? "").isEmpty
                {
                    leftButton.isEnabled = false
                }
                else
                {
                    leftButton.isEnabled = true
                }
            }
            if databaseHelper.nextGame(category: categoryName!, game: gameName ?? "").isEmpty
            {
                rightButton.isEnabled = false
            }
            else
            {
                rightButton.isEnabled = true
            }
        }
        else
        {
            let gamesCount = databaseFavorite.maxNumber(name: categoryName!)
            let gameNumber = databaseFavorite.numberOfGame(name: categoryName!, game: gameName!)
            if gameNumber + 1 <= gamesCount
            {
                gameName = databaseFavorite.gameFromNumber(number: gameNumber + 1, name: categoryName!)
                titleLabel.text = gameName
                categoryLabel.text = databaseHelper.getCategory(game: gameName ?? "")
                textLabel.text = databaseHelper.getText(game: gameName ?? "")
                updateLeftRightButtons()
            }
        }
        self.title = gameName
        loadYTPlayer()
    }
    
    func updateLeftRightButtons()
    {
        if categoryName == nil || categoryName == ""
        {
            leftButton.isEnabled = false
            rightButton.isEnabled = false
            return
        }
        
        if isFavorite != nil && isFavorite!
        {
            let gamesCount = databaseFavorite.maxNumber(name: categoryName!)
            let gameNumber = databaseFavorite.numberOfGame(name: categoryName!, game: gameName!)
            if gameNumber <= 1
            {
                leftButton.isEnabled = false
            }
            else
            {
                leftButton.isEnabled = true
            }
            if gameNumber >= gamesCount
            {
                rightButton.isEnabled = false
            }
            else
            {
                rightButton.isEnabled = true
            }
        }
        else
        {
            let nextGame = databaseHelper.nextGame(category: categoryName!, game: gameName ?? "")
            if databaseHelper.prevGame(category: categoryName!, game: gameName!).isEmpty
            {
                leftButton.isEnabled = false
            }
            else
            {
                leftButton.isEnabled = true
            }
            if nextGame.isEmpty
            {
                rightButton.isEnabled = false
            }
            else
            {
                rightButton.isEnabled = true
            }
        }
    }
    
    @objc
    func floatingButtonClicked(buttin:UIButton)
    {
        let dialog = alertService.displayCreateNewListDialog(game: gameName)
        {
            //Toast.showToast(message: "update", controller: self)
            //self.list = self.databaseFavorites.getFavoritesList()
            //self.update()
        }
        
        present(dialog, animated: true)
    }
    
    func loadYTPlayer()
    {
        ytPlayer1.isHidden = true
        ytPlayer2.isHidden = true
        ytPlayer3.isHidden = true
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {
            var ids:[String] = []
            let matches = detector.matches(in: textLabel.text, options: [], range: NSRange(location: 0, length: textLabel.text.utf16.count))

            for match in matches {
                guard let range = Range(match.range, in: textLabel.text) else { continue }
                let url = textLabel.text[range]
                let id = URLComponents(string: String(url))?.queryItems?.first(where: { $0.name == "v" })?.value
                if id != nil
                {
                    ids.append(id!)
                }
            }
            if ids.count >= 1
            {
                ytPlayer1.isHidden = false
                ytPlayer1.load(withVideoId: ids[0])
            }
            if ids.count >= 2
            {
                ytPlayer2.isHidden = false
                ytPlayer2.load(withVideoId: ids[1])
            }
            if ids.count >= 3
            {
                ytPlayer3.isHidden = false
                ytPlayer3.load(withVideoId: ids[2])
            }
        }
    }
    
}
