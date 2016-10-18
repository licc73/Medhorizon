//
//  MessageTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
let messageTableViewCellId = "MessageTableViewCell"
class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var labCreatedDate: UILabel!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labContent: UILabel!

    var myMessage: MyMessageViewModel? {
        didSet {
            if let message = myMessage {
                let name = message.sendName ?? ""
                let format = "\(name)：%1$@"
                //let formatAttr = NSAttributedString(string: "\(pointDesc)", attributes: [NSForegroundColorAttributeName: UIColor.colorWithHex(0x999999), NSFontAttributeName: UIFont.systemFontOfSize(12)])
                let attr = NSAttributedString(string: "回复你：", attributes: [NSForegroundColorAttributeName: UIColor.colorWithHex(0x666666), NSFontAttributeName: UIFont.systemFontOfSize(15)])

                self.labTitle.attributedText = NSAttributedString(attributes: [NSForegroundColorAttributeName : UIColor.colorWithHex(0x2892cb),  NSFontAttributeName: UIFont.systemFontOfSize(15)], format: format, attr)
                self.labCreatedDate.text = message.createdDate
                self.labContent.text = message.content
            }
        }
    }

    var sysMessage: SysMessageViewModel? {
        didSet {
            if let message = sysMessage {
                self.labTitle.text = message.title
                self.labCreatedDate.text = message.createdDate
                self.labContent.text = message.content
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labTitle.text = nil
        self.labContent.text = nil
        self.labCreatedDate.text = nil
        self.labTitle.attributedText = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
