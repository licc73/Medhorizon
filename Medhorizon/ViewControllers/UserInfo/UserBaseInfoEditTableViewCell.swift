//
//  UserBaseInfoEditTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/17/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

let userBaseInfoEditTableViewCellId = "UserBaseInfoEditTableViewCell"
class UserBaseInfoEditTableViewCell: UITableViewCell {

    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labValue: UILabel!

    func setTitle(title: String?, value: String?) {
        self.labTitle.text = title
        self.labValue.text = value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labTitle.text = nil
        self.labValue.text = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
