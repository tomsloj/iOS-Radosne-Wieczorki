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
    var fontSize:CGFloat!
    var toSend:String!
    let sService:SettingsService = SettingsService()
    let databaseHelper:DataBaseHelper = DataBaseHelper()
    var gamesArray:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fontSize = CGFloat(sService.getTextSize())
        
        gamesArray = databaseHelper.getGamesInCategory(category: txt)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if(fontSize != CGFloat(sService.getTextSize()))
        {
            fontSize = CGFloat(sService.getTextSize())
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        let alertController = UIAlertController(title: "hint", message: "selected \(indexPath.row)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        */
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        return gamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListTableViewCell
        
        let text = gamesArray[indexPath.row]
        
        cell.nameLabel.text = text
        cell.nameLabel.font = cell.nameLabel.font.withSize(fontSize-0.8)
        
        return cell
    }
}
