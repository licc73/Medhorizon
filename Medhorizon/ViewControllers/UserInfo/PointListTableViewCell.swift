//
//  PointListTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class PointListTableViewCell: UITableViewCell {
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labPoint: UILabel!
    @IBOutlet weak var labDate: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labDate.text = nil
        self.labPoint.text = nil
        self.labTitle.text = nil
    }

    var point: PointViewModel? {
        didSet {
            if let pt = point {
                self.labPoint.text = pt.scoreNum
                self.labDate.text = pt.date
                if let title = pt.title where title != "" {
                    self.labTitle.text = "\(pt.pointType.commentString)(\(title))"
                }
                else {
                    self.labTitle.text = pt.pointType.commentString
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
