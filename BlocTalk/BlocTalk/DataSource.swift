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

class DataSource: NSObject {
    
    static let sharedInstance = DataSource()
    var discoverable: Bool = false // by default users are discoverable
    var displayName: String = UIDevice.currentDevice().name
    var displayImage: UIImage?
    var allConversations: [Conversations] = []
    var availablePeers: [MCPeerID] = []
    var allUsers: [User] = []
    
    
    
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
    
    
    // MARK: - Multipeer Connectivity
    func connectedToPeer (peerID: MCPeerID){
        // receives the peer id - checks whether its already in array of available peers and if yes, updates status of the user to available
        if contains(availablePeers, peerID){
            println("peer previously found")
            for index in 0...allUsers.count {
                let user = allUsers[index]
                if user.peerID == peerID {
                    user.status = true
                    allUsers[index] = user
                }
            }
        } else {
            availablePeers.append(peerID)
            let newUser = User()
            newUser.peerID = peerID
            newUser.status = true
            allUsers.append(newUser)
        }
        println("available peers \(availablePeers)")
        println("all users: \(allUsers)")
    }
    
    
    
    //MARK: - Test Data
    
    func fakeConversations(peerID: MCPeerID){
        
        
        // fake conversation elements
        let conversationElement = ConversationElements()
        conversationElement.user = User()
        conversationElement.user.peerID = peerID
        conversationElement.comment = "testing my fake conversation"
        conversationElement.time = NSDate()
        
        
        let conversations = Conversations()
        conversations.conversationElements.append(conversationElement)
        conversations.user = conversationElement.user
        
        self.allConversations.append(conversations)
    }
   
}
