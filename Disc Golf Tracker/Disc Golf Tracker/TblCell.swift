//
//  TblCell.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 3/29/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

class TblCell: UITableViewCell {

    @IBOutlet var lblHoleNumber: UILabel!
    @IBOutlet var lblTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
