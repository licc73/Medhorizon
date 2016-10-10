//
//  NewsListTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/10/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import WebImage

class NewsListTableViewCell: UITableViewCell {
    let placeHolderImage = UIImage(named: "")

    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labContent: UILabel!
    @IBOutlet weak var labCreatedDate: UILabel!

    var news: NewsViewModel? {
        didSet {
            if let news = news {
                self.labTitle.text = news.title
                self.labContent.text = news.keyWordInfo
                self.labCreatedDate.text = news.createdDate

                if let pic = news.picUrl, picUrl = NSURL(string: pic) {
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
        self.labContent.text = nil
        self.labCreatedDate.text = nil
        self.imgvThumbnail.image = placeHolderImage
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
