//
//  WorldDetailTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/14/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class WorldDetailTableViewCell: UITableViewCell {
    let placeHolderImage = UIImage(named: "")

    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labCount: UILabel!
    @IBOutlet weak var labCreatedDate: UILabel!

    var document: CoursewareInfoViewModel? {
        didSet {
            if let doc = document {
                self.labTitle.text = doc.title
                self.labCount.text = String(format: "%d", doc.readNum ?? 0)
                self.labCreatedDate.text = doc.createdDate
                if let pic = doc.picUrl, picUrl = NSURL(string: pic) {
                    self.imgvThumbnail.sd_setImageWithURL(picUrl, placeholderImage: placeHolderImage)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labTitle.text = nil
        self.labCount.text = nil
        self.labCreatedDate.text = nil
        self.imgvThumbnail.image = placeHolderImage
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
