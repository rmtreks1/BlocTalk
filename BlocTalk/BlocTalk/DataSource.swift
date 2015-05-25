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
    
   
}
