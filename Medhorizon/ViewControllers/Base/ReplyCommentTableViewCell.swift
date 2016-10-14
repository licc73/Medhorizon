//
//  ReplyCommentTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/14/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: UITableViewCell {
    let placeHolderImage = UIImage(named: "")

    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labContent: UILabel!
    @IBOutlet weak var labCreatedDate: UILabel!

    var comment: CommentBaseViewModel? {
        didSet {
            if let comment = comment {
                self.labName.text = comment.commentName
                self.labContent.text = comment.commentContent
                self.labCreatedDate.text = comment.commentDate

                if let pic = comment.commentPic, picUrl = NSURL(string: pic) {
                    self.imgvThumbnail.sd_setImageWithURL(picUrl, placeholderImage: placeHolderImage)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgvThumbnail.layer.cornerRadius = 10
        self.imgvThumbnail.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labName.text = nil
        self.labContent.text = nil
        self.labCreatedDate.text = nil
        self.imgvThumbnail.image = placeHolderImage
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
