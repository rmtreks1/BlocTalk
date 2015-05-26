//
//  MPCManager.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 25/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import MultipeerConnectivity

protocol MPCManagerDelegate {
    func didReceiveInvitationFromPeer (peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!)
}



class MPCManager: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
   
    static let sharedInstance = MPCManager()
    var delegate = MPCManagerDelegate?()
    let serviceType = "BlocTalk"
    var browser : MCNearbyServiceBrowser!
    var advertiser : MCNearbyServiceAdvertiser!
    var assistant: MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    var availablePeers: [MCPeerID] = []
    let notificationKey = "MPCManagerNotifications"
    
    
    override init() {
        super.init()
        
        
        let displayName = DataSource.sharedInstance.displayName
        peerID = MCPeerID(displayName: displayName)
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        

        // comment this out if want control of advertiser, otherwise leave commented out as using assistant
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self



//        assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        
        
        
    }
    
    func startBrowsingForPeers(){
        self.browser.startBrowsingForPeers()
    }
    
    func startAdvertisingForPeers(){
        self.advertiser.startAdvertisingPeer()
        //        self.assistant.start()
        println("started advertising for peers")
    }
    
    
    
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        println("received invite from \(peerID.displayName)")

        self.delegate?.didReceiveInvitationFromPeer(peerID, invitationHandler: invitationHandler)

    }
    
    
    // MARK: - MCNearbyServiceBrowserDelegate
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("found peer \(peerID)")
        
        // check if peer not already in list
        if !contains(availablePeers, peerID) {
            availablePeers.append(peerID)
            NSNotificationCenter.defaultCenter().postNotificationName(self.notificationKey, object: self)
        }

    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        /*
        IMPORTANT
        Because there is a delay between when a host leaves a network and when the underlying Bonjour layer detects that it has left, 
        the fact that your app has not yet received a disappearance callback does not guarantee that it can communicate with the peer successfully.
        */
        
        println("lost peer \(peerID)")
        for (index,value) in enumerate(availablePeers) {
            if value == peerID {
                availablePeers.removeAtIndex(index)
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(self.notificationKey, object: self)
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
    
    
    // MARK: - MCSessionDelegate
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
        case MCSessionState.Connected:
            println("Connected to session: \(session)")
            DataSource.sharedInstance.connectedToPeer(peerID)
            DataSource.sharedInstance.fakeConversations(peerID)
            
            
        case MCSessionState.Connecting:
            println("Connecting to session: \(session)")
            
        default:
            println("Did not connect to session: \(session)")
        }
        
    }
    
    
    //MARK: - Invites
    func invitePeer (peerID: MCPeerID){
        self.browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 20)
    }
    
}
