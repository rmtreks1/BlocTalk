//
//  ChatViewController.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 27/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatViewController: JSQMessagesViewController {
    
    var chatData: [JSQMessage]?
    var peerID: MCPeerID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // must set up SenderID and SenderDisplayName
        self.senderId = "rmtreks"
        self.senderDisplayName = "roshan m"

        if let tempPeerID = self.peerID {
            self.navigationItem.title = tempPeerID.displayName // replace this with the peerID display name
        } else {
            self.peerID = MCPeerID()
        }
        
        
        if let tempChatData = DataSource.sharedInstance.allMessages[self.peerID!]{
            chatData = tempChatData
        } else {
            chatData = []
        }
        
        
//        chatData = TestData.sharedInstance.allMessages["monk"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.collectionViewLayout.springinessEnabled = false
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveChat()
    }
    
    
    // MARK: - JSQMessagesCollectionViewDataSource Protocol
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let message = chatData![indexPath.item]
        
        return message
    }
    

    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = chatData![indexPath.item]
        
        if message.senderId == self.senderId {
            return TestData.sharedInstance.outgoingBubbleImageData
        }
        
        return TestData.sharedInstance.incomingBubbleImageData
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return TestData.sharedInstance.placeholderAvatar!
    }
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = chatData![indexPath.item]
        
        
        // display the date if time interval to the last time is > 1 hour
        
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        } else if shouldDisplayDate(indexPath.item) {
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    
    

    func shouldDisplayDate (index: Int) -> Bool{
        
        let message = chatData![index]
        
        if index > 0 {
            if let messageDate = message.date {
                let previousMessage = chatData![index-1]
                if let previousMessageDate = previousMessage.date {
                    let timeInterval = Int(message.date.timeIntervalSinceDate(previousMessage.date))
                    let shouldDisplay: Bool = timeInterval >= 3600
                    return shouldDisplay
                }
            }
        }
        return false
    }
    
    
    
 
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if shouldDisplayDate(indexPath.item) {
            return CGFloat(20)
        }
        return CGFloat(0)
    }
    
    
    
    //MARK: - Actions
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        println("did press send button")
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        println(message.text)
        
        MPCManager.sharedInstance.sendMessage(self.peerID!, message: message)
        
        
        chatData!.append(message)
        
        finishSendingMessageAnimated(true)
        
    }
    

    
    override func didPressAccessoryButton(sender: UIButton!) {
        println("camera button pressed - finish this function")
    }
    
        
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("number of messages are: \(chatData!.count)")
        return chatData!.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        println("done button pressed")
        
        
        // save the message
        DataSource.sharedInstance.allMessages[self.peerID!] = self.chatData
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func saveChat(){
        
        if let tempPeerID = self.peerID {
            DataSource.sharedInstance.allMessages[self.peerID!] = self.chatData
        }
        
    }
    
   
}
