//
//  ListOfFavoritesController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ListOfFavoritesController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let alertService = AlertService()
    
    var list:[String] = []
    
    var toSend:String = ""
    
    let databaseFavorites = DatabaseFavorites()
    let sService:SettingsService = SettingsService()
    var fontSize:CGFloat!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    
        list = databaseFavorites.getFavoritesList()
        
        fontSize = CGFloat(sService.getTextSize())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newList = databaseFavorites.getFavoritesList()
        if(fontSize != CGFloat(sService.getTextSize()) || list.count != newList.count)
        {
            list = newList
            fontSize = CGFloat(sService.getTextSize())
            tableView.reloadData()
        }
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
    @IBAction func importClicked(_ sender: Any) {
        let types = UTType.types(tag: "json", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
              didPickDocumentsAt urls: [URL])
    {
        var result = ""
        do {
            result = try String(contentsOf: urls[0], encoding: .utf8)
        }
        catch {print("error import")}
        if !databaseFavorites.importJSON(json: result) || result.isEmpty
        {
            Toast.showToast(message: "Import zakończył się niepowodzeniem", controller: self)
        }
        else
        {
            Toast.showToast(message: "Lista została zainportowana", controller: self)
            list = databaseFavorites.getFavoritesList()
            update()
        }
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
        cell.nameOfFavorite.font = cell.nameOfFavorite.font.withSize(fontSize)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "openFavorite"
        {
            let viewController = segue.destination as! DisplayFavorite
            viewController.favoriteName = toSend
        }
    }
    
}
