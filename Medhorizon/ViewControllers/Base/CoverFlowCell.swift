//
//  CoverFlowCell.swift
//  Medhorizon
//
//  Created by lich on 10/10/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import WebImage

class CoverFlowCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    let placeHolderImage = UIImage(named: "default_image_big")
    
    var image: String? {
        didSet {
            if let image = image {
                if image.hasPrefix("http") || image.hasPrefix("https") {
                    if let url = NSURL(string: image) {
                        self.coverImage.sd_setImageWithURL(url, placeholderImage: placeHolderImage)
                    }
                }
                else {
                    self.coverImage.image = UIImage(named: image)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coverImage.image = placeHolderImage
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
