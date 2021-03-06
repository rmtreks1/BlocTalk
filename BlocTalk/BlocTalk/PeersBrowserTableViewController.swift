//
//  PeersBrowserTableViewController.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 26/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class PeersBrowserTableViewController: UITableViewController, MPCManagerDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        MPCManager.sharedInstance.delegate = self
        
        // Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePeersTable", name: MPCManager.sharedInstance.notificationKey, object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return DataSource.sharedInstance.availablePeers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PeersTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PeersTableViewCell

        // Configure the cell...
        let peer = DataSource.sharedInstance.availablePeers[indexPath.row] as MCPeerID
        cell.peerDisplayNameLabel.text = peer.displayName
        
        
        let userStatusString = DataSource.sharedInstance.allPeers[peer]!
        switch userStatusString {
        case .Online:
            cell.peerStatusLabel.text = "Online"
            
        case .Offline:
            cell.peerStatusLabel.text = "Offline"
            
        default:
            cell.peerStatusLabel.text = "Unknown"
        }
        
        cell.masterViewForProgressView.hidden = true
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let peer = DataSource.sharedInstance.availablePeers[indexPath.row] as MCPeerID
        MPCManager.sharedInstance.invitePeer(peer)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - MPCManager Delegate
    func didReceiveInvitationFromPeer (peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!) {
       
                let alert = UIAlertController(title: "", message: "\(peerID.displayName) wants to chat.", preferredStyle: UIAlertControllerStyle.Alert)
        
                let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    invitationHandler(true, MPCManager.sharedInstance.session)
                }
        
                let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
                    invitationHandler(false, nil)
                }
        
                alert.addAction(acceptAction)
                alert.addAction(declineAction)
        
                NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                }
    }
    
    
    func didReceiveMessage() {
        
    }
    
    
    
    
    func updatePeersTable(){
        
        println(DataSource.sharedInstance.availablePeers)
        self.tableView.reloadData()
    }
    
    
    func didConnectToPeer(peerID: MCPeerID) {
        println("connected to peer")
        
        // create a test conversation
//        TestData.sharedInstance.createDemoData(peerID)
        var messages = [JSQMessage]()
        DataSource.sharedInstance.allMessages[peerID] = messages
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    
    
    /*
    @IBAction func lookForDuplicates(sender: UIBarButtonItem) {
        
        let uniqueAvailablePeers = uniq(DataSource.sharedInstance.availablePeers)
        println("count of unique peers: \(uniqueAvailablePeers.count) out of total available peers: \(DataSource.sharedInstance.availablePeers.count)")
        
    }

    
    func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    */
    
}
