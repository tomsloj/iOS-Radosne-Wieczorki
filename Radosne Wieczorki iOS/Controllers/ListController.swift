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
        
        if txt == "all"
        {
            title = "Wszystkie zabawy"
        }
        else
        {
            title = String(txt.prefix(1)).capitalized + String(txt.dropFirst())
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if(fontSize != CGFloat(sService.getTextSize()))
        {
            fontSize = CGFloat(sService.getTextSize())
            tableView.reloadData()
        }
        
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.red
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
          self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            self.navigationController?.navigationBar.tintColor = UIColor.white
        } else {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
        if sService.isDarkMode() {
            overrideUserInterfaceStyle = .dark
        }
        else
        {
            overrideUserInterfaceStyle = .light
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
            viewController.categoryName = txt
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 2.5

        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}
