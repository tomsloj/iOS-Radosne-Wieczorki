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
        tableView.tableFooterView = UIView()
        
        list = self.databaseFavorites.getGamesInFavorite(name: favoriteName)
        Toast.showToast(message: "display favorite", controller: self)

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
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToDisplay"
        {
            let viewController = segue.destination as! DisplayController
            viewController.gameName = toSend
        }
    }
}
