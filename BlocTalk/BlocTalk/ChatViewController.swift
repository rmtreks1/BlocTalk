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
    @IBOutlet var peerStatusButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("view did load")

        
       
        // must set up SenderID and SenderDisplayName
        if let tempSenderId = DataSource.sharedInstance.uniqueID {
            self.senderId = tempSenderId as String
        } else {
            DataSource.sharedInstance.makeUniqueID()
            self.senderId = DataSource.sharedInstance.uniqueID! as String
        }
        
        self.senderDisplayName = DataSource.sharedInstance.displayName
        
        loadChatData()
        
        // user status
        if let userStatus = DataSource.sharedInstance.allPeers[peerID!]{
            
            var title = "test"
            switch userStatus {
            case DataSource.UserStatus.Online:
                title = "Online"
                
            case DataSource.UserStatus.Offline:
                title = "Offline"
                
            default:
                title = "Unknown"
            }
            
            self.peerStatusButton.title = title
        }
        
     
        
    }
    
    
    func loadChatData(){
        // must set up SenderID and SenderDisplayName
        
        if let tempPeerID = self.peerID {
            self.navigationItem.title = tempPeerID.displayName // replace this with the peerID display name
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNewMessage", name: self.peerID?.displayName, object: nil)
        } else {
            self.peerID = MCPeerID()
        }
        
        
        if let tempChatData = DataSource.sharedInstance.allMessages[self.peerID!]{
            chatData = tempChatData
        } else {
            chatData = []
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("view will appear")
//        self.collectionView.reloadData()
    }
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("view did appear")
        
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
        
        println("did press send button. Sender id is: \(senderId)")
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        println(message.text)
        
        MPCManager.sharedInstance.sendMessage(self.peerID!, message: message)
        
        DataSource.sharedInstance.sentMessage(self.peerID!, message: message)
//        chatData!.append(message)
        self.loadChatData()

        finishSendingMessageAnimated(true)
        
    }
    

    
    override func didPressAccessoryButton(sender: UIButton!) {
        println("camera button pressed - finish this function")
    }
    
    
    
    func receivedNewMessage(){
        
        println("chatVC received new message")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            if let newMessage = DataSource.sharedInstance.receivedMessages[self.peerID!]{
//                for index in 0...newMessage.count-1 {
//                    let message = newMessage[index] as JSQMessage
//                    
//                    
//                    println("chatVC message is \(message.text)")
//                    self.chatData!.append(message)
//                    
//                    
//                    println("need to refresh the fucking controller")
            self.loadChatData()

            self.finishReceivingMessage()
//                }
//                
//                DataSource.sharedInstance.receivedMessages[self.peerID!] = []
//            }
        })
        
        
        
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
//        
//        if let tempPeerID = self.peerID {
//            DataSource.sharedInstance.allMessages[self.peerID!] = self.chatData
//        }
        
    }
    
    
    
   
}
