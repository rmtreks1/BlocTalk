//
//  TestData.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 28/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class TestData: NSObject {
   
    var messages = [JSQMessage]()
    
    
    
    func createDemoData(){
        // text messages
        
        let message1 = JSQMessage(senderId: "rmtreks", displayName: "roshan m", text: "hello world!")
        messages.append(message1)
        
        let message2 = JSQMessage(senderId: "rmtreks", senderDisplayName: "roshan m", date: NSDate(), text: "hello again")
        messages.append(message2)
        
        let message3 = JSQMessage(senderId: "sub", senderDisplayName: "subhaga", date: NSDate(), text: "whats up")
        messages.append(message3)
    }
    
    
    
    
    
    
    
    
    
}
