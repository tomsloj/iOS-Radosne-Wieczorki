//
//  ListOfFavoritesCell.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class ListOfFavoritesCell: UITableViewCell {
    
    @IBOutlet weak var nameOfFavorite: UILabel!
    
    func setCell(name:String)
    {
        nameOfFavorite.text = name
    }

}
