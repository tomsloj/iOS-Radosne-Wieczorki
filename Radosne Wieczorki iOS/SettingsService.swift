//
//  SettingsService.swift
//  Radosne Wieczorki iOS
//
//  Created by user on 30/03/2022.
//  Copyright © 2022 tomsloj. All rights reserved.
//

import Foundation

class SettingsService
{
    private var textSize:Int?
    
    private let textSizeKey = "textSize"
    private let prevVersionKey = "prevVersion"
    
    public func setTextSize(size:Double)
    {
        let preferences = UserDefaults.standard
        preferences.set(size, forKey: textSizeKey)
        preferences.synchronize()
    }
    
    public func getTextSize()->Double
    {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: textSizeKey) == nil
        {
            return 15.0
        }
        else
        {
            return preferences.double(forKey: textSizeKey)
        }
    }
    
    public func setPrevVersion(version:String)
    {
        let preferences = UserDefaults.standard
        preferences.set(version, forKey: prevVersionKey)
        preferences.synchronize()
    }
    
    public func getPrevVersion()->String
    {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: textSizeKey) == nil
        {
            return "noData"
        }
        else
        {
            return preferences.string(forKey: prevVersionKey)!
        }
    }
    
    public func getCurrentVersion()->String
    {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        return appVersion ?? "error"
    }
    
    
    
}
