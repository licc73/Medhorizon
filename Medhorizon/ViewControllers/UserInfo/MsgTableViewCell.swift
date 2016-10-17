//
//  MsgTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class MsgTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgvIcon: UIImageView!
    @IBOutlet weak var labTitle: UILabel!

    func setIcon(image: String, title: String, textColor: UIColor?) {
        self.imgvIcon.image = UIImage(named: image)
        self.labTitle.text = title
        if let textColor = textColor {
            self.labTitle.textColor = textColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgvIcon.image = nil
        self.labTitle.text = nil
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
