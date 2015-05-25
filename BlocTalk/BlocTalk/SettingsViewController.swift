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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discoverableSwitch.on = DataSource.sharedInstance.discoverable
        displaySettingsView.hidden = !discoverableSwitch.on
        displayNameTextField.placeholder = DataSource.sharedInstance.displayName

        // Do any additional setup after loading the view.
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
    
    
    @IBAction func discoverableSwitchChanged(sender: UISwitch) {
        displaySettingsView.hidden = !discoverableSwitch.on
        DataSource.sharedInstance.discoverable = sender.on
    }
    

}
