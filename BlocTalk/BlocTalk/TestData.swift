//
//  TestData.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 28/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TestData: NSObject {
   
    static let sharedInstance = TestData()
    var messages = [JSQMessage]()
    var allMessages = [String: [JSQMessage]]() // dictionary with array of JSQMessages - in final version replace String with MCPeerID
    var outgoingBubbleImageData: JSQMessagesBubbleImage?
    var incomingBubbleImageData: JSQMessagesBubbleImage?
    var placeholderAvatar: JSQMessagesAvatarImage?
    
    
    
//    
//    @property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
//    
//    @property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
//    
    
    override init () {
        super.init()
        
        createDemoData()
        createMessageBubbles()
        createAvatar()
        
        
        
    }
    
    
    func createDemoData(){
        // text messages
        
        let message1 = JSQMessage(senderId: "rmtreks", displayName: "roshan m", text: "hello world!")
        messages.append(message1)
        
        
        let calendar = NSCalendar.currentCalendar()
        let yesterday = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: NSDate(), options: nil)
        
        
        let message2 = JSQMessage(senderId: "rmtreks", senderDisplayName: "roshan m", date: yesterday!, text: "hello again")
        messages.append(message2)
        
        let message3 = JSQMessage(senderId: "sub", senderDisplayName: "subhaga", date: NSDate(), text: "whats up")
        messages.append(message3)
        
        let message4 = JSQMessage(senderId: "sub", senderDisplayName: "subhaga", date: NSDate(), text: "whats up again")
        messages.append(message4)
        
        
        
        let nextHour = calendar.dateByAddingUnit(.CalendarUnitHour, value: 1, toDate: NSDate(), options: nil)
        let message5 = JSQMessage(senderId: "sub", senderDisplayName: "subhaga", date: nextHour!, text: "whats up an hour later")
        messages.append(message5)

        
        let photoItem = JSQPhotoMediaItem(image: UIImage(named: "sampleProfileImage.jpg"))
        let photoMessage = JSQMessage(senderId: "rmtreks", senderDisplayName: "roshan m", date: nextHour!, media: photoItem)
        messages.append(photoMessage)
        
        
        allMessages["sub"] = messages
        
    }
    
    
    func createMessageBubbles(){
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        
        // colors for the message bubbles
        let lightGrayColor: UIColor = UIColor(hue: CGFloat(240.0/360.0), saturation: CGFloat(0.02), brightness: CGFloat(0.92), alpha: CGFloat(1.0))
        let greenColor: UIColor = UIColor(hue: CGFloat(130.0/360.0), saturation: CGFloat(0.68), brightness: CGFloat(0.84), alpha: CGFloat(1.0))
        let blueColor: UIColor = UIColor(hue: CGFloat(210.0/360.0), saturation: CGFloat(0.94), brightness: CGFloat(1.0), alpha: CGFloat(1.0))
        
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(lightGrayColor)
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(blueColor)
    }
    
    
    func createAvatar() {
        let avatarImage: UIImage = UIImage(named: "demo_avatar")!
        self.placeholderAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(avatarImage, diameter: 30)
        
    }
    
    
    
    
}
