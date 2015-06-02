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

//MARK: Protocol
protocol DataSourceDelegate {
    
    func userStatusChange (user: User, index: Int)
    func changeInUserConnections()
}




class DataSource: NSObject {
    
    //MARK: - Properties
    
    enum UserStatus {
        case Online
        case Offline
        case Unknown
    }
    
    
    
    static let sharedInstance = DataSource()
    
    
    var uniqueID: String? // way around the problem where PeerID keeps changing
    var discoverable: Bool = false // by default users are discoverable
    var displayName: String = UIDevice.currentDevice().name
    var displayImage: UIImage?
    

    var availablePeers: [MCPeerID] = []
    var allPeers = [MCPeerID: UserStatus]() // creates a dictionary to make it easier to do searches
    var allPeersUniqueID = [String: MCPeerID]()
    
    var allMessages = [MCPeerID: [JSQMessage]]() // replace String with MCPeerID
    var allMessagesPeers:[MCPeerID] = [] // replace String with MCPeerID

    var receivedMessages = [MCPeerID: [JSQMessage]]() // temporarily hold received messages
    
    var previouslyConnectedPeers = [String]() // store the unique ID as the Peer ID might keep changing
    
    var archivedPeers: [MCPeerID] = []
    
    var tempPeersUniqueID = [MCPeerID : String]()
    
    
    var delegate: DataSourceDelegate?
    
    
    // properties to delete
    //    var allConversations: [Conversations] = [] // potentially not used
    var allUsers: [User] = [] // can this be replaced by a store of connected peers(uniqueIDs).
    
    
    //MARK: - Settings
    func retrieveUserSettings(){
        let settings = NSUserDefaults.standardUserDefaults()
        
        if let tempAvailablePeersData = settings.objectForKey("availablePeers") as? NSData {
            self.availablePeers = (NSKeyedUnarchiver.unarchiveObjectWithData(tempAvailablePeersData) as? [MCPeerID])!
            populateAllPeers()
        }
        
        self.discoverable = settings.boolForKey("discoverable")
        
        if let displayNameSettings = settings.valueForKey("displayName") as? String{
            self.displayName = displayNameSettings
            println("displayName retrieved")
        }
        
        if self.discoverable {
            println("start advertisng availability")
            MPCManager.sharedInstance.startAdvertisingForPeers()
        }
        
        
        if let tempUniqueID = settings.valueForKey("uniqueID") as? String {
            self.uniqueID = tempUniqueID
        }
        
        if let tempPreviouslyConnectedPeers = settings.valueForKey("previouslyConnectedPeers") as? [String]{
            self.previouslyConnectedPeers = settings.valueForKey("previouslyConnectedPeers") as! [String]
        }
        
        
        println("***** retrieving settings *****")
        println("available peers: \(self.availablePeers)")
        
    }

    
    
    
   
    
    func saveUserSettings(){
        println("saving user settings")
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(discoverable, forKey: "discoverable")
        
        if let tempUniqueID = self.uniqueID{
        } else {
            makeUniqueID()
        }
        settings.setObject(self.uniqueID!, forKey: "uniqueID")

        
        
        if self.displayName != "" {
            settings.setValue(displayName, forKey: "displayName")
            println("display name != empty")
        } else {
            settings.setValue(UIDevice.currentDevice().name, forKey: "displayName")
            println("display name is empty")
        }
        
        settings.setObject(self.previouslyConnectedPeers, forKey: "previouslyConnectedPeers")
        
        
        // move this code to all closing or something
//        saveMessages()
        
    }
    
    
    func changeDiscoverability (discoverable: Bool){
        println("discoverability \(discoverable)")
        self.discoverable = discoverable
        if discoverable {
            
            if let tempUniqueID = self.uniqueID{
            } else {
                makeUniqueID()
            }
            MPCManager.sharedInstance.startAdvertisingForPeers()
            
        } else {
            println("turn off advertising")
            MPCManager.sharedInstance.stopAdvertisingForPeers()
        }
        
        saveUserSettings()
    }
 
    
    func makeUniqueID(){
        self.uniqueID = NSUUID().UUIDString
        println(self.uniqueID)
    }
    
    
    
    //MARK: - Peers
    
    func foundOrLostPeer (peerID: MCPeerID, userStatus: UserStatus, uniqueID: String){
        
        
        // if the user already exists then update status
        if let peerStatus = allPeers[peerID] {
            allPeers.updateValue(userStatus, forKey: peerID)
        }
        
            // else insert the user into both the dictionary and the array used as the dataSource for Peers TBVC
        else {
            
            // if its online
            if userStatus == UserStatus.Online {
                if let previousPeerID = allPeersUniqueID[uniqueID]{
                    allPeersUniqueID[uniqueID] = peerID
                    
                    // remove the previousPeerID
                    for (index,value) in enumerate(allPeers) {
                        if value.0 == previousPeerID {
                            allPeers.removeValueForKey(previousPeerID)
                        }
                    }
                    
                    
                    // remove from availablePeers
                    for (index,value) in enumerate(availablePeers) {
                        if value == previousPeerID {
                            availablePeers.removeAtIndex(index)
                        }
                    }
                    
                    
                    // remove from allMessagesPeers
                    for (index,value) in enumerate(allMessagesPeers) {
                        if value == previousPeerID {
                            availablePeers.removeAtIndex(index)
                        }
                    }
                    
                    
                    // replace the peerID in allMessages = [MCPeerID: [JSQMessage]]
                    for (index,value) in enumerate(allMessages) {
                        if value.0 == previousPeerID {
                            let messages = value.1
                            allMessages.removeValueForKey(previousPeerID)
                            allMessages[peerID] = messages
//                            allPeers.removeValueForKey(previousPeerID)
                        }
                    }

                    
                    // replace the peerID in receivedMessages = [MCPeerID: [JSQMessage]]
                    for (index,value) in enumerate(receivedMessages) {
                        if value.0 == previousPeerID {
                            let messages = value.1
                            receivedMessages.removeValueForKey(previousPeerID)
                            receivedMessages[peerID] = messages
                            //                            allPeers.removeValueForKey(previousPeerID)
                        }
                    }
                    
                }
            }
            
            
            allPeers[peerID] = userStatus
            availablePeers.append(peerID)
        }
        
        // saving Available Peers to defaults
        let settings = NSUserDefaults.standardUserDefaults()
        let availablePeersData =  NSKeyedArchiver.archivedDataWithRootObject(self.availablePeers)
        settings.setObject(availablePeersData, forKey: "availablePeers")
       
    }
    
    
    
    func autoConnectToPeer(peerID: MCPeerID, uniqueID: String) -> Bool{
        
        if contains(self.previouslyConnectedPeers, uniqueID) {
            return true
        }
        return false
    }
    
    
    func connectedToPeer (peerID: MCPeerID){
        if let uniqueID = self.tempPeersUniqueID[peerID]{
            self.previouslyConnectedPeers.append(uniqueID)
        }
    }
    
    
    func foundNewPeer (peerID: MCPeerID, uniqueID: String){
        self.tempPeersUniqueID[peerID] = uniqueID
    }
    
    
    
    func archivePeer (peerID: MCPeerID){
        
        println("archiving peer")
        
        // remove peer from allMessagesPeers
        for (index, value) in enumerate(allMessagesPeers){
            if value == peerID {
                allMessagesPeers.removeAtIndex(index)
                println("removing peer from allMessagesPeers")
            }
        }
        
        // add peer to archive Peer
        
        if !contains(archivedPeers, peerID){
            archivedPeers.append(peerID)
            println("adding peer to archive peers")
        }
    }
    
    
    // basic function - replace this with ability to select which peer to unarchive
    func unarchivePeers(){
        println("unarchive peers")
        archivedPeers = []
    }
    
    
    
    func populateAllPeers(){
        
        for peer in availablePeers {
            allPeers[peer] = UserStatus.Unknown
        }
    }
    
    
    
    //MARK: - Messages
    
    func receivedMessage (peerID: MCPeerID, message: JSQMessage){
//        allMessages[peerID]?.append(message)
        println("datasource receivedMessage, \(message.text)")
        var messageArray = [message]
        
        receivedMessages[peerID] = messageArray

        NSNotificationCenter.defaultCenter().postNotificationName(peerID.displayName, object: self)
    }
    
    
    func saveMessages(){
        
        println("saving messages")
        
        let settings = NSUserDefaults.standardUserDefaults()
        let allMessagesData = NSKeyedArchiver.archivedDataWithRootObject(self.allMessages)
        let allMessagesPeersData = NSKeyedArchiver.archivedDataWithRootObject(self.allMessagesPeers)
        settings.setObject(allMessagesData, forKey: "allMessages")
        settings.setObject(allMessagesPeersData, forKey: "allMessagesPeers")
    }
    
    
    func retrieveMessages(){
        let settings = NSUserDefaults.standardUserDefaults()
        
        if let tempAllMessagesData: AnyObject = settings.objectForKey("allMessages") {
            self.allMessages = (NSKeyedUnarchiver.unarchiveObjectWithData(tempAllMessagesData as! NSData) as? [MCPeerID: [JSQMessage]])!
        }
        
        if let tempAllMessagesPeersData: AnyObject = settings.objectForKey("allMessagesPeers") {
            self.allMessagesPeers = NSKeyedUnarchiver.unarchiveObjectWithData(tempAllMessagesPeersData as! NSData) as! [MCPeerID]
        }
        
        
        
        
        
        if let tempAvailablePeersData = settings.objectForKey("availablePeers") as? NSData {
            self.availablePeers = (NSKeyedUnarchiver.unarchiveObjectWithData(tempAvailablePeersData) as? [MCPeerID])!
            populateAllPeers()
        }
        
        self.discoverable = settings.boolForKey("discoverable")
        
        if let displayNameSettings = settings.valueForKey("displayName") as? String{
            self.displayName = displayNameSettings
            println("displayName retrieved")
        }

    }
    
    
  
}
