//
//  User.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 25/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class User: NSObject {
   
    var peerID: MCPeerID!
    var status: Bool = false // user status whether user is online or offline
    var profilePicture: UIImage?
    
    
}
