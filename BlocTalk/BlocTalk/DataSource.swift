//
//  DataSource.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 25/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

// singleton class

import UIKit

class DataSource: NSObject {
    
    static let sharedInstance = DataSource()
    var discoverable: Bool = false // by default users are discoverable
    var displayName: String = UIDevice.currentDevice().name
    
    
    override init(){
        super.init()
        
        retrieveUserSettings()
        
    }
    
    
    
    
    func retrieveUserSettings(){
        let settings = NSUserDefaults.standardUserDefaults()
        
        
        self.discoverable = settings.boolForKey("discoverable")
        
        if let displayNameSettings = settings.valueForKey("displayName") as? String{
            self.displayName = displayNameSettings
            println("displayName retrieved")
        }
        

    }
    
    
    
    func saveUserSettings(){
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(discoverable, forKey: "discoverable")
        
        if self.displayName != "" {
            settings.setValue(displayName, forKey: "displayName")
            println("display name != empty")
        } else {
            settings.setValue(UIDevice.currentDevice().name, forKey: "displayName")
            println("display name is empty")
        }
            
        
        
    }
    
   
}
