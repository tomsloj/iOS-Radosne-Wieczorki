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
    
    @IBOutlet weak var wholeListButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
        case wholeListButton:
            message = "all"
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
        default:
            message = "error9"
        }
        
    }
    
    private func send(segue:UIStoryboardSegue)
    {
        let viewController = segue.destination as! ListController
        viewController.txt = message
    }
    
    
}
