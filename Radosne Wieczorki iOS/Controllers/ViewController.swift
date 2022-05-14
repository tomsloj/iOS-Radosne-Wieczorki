//
//  ViewController.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var message = "error"
    
    @IBOutlet weak var dancesButton: UIButton!
    @IBOutlet weak var competitionButton: UIButton!
    @IBOutlet weak var integrationButton: UIButton!
    @IBOutlet weak var songsButton: UIButton!
    @IBOutlet weak var perceptivityButton: UIButton!
    @IBOutlet weak var efficiencyButton: UIButton!
    
    let sService:SettingsService = SettingsService()
    
    var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
//        centerVertically()
        
//        perceptivityButton.contentVerticalAlignment = .fill
//        perceptivityButton.contentHorizontalAlignment = .fill
//       perceptivityButton.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        if #available(iOS 13.0, *) {
//            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.red
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
          self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            self.navigationController?.navigationBar.tintColor = UIColor.white
        } else {
//            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
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
        

//        if let navigationBar = self.navigationController?.navigationBar {
//            let firstFrame = CGRect(x: 0, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
//
//            label = UILabel(frame: firstFrame)
//            label.text = "Radosne Wieczorki"
//
//            navigationBar.addSubview(label)
//        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        label.constraints.forEach { $0.isActive = false }
//        label.removeFromSuperview()
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    @IBAction func danceClick(_ sender: UIButton) {
        switch sender {
        case dancesButton:
            message = "tańce"
        case competitionButton:
            message = "rywalizacja"
        case integrationButton:
            message = "integracyjne"
        case songsButton:
            message = "piosenki"
        case perceptivityButton:
            message = "refleks"
        case efficiencyButton:
            message = "sprawnościowe"
        default:
            message = "really error"
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: (Any)?)
    {
        switch segue.identifier
        {
        case "toList":
            send(segue:segue)
        case "toListAll":
            let viewController = segue.destination as! ListController
            viewController.txt = "all"
        default:break
        }
        
    }
    
    private func send(segue:UIStoryboardSegue)
    {
        let viewController = segue.destination as! ListController
        viewController.txt = message
    }
    
    
}

extension UINavigationController {
    func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }

    func setTintColor(_ color: UIColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        self.navigationBar.tintColor = color
    }

    func backgroundColor(_ color: UIColor) {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.barTintColor = color
        navigationBar.shadowImage = UIImage()
    }
}
