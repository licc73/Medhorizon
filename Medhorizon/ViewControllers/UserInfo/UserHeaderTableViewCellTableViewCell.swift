//
//  UserHeaderTableViewCellTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class UserHeaderTableViewCellTableViewCell: UITableViewCell {
    @IBOutlet weak var imgvHeader: UIImageView!
    @IBOutlet weak var labNickName: UILabel!
    @IBOutlet weak var labLogInDay: UILabel!

    func setHeadPic(picUrl: String?, nickName: String?, day: Int?) {
        if let pic = picUrl, picUrl = NSURL(string: pic) {
            self.imgvHeader.sd_setImageWithURL(picUrl, placeholderImage: UIImage(named: "default_header"))
        }
        self.labNickName.text = nickName

        let realDay: Int = day ?? 0

        let formatString = "太棒了已连续登录%1$@天"
        let dayAttr = NSAttributedString(string: "\(realDay)", attributes: [NSForegroundColorAttributeName: UIColor.colorWithHex(0x2892cb)])

        labLogInDay.attributedText = NSAttributedString(attributes: [NSForegroundColorAttributeName : UIColor.colorWithHex(0x666666), NSFontAttributeName: UIFont.systemFontOfSize(18)], format: formatString, dayAttr)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgvHeader.layer.cornerRadius = 50
        self.imgvHeader.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
