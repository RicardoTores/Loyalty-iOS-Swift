//
//  ACUserConfig.swift
//
//  Created by Alex on 11/9/15.
//  Copyright (c) 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation
import UIKit

public class ACUserConfig {
    
    /**
       Hide the default constructor to avoid creating an instance of this class
    */
    private init() {}

    //----------------------------------------------------------------------
    // Set
    //----------------------------------------------------------------------
    /*!
       @method 
       @discussion
       @param 
       @return
    */
    class func setValue(value: AnyObject?, forKey: String) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setValue(value, forKey: forKey)
        prefs.synchronize()
    }
    
    class func setInt(value: Int, forKey: String) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(value, forKey: forKey)
        prefs.synchronize()
    }
    
    class func setString(value: String, forKey: String) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(value, forKey: forKey)
        prefs.synchronize()
    }

    class func setBool(value: Bool, forKey: String) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setBool(value, forKey: forKey)
        prefs.synchronize()
    }

    //----------------------------------------------------------------------
    // Get
    //----------------------------------------------------------------------
    class func getInt(forKey: String) -> Int {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return prefs.valueForKey(forKey) as! Int
    }

    class func getBool(forKey: String) -> Bool {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return prefs.valueForKey(forKey) as! Bool
    }

    class func getString(forKey: String) -> String {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return prefs.valueForKey(forKey) as! String
    }
}