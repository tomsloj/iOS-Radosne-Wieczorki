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
    
    let databaseFavorites = DatabaseFavorites()
    
    var list:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        list = self.databaseFavorites.getGamesInFavorite(name: favoriteName)
        Toast.showToast(message: "display favorite", controller: self)

    }
    
    func update()
    {
        self.tableView.reloadData()
    }
    
    
}

extension DisplayFavorite: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "openFavorite"
        {
            
        }
    }
}
