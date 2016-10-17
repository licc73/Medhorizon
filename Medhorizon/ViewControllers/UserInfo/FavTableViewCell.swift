//
//  FavTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {
    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labFavCount: UILabel!
    @IBOutlet weak var labReadCount: UILabel!

    var fav: FavViewModel? {
        didSet {
            if let fav = fav {
                self.labTitle.text = fav.title
                let favCount = fav.favNum ?? 0
                let readNum = fav.readNum ?? 0
                self.labFavCount.text = "收藏量 \(favCount)"
                self.labReadCount.text = "浏览量 \(readNum)"

                if let pic = fav.picUrl, picUrl = NSURL(string: pic) {
                    self.imgvThumbnail.sd_setImageWithURL(picUrl, placeholderImage: UIImage(named: "default_image_small"))
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
