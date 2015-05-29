//
//  ChatsTableViewController.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 25/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatsTableViewController: UITableViewController, DataSourceDelegate {
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataSource.sharedInstance.delegate = self
        
  
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        DataSource.sharedInstance.allMessagesPeers = []
        for (peerID, messages) in DataSource.sharedInstance.allMessages {
            DataSource.sharedInstance.allMessagesPeers.append(peerID)
        }
        
        
        
        self.tableView.reloadData()
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
        
        println("Data source allMessages has \(DataSource.sharedInstance.allMessages.count)")
        println("Data source allMessagesPeers has \(DataSource.sharedInstance.allMessagesPeers.count)")
        
        return DataSource.sharedInstance.allMessagesPeers.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> AllConversationsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AllConversationsTableViewCell

        
        // Configure the cell... Move this to separate TableViewCell & this is incomplete
        let peerID = DataSource.sharedInstance.allMessagesPeers[indexPath.row]
        let conversation = DataSource.sharedInstance.allMessages[peerID]
        let conversationText = conversation?.first?.text
        
        cell.conversationLabel.text = conversationText!
        
        return cell
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
    
    // hook up the + button to this to present the built in MPC Browser View Controller
    @IBAction func newConversation(sender: UIBarButtonItem) {
//        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    

    
    //MARK: - DataSource Delegate
    func userStatusChange (user: User, index: Int) {
        self.tableView.reloadData()
    }
    
    
    func changeInUserConnections(){
        self.tableView.reloadData()
        println("refreshing table view")
        
        let countOfUsers = DataSource.sharedInstance.allUsers.count
        println("total users: \(countOfUsers)")
    }

    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChatWithPeer"{
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)
            let peer = DataSource.sharedInstance.allMessagesPeers[indexPath!.row]
            println("chatting with peer \(peer)")
            
        }
    }
    
    
    
}
