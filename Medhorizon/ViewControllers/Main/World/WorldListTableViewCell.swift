//
//  WorldListTableViewCell.swift
//  Medhorizon
//
//  Created by lich on 10/13/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class WorldListTableViewCell: UITableViewCell {

    let placeHolderImage = UIImage(named: "default_image_small")
    
    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labContent: UILabel!
    
    var expert: ExpertListViewModel? {
        didSet {
            if let expert = expert {
                self.labTitle.text = expert.jobName
                self.labContent.text = expert.keyWordInfo
                                
                if let pic = expert.picUrl, picUrl = NSURL(string: pic) {
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
        self.imgvThumbnail.image = placeHolderImage
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
