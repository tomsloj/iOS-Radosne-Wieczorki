//
//  ListOfFavoritesController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class ListOfFavoritesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let alertService = AlertService()
    
    var list:[String] = []
    
    var toSend:String = ""
    
    let databaseFavorites = DatabaseFavorites()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    
        list = databaseFavorites.getFavoritesList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func createNewFavoriteClicked(_ sender: Any) {
        
        let dialog = alertService.displayCreateNewListDialog(game: nil)
        {
            //Toast.showToast(message: "update", controller: self)
            self.list = self.databaseFavorites.getFavoritesList()
            self.update()
        }
        
        dialog.tableView = tableView
        
        present(dialog, animated: true)
        
        Toast.showToast(message: "dialog", controller: self)
        
    }
    
    func update()
    {
        self.tableView.reloadData()
    }

    
}

extension ListOfFavoritesController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let storyboard = UIStoryboard(name: "", bundle: nil)
        
        //let displayController = storyboard.instantiateViewController(withIdentifier: "DisplayController") as! DisplayController
        //self.navigationController?.pushViewController(displayController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    
        let text = list[indexPath.row]
        
        toSend = text

        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "openFavorite", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listOfFavoritesCell") as! ListOfFavoritesCell

        
        let name = list[indexPath.row]
        
        cell.setCell(name: name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "openFavorite"
        {
            let viewController = segue.destination as! DisplayFavorite
            viewController.favoriteName = toSend
        }
    }
    
}
