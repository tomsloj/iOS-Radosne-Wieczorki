//
//  List.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var txt:String = ""
    var toSend:String!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        let alertController = UIAlertController(title: "hint", message: "selected \(indexPath.row)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        */
        tableView.deselectRow(at: indexPath, animated: true)
        
        let databaeHelper:DataBaseHelper = DataBaseHelper()
        
        let gamesArray = databaeHelper.getGamesInCategory(category: txt)
        
        let text = gamesArray[indexPath.row]
        
        toSend = text
        
        performSegue(withIdentifier: "goToDisplay", sender: self)
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToDisplay"
        {
            let viewController = segue.destination as! DisplayController
            viewController.gameName = toSend
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let databaeHelper:DataBaseHelper = DataBaseHelper()
        let gamesArray = databaeHelper.getGamesInCategory(category: txt)
        return gamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListTableViewCell
        
        let databaeHelper:DataBaseHelper = DataBaseHelper()
        let gamesArray = databaeHelper.getGamesInCategory(category: txt)
        
        let text = gamesArray[indexPath.row]
        
        cell.nameLabel.text = text
        
        return cell
    }
}
