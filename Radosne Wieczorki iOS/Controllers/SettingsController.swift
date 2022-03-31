//
//  SettingsController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    
    @IBOutlet weak var textSizeLabel: UILabel!
    
    let sService:SettingsService = SettingsService()
    
    override func viewDidLoad() {
        //textSizeLabel.font = textSizeLabel.font.withSize(CGFloat(sService.getTextSize()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textSizeLabel.font = textSizeLabel.font.withSize(CGFloat(sService.getTextSize()))
        //Toast.showToast(message: "aaaa", controller: self)
    }
    
    
    
    @IBAction func pllusClicked(_ sender: Any) {
        
        
        if sService.getTextSize() < 19
        {
            sService.setTextSize(size: sService.getTextSize() + 2.0)
            
            
            textSizeLabel.font = textSizeLabel.font.withSize(CGFloat(sService.getTextSize()))
            
            
            
            
        }
    }
    
    @IBAction func minusClicked(_ sender: Any) {
        
        if sService.getTextSize() > 9
        {
            sService.setTextSize(size: sService.getTextSize() - 2.0)
            
            
            textSizeLabel.font = textSizeLabel.font.withSize(CGFloat(sService.getTextSize()))
        }
    }
    
    
}
