//
//  Toast.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import UIKit

class Toast
{
    static func showToast(message : String, controller: UIViewController, height : Int = 35, width : Int = 320) {

        let toastLabel = UILabel(frame: CGRect(x: controller.view.frame.size.width/2 - CGFloat(width)/2, y: controller.view.frame.size.height-145, width: CGFloat(width), height: CGFloat(height)))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        controller.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
