//
//  DownloadTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/17/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class DownloadTableViewCell: UITableViewCell {

    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labStatus: UILabel!
    @IBOutlet weak var imgvCompleteIcon: UIImageView!
    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var progress: UIProgressView!

    var downLoad: DownloadItem? {
        didSet {
            self.updateCellStatus(downLoad)
        }

    }

    func updateCellStatus(downLoad: DownloadItem?) {
        if let item = downLoad {
            if let picUrl = NSURL(string: item.picUrl) {
                self.imgvThumbnail.sd_setImageWithURL(picUrl, placeholderImage: UIImage(named: "default_image_small"))
            }
            self.labTitle.text = item.title
            switch item.status {
            case .Finish:
                self.imgvCompleteIcon.hidden = false
                self.labStatus.hidden = true
                self.progress.hidden = true
            case .Downloading:
                self.imgvCompleteIcon.hidden = true
                self.labStatus.hidden = true
                self.progress.hidden = false
                self.progress.progress = Float(item.progress)
            case .Fail:
                self.imgvCompleteIcon.hidden = true
                self.labStatus.hidden = false
                self.labStatus.text = "下载失败"
                self.progress.hidden = true
            case .Wait:
                self.imgvCompleteIcon.hidden = true
                self.labStatus.hidden = false
                self.labStatus.text = "等待中..."
                self.progress.hidden = true

            default:
                break
            }
        }
    }


    func setupBind() {
        DownloadManager.shareInstance.downloadHotSignal.producer
        .throttle(2, onScheduler: RACScheduler.mainThreadScheduler())
        .takeUntil(self.rac_WillDeallocSignalProducer())
            .takeUntil(self.rac_prepareForReuseSignal.toSignalProducer()
                .flatMapError { _ in SignalProducer<AnyObject?, NoError>.empty}
                .map {_ in ()})
        .startWithNext { [unowned self](item) in
            if let sItem = item, selfItem = self.downLoad where sItem.sourceUrl == selfItem.sourceUrl {
                self.updateCellStatus(sItem)
            }
        }
        

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupBind()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labTitle.text = nil
        self.labStatus.hidden = true
        self.progress.progress = 0
        self.progress.hidden = true
        self.imgvCompleteIcon.hidden = true
        self.imgvThumbnail.image = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

     override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        otherGestureRecognizer.requireGestureRecognizerToFail(gestureRecognizer)
        return true
    }
//    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        return true
//    }
//
//    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }

}
