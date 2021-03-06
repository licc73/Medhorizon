//
//  CommentTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/14/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    let placeHolderImage = UIImage(named: "default_image_squar")

    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labContent: UILabel!
    @IBOutlet weak var labCreatedDate: UILabel!

    var comment: CommentBaseViewModel? {
        didSet {
            if let comment = comment {
                self.labName.text = comment.commentName
                //self.labContent.text = comment.commentContent
                self.labCreatedDate.text = comment.commentDate

                let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: comment.commentContent ?? "")
                let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 7 //大小调整
                attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

                 self.labContent.attributedText = attributedString

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
