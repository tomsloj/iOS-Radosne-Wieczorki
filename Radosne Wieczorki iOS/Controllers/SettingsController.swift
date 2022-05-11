//
//  SettingsController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit
import MessageUI

class SettingsController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var textSizeLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var sendOpinionLabel: UILabel!
    @IBOutlet weak var iconsLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    let sService:SettingsService = SettingsService()
    
    var stackSize:Int = 0
    
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
        stackSize = (self.navigationController?.viewControllers.count)!
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
    
    @IBAction func sendMailClicked(_ sender: Any) {
        let mailComposeViewController = configureMailComposer()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                Toast.showToast(message: "Nie można wysłać maila", controller: self)
            }
    }
    
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["300268@pw.edu.pl"])
        mailComposeVC.setSubject("Radosne Wieczorki - uwagi")
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if result == .sent
        {
            Toast.showToast(message: "Dziękujemy za kontakt", controller: self)
        }
    }
    
    @IBAction func allGamesClicked(_ sender: Any) {
        print((self.navigationController?.viewControllers.count)!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print((self.navigationController?.viewControllers.count)!)
//        print(stackSize)
//        print("----")
//        if stackSize < (self.navigationController?.viewControllers.count)!
//        {
//            guard let navigationController = self.navigationController else { return }
//            var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
//            navigationArray.remove(at: navigationArray.count - 2)
//            self.navigationController?.viewControllers = navigationArray
//        }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: (Any)?)
    {
        switch segue.identifier
        {
        case "toList":
            let viewController = segue.destination as! ListController
            viewController.txt = "all"
        default: break
        }
    }
}
