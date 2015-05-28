//
//  TestData.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 28/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class TestData: NSObject {
   
    static let sharedInstance = TestData()
    var messages = [JSQMessage]()
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
        
        let message2 = JSQMessage(senderId: "rmtreks", senderDisplayName: "roshan m", date: NSDate(), text: "hello again")
        messages.append(message2)
        
        let message3 = JSQMessage(senderId: "sub", senderDisplayName: "subhaga", date: NSDate(), text: "whats up")
        messages.append(message3)
    }
    
    
    func createMessageBubbles(){
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.blueColor())
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.greenColor())
        
    }
    
    
    func createAvatar() {
        
        let avatarImage: UIImage = UIImage(named: "demo_avatar")!
        self.placeholderAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(avatarImage, diameter: 30)
        
    }
    
    
    
    
}
