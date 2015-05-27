//
//  DataSource.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 25/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

// singleton class

import UIKit
import MultipeerConnectivity


protocol DataSourceDelegate {
    
    func userStatusChange (user: User, index: Int)
    func changeInUserConnections()
}




class DataSource: NSObject {
    
    
    enum UserStatus {
        case Online
        case Offline
    }
    
    
    
    static let sharedInstance = DataSource()
    var discoverable: Bool = false // by default users are discoverable
    var displayName: String = UIDevice.currentDevice().name
    var displayImage: UIImage?
    var allConversations: [Conversations] = []
    var availablePeers: [MCPeerID] = []
    var allUsers: [User] = []
    var allPeers = [MCPeerID: UserStatus]() // creates a dictionary to make it easier to do searches
    
    var delegate: DataSourceDelegate?
    
    
    
    override init(){
        super.init()
        
//        retrieveUserSettings()
        
    }
    
    
    
    //MARK: - Settings
    func retrieveUserSettings(){
        let settings = NSUserDefaults.standardUserDefaults()
        
        
        self.discoverable = settings.boolForKey("discoverable")
        
        if let displayNameSettings = settings.valueForKey("displayName") as? String{
            self.displayName = displayNameSettings
            println("displayName retrieved")
        }
        
        if self.discoverable {
            println("start advertisng availability")
            MPCManager.sharedInstance.startAdvertisingForPeers()
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
    
    
    func changeDiscoverability (discoverable: Bool){
        println("discoverability \(discoverable)")
        self.discoverable = discoverable
        if discoverable {
            MPCManager.sharedInstance.startAdvertisingForPeers()
        } else {
            println("turn off advertising")
        }
    }
    
    
    // MARK: - Multipeer Connectivity
    func connectedToPeer (peerID: MCPeerID){
        // receives the peer id - checks whether its already in array of available peers and if yes, updates status of the user to available
        if contains(availablePeers, peerID){
            println("peer previously found")
            for index in 0...allUsers.count-1 {
                let user = allUsers[index]
                if user.peerID == peerID {
                    user.status = true
                    allUsers[index] = user
                    self.delegate?.userStatusChange(user, index: index)
                }
            }
        } else {
            availablePeers.append(peerID)
            let newUser = User()
            newUser.peerID = peerID
            newUser.status = true
            allUsers.append(newUser)

        }
        self.delegate?.changeInUserConnections()
        println("available peers \(availablePeers)")
        println("all users: \(allUsers)")
    }
    
    
    
    func foundOrLostPeer (peerID: MCPeerID, userStatus: UserStatus){
        
        // if the user already exists then update status
        if let peerStatus = allPeers[peerID] {
            allPeers.updateValue(userStatus, forKey: peerID)
        }
        
            // else insert the user
        else {
            allPeers[peerID] = userStatus
        }
        
        let userStatusString = allPeers[peerID]!
        switch userStatusString {
        case .Online:
            println("test of function foundPeer. peer status is Online")
        
        case .Offline:
            println("test of function foundPeer. peer status is Offline")
        }
    }
    
    
    
    func lostPeer (peerID: MCPeerID){
        
        
        
        
    }
    
    
    func ignorePeer (peerID: MCPeerID){
        
    }
   
}
