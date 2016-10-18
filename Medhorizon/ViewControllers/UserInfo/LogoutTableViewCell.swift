//
//  LogoutTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/18/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
let logoutTableViewCellId = "LogoutTableViewCell"
class LogoutTableViewCell: UITableViewCell {
    @IBOutlet weak var bntButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
