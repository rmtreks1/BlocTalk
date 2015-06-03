//
//  PeersTableViewCell.swift
//  BlocTalk
//
//  Created by Roshan Mahanama on 3/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class PeersTableViewCell: UITableViewCell {
    
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var peerDisplayNameLabel: UILabel!
    @IBOutlet var peerStatusLabel: UILabel!
    
    @IBOutlet var masterViewForProgressView: UIView!
    @IBOutlet var progressView: UIProgressView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
