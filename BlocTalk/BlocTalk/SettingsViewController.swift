//
//  SettingsViewController.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 25/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

// Using this to manage the settings view

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var discoverableSwitch: UISwitch!
    @IBOutlet var displaySettingsView: UIView!
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve saved settings.
        DataSource.sharedInstance.retrieveUserSettings()
        discoverableSwitch.on = DataSource.sharedInstance.discoverable
        displaySettingsView.hidden = !discoverableSwitch.on
        displayNameTextField.text = DataSource.sharedInstance.displayName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // save settings
        DataSource.sharedInstance.discoverable = discoverableSwitch.on
        
        if displayNameTextField.text != nil {
            DataSource.sharedInstance.displayName = displayNameTextField.text!
        }
        
        DataSource.sharedInstance.saveUserSettings()
        
    }
    
    
    
    
    
    @IBAction func discoverableSwitchChanged(sender: UISwitch) {
        displaySettingsView.hidden = !discoverableSwitch.on
        DataSource.sharedInstance.changeDiscoverability(sender.on)
    }
    

}
