//
//  DisplayFavoriteCell.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class DisplayFavoriteCell: UITableViewCell {
    
    @IBOutlet weak var gameName: UILabel!
    
    func setCell(name: String)
    {
        gameName.text = name
    }
}
