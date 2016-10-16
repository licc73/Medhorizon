//
//  SeparatorLineTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class SeparatorLineTableViewCell: UITableViewCell {
    @IBOutlet weak var imgvLine: UIImageView!
    @IBOutlet weak var leftConstaint: NSLayoutConstraint!
    @IBOutlet weak var rightConstaint: NSLayoutConstraint!

    func setLineColor(color: UIColor? = nil, insets: UIEdgeInsets? = nil) {
        if let color = color {
            self.imgvLine.backgroundColor = color
        }
        else {
            self.imgvLine.backgroundColor = UIColor.lightGrayColor()
        }

        if let insets = insets {
            self.leftConstaint.constant = insets.left
            self.rightConstaint.constant = insets.right
        }
        else {
            self.leftConstaint.constant = 0
            self.rightConstaint.constant = 0
        }
        
    }

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
