//
//  MeetingListTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class MeetingListTableViewCell: UITableViewCell {
    let placeHolderImage = UIImage(named: "default_image_small")

    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labContent: UILabel!
    @IBOutlet weak var labCreatedDate: UILabel!

    var meeting: MeetingViewModel? {
        didSet {
            if let meeting = meeting {
                self.labTitle.text = meeting.title
                self.labContent.text = meeting.keyWordInfo
                self.labCreatedDate.text = meeting.createdDate

                if let pic = meeting.picUrl, picUrl = NSURL(string: pic) {
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
