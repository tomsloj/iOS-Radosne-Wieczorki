//
//  displayFavorite.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class DisplayFavorite: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteName:String = ""
    
    var toSend:String!
    
    let databaseFavorites = DatabaseFavorites()
    
    var list:[String] = []
    let sService:SettingsService = SettingsService()
    var fontSize:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = favoriteName
        
        tableView.tableFooterView = UIView()
        
        list = self.databaseFavorites.getGamesInFavorite(name: favoriteName)
        Toast.showToast(message: databaseFavorites.getJSON(favoriteListName: favoriteName), controller: self)
//        let tmp = databaseFavorites.importJSON(json: databaseFavorites.getJSON(favoriteListName: favoriteName))
        fontSize = CGFloat(sService.getTextSize())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if(fontSize != CGFloat(sService.getTextSize()))
        {
            fontSize = CGFloat(sService.getTextSize())
            tableView.reloadData()
        }
    }
    
    func update()
    {
        self.tableView.reloadData()
    }
    
    @IBAction func exportClicker(_ sender: Any) {
        let JSONString = databaseFavorites.getJSON(favoriteListName: favoriteName)
        let filePath = NSHomeDirectory() + "/Documents/test.json"
        print("export")
        print(filePath)
        if FileManager.default.createFile(atPath: filePath, contents: JSONString.data(using: .utf8), attributes: nil)
        {
            Toast.showToast(message: "Lista została zapisana do pliku", controller: self)
        }
        else
        {
            Toast.showToast(message: "Eksport listy zakończył się niepowodzeniem", controller: self)
        }
    }
    
    @IBAction func deleteList(_ sender: Any) {
        databaseFavorites.deleteFavorite(name: favoriteName)
        Toast.showToast(message: "Usunięto listę: " + favoriteName, controller: self)
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension DisplayFavorite: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let databaeHelper:DataBaseHelper = DataBaseHelper()
//
//        let gamesArray = databaeHelper.getGamesInCategory(category: txt)
        
        let text = list[indexPath.row]
        
        toSend = text
        
        performSegue(withIdentifier: "goToDisplay", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayFavoriteCell") as! DisplayFavoriteCell

        let name = list[indexPath.row]
        
        cell.setCell(name: name)
        cell.gameName.font = cell.gameName.font.withSize(fontSize)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 2.5

        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToDisplay"
        {
            let viewController = segue.destination as! DisplayController
            viewController.gameName = toSend
            viewController.categoryName = favoriteName
            viewController.isFavorite = true
        }
    }
}
