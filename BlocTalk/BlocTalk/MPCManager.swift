//
//  MPCManager.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 25/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import MultipeerConnectivity

class MPCManager: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
   
    static let sharedInstance = MPCManager()
    let serviceType = "BlocTalk"
    var browser : MCNearbyServiceBrowser!
    var advertiser : MCNearbyServiceAdvertiser!
    var assistant: MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    var availablePeers: [MCPeerID] = []
    
    
    override init() {
        super.init()
        
        
        let displayName = DataSource.sharedInstance.displayName
        peerID = MCPeerID(displayName: displayName)
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        
        /*
        // comment this out if want control of advertiser, otherwise leave commented out as using assistant
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        */


        assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        
    }
    
    func startBrowsingForPeers(){
        self.browser.startBrowsingForPeers()
    }
    
    func startAdvertisingForPeers(){
        self.assistant.start()
        println("started advertising for peers")
    }
    
    
    
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        println("received invite from \(peerID.displayName)")
        // insert alert or something to handle what to do when receive invite
    }
    
    
    // MARK: - MCNearbyServiceBrowserDelegate
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        availablePeers.append(peerID)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        for (index,value) in enumerate(availablePeers) {
            if value == peerID {
                availablePeers.removeAtIndex(index)
            }
        }
        
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
    
    
    
}
