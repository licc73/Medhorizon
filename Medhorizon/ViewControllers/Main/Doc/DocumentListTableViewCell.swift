//
//  DocumentListTableViewCell.swift
//  Medhorizon
//
//  Created by lich on 10/12/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

protocol DocumentListTableViewCellDelegate: class {
    func documentListTableViewCellViewDocument(cell: UITableViewCell)
    func documentListTableViewCellDownloadDocument(cell: UITableViewCell)
}

class DocumentListTableViewCell: UITableViewCell {
    let placeHolderImage = UIImage(named: "default_image_small")
    
    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labContent: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    
    weak var delegate: DocumentListTableViewCellDelegate?
    
    var document: CoursewareInfoViewModel? {
        didSet {
            if let doc = document {
                self.labTitle.text = doc.title
                self.labContent.text = doc.keyWordInfo
                if let pic = doc.picUrl, picUrl = NSURL(string: pic) {
                    self.imgvThumbnail.sd_setImageWithURL(picUrl, placeholderImage: placeHolderImage)
                }
                
                if DownloadManager.shareInstance.isSuccessDownloaded(doc.sourceUrl) {
                    self.btnView.setTitle("全文", forState: .Normal)
                    self.btnDownload.hidden = false
                }
                else {
                    self.btnView.setTitle("摘要", forState: .Normal)
                    self.btnDownload.hidden = true
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
        //self.btnDownload.setTitle("下载全文", forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DocumentListTableViewCell {

    @IBAction func downloadDocument(sender: AnyObject) {
        self.delegate?.documentListTableViewCellDownloadDocument(self)
    }
    
    @IBAction func viewDocument(sender: AnyObject) {
        self.delegate?.documentListTableViewCellViewDocument(self)
    }
    
}
