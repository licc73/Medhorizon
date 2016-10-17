//
//  UserTableHeaderTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/17/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
let userTableHeaderTableViewCellId = "UserTableHeaderTableViewCell"

class UserTableHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var imgvIcon: UIImageView!

    func setTitle(title: String?, icon: String) {
        self.labTitle.text = title
        self.imgvIcon.image = UIImage(named: icon)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labTitle.text = nil
        self.imgvIcon.image = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
