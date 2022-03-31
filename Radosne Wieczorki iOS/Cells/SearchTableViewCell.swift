//
//  SearchTableViewCell.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setCell(game:String)
    {
        nameLabel.text = game
    }

}
