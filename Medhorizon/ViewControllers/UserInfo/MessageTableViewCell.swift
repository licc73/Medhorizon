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
                self.labTitle.text = message.sendName
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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
