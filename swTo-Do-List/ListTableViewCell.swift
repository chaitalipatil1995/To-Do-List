//
//  ListTableViewCell.swift
//  swTo-Do-List
//
//  Created by Amesten Systems on 24/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    weak var cellDelegate: cellDelegateProtocol?
   // var tag: Int = 0
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var editButton: UIButton!
    
    @IBAction func editButtonAction(_ sender: AnyObject) {
        
        cellDelegate?.didPressButton(sender.tag)

        
    }
    @IBOutlet var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
