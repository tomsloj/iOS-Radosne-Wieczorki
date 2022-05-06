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
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var sendOpinionLabel: UILabel!
    @IBOutlet weak var iconsLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    let sService:SettingsService = SettingsService()
    
    override func viewDidLoad() {
        if sService.isDarkMode() {
            darkModeSwitch.isOn = true
            overrideUserInterfaceStyle = .dark
        }
        else
        {
            darkModeSwitch.isOn = false
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textSizeLabel.font = textSizeLabel.font.withSize(CGFloat(sService.getTextSize()))
        darkModeLabel.font = darkModeLabel.font.withSize(CGFloat(sService.getTextSize()))
        sendOpinionLabel.font = sendOpinionLabel.font.withSize(CGFloat(sService.getTextSize()))
        iconsLabel.font = iconsLabel.font.withSize(CGFloat(sService.getTextSize()))
    }
    
    
    
    @IBAction func pllusClicked(_ sender: Any) {
        
        
        if sService.getTextSize() < 19
        {
            sService.setTextSize(size: sService.getTextSize() + 2.0)
            
            
            textSizeLabel.font = textSizeLabel.font.withSize(CGFloat(sService.getTextSize()))
            darkModeLabel.font = darkModeLabel.font.withSize(CGFloat(sService.getTextSize()))
            sendOpinionLabel.font = sendOpinionLabel.font.withSize(CGFloat(sService.getTextSize()))
            iconsLabel.font = iconsLabel.font.withSize(CGFloat(sService.getTextSize()))
            
            
            
            
        }
    }
    
    @IBAction func minusClicked(_ sender: Any) {
        
        if sService.getTextSize() > 9
        {
            sService.setTextSize(size: sService.getTextSize() - 2.0)
            
            
            textSizeLabel.font = textSizeLabel.font.withSize(CGFloat(sService.getTextSize()))
            darkModeLabel.font = darkModeLabel.font.withSize(CGFloat(sService.getTextSize()))
            sendOpinionLabel.font = sendOpinionLabel.font.withSize(CGFloat(sService.getTextSize()))
            iconsLabel.font = iconsLabel.font.withSize(CGFloat(sService.getTextSize()))
        }
    }
    
    @IBAction func darkModeStateChanged(_ sender: Any) {
        sService.changeDarkModeStatus()
        if sService.isDarkMode() {
            overrideUserInterfaceStyle = .dark
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
        else
        {
            overrideUserInterfaceStyle = .light
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
        
        
    }
    
}
