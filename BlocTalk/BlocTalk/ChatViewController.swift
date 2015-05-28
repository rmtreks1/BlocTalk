//
//  ChatViewController.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 27/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController {
    
    var demoData: [JSQMessage]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // must set up SenderID and SenderDisplayName
        self.senderId = "rmtreks"
        self.senderDisplayName = "roshan m"
        
        demoData = TestData.sharedInstance.messages

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
    
    
    
    // MARK: - JSQMessagesCollectionViewDataSource Protocol
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let message = self.demoData![indexPath.item]
        
        return message
    }
    

    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = self.demoData![indexPath.item]
        
        if message.senderId == self.senderId {
            return TestData.sharedInstance.outgoingBubbleImageData
        }
        
        return TestData.sharedInstance.incomingBubbleImageData
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return TestData.sharedInstance.placeholderAvatar
    }
    
    
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("number of messages are: \(self.demoData!.count)")
        return self.demoData!.count
    }
    
    
    
//  
//    
//    - (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//    {
//    /**
//    *  Override point for customizing cells
//    */
//    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
//    
//    /**
//    *  Configure almost *anything* on the cell
//    *
//    *  Text colors, label text, label colors, etc.
//    *
//    *
//    *  DO NOT set `cell.textView.font` !
//    *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
//    *
//    *
//    *  DO NOT manipulate cell layout information!
//    *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
//    */
//    
//    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
//    
//    if (!msg.isMediaMessage) {
//    
//    if ([msg.senderId isEqualToString:self.senderId]) {
//    cell.textView.textColor = [UIColor blackColor];
//    }
//    else {
//    cell.textView.textColor = [UIColor whiteColor];
//    }
//    
//    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
//    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
//    }
//    
//    return cell;
//    }
//    
//    
//    
//    
//    
//    
//    
//    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
}
