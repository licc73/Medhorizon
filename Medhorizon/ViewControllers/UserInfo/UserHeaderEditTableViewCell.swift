//
//  UserHeaderEditTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/17/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
let userHeaderEditTableViewCellId = "UserHeaderEditTableViewCell"

class UserHeaderEditTableViewCell: UITableViewCell {

    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var imgvHeadPic: UIImageView!

    func setTitle(title: String?, imgUrl: String?) {
        self.labTitle.text = title
        if let pic = imgUrl, picUrl = NSURL(string: pic) {
            self.imgvHeadPic.sd_setImageWithURL(picUrl, placeholderImage: UIImage(named: "default_header"))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgvHeadPic.layer.cornerRadius = 25
        self.imgvHeadPic.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labTitle.text = nil
        self.imgvHeadPic.image = nil
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
