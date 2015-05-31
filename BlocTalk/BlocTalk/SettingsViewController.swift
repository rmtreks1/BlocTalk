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

    //MARK: - Properties
    @IBOutlet var discoverableSwitch: UISwitch!
    @IBOutlet var displaySettingsView: UIView!
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var profileImage: UIImageView!
    
    
    // for creating fake peer - delete later
    @IBOutlet var fakePeer: UITextField!
    
    //MARK: - Overrides
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
    

    
    //MARK: - Actions
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // save settings
//        DataSource.sharedInstance.discoverable = discoverableSwitch.on
        
        if displayNameTextField.text != nil {
            DataSource.sharedInstance.displayName = displayNameTextField.text!
        }
        

        
    }
    
    @IBAction func discoverableSwitchChanged(sender: UISwitch) {
        displaySettingsView.hidden = !discoverableSwitch.on
        DataSource.sharedInstance.changeDiscoverability(sender.on)
    }
    
    
    @IBAction func createFakeData(sender: UIButton) {
//        TestData.sharedInstance.createDemoData(self.fakePeer.text)
    }
    
    
    

}
