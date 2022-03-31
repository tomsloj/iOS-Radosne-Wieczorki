//
//  SearchController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    @IBOutlet weak var toFindField: UITextField!
    
    @IBOutlet weak var titlesSwitch: UISwitch!
    @IBOutlet weak var textSwitch: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!
    
    var list:[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton)
    {
        let databaseHelper = DataBaseHelper()
        
        let toFind = toFindField.text
        
        let titleChecked = titlesSwitch.isOn
        let textChecked = textSwitch.isOn
        
        if titleChecked == false && textChecked == false
        {
            list.append("nr 1")
            self.tableView.reloadData()
            //TODO wyświetl komunikat że musi być coś zaznaczone
        }
        else
        if toFind == nil || toFind == ""
        {
            list.append("nr 2")
            self.tableView.reloadData()
            //TODO wyświetl komunikat o uzupełnieniu wyszukiwania
        }
        else
        {
            list = databaseHelper.find(toFind: toFind!, name: titleChecked, text: textChecked)
            
            self.tableView.reloadData()

            
        }
    }
    func update()
    {
        self.tableView.reloadData()
    }
    
    
    
    
}

extension SearchController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Display") as? DisplayController
        
        let game = list[indexPath.row]
        
        vc?.gameName = game
        self.navigationController?.pushViewController(vc!, animated: true )
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
        
        
        
        let text = list[indexPath.row]
        
        cell.setCell(game: text)
        
        return cell
    }
}
