//
//  VideoDetailViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/15/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class VideoDetailViewController: UIViewController {
    @IBOutlet weak var vPlayer: UIView!
    @IBOutlet weak var vCover: UIView!
    @IBOutlet weak var vTool: UIView!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var bntNext: UIButton!

    var videoDocument: CoursewareInfoViewModel?
    var videoDetail: VideoDetailInfoViewModel?

    var playerCtrl: ALMoviePlayerController?
    let defaultFrame: CGRect = CGRectMake(0, 0, AppInfo.screenWidth, AppInfo.screenWidth * 9.0 / 16.0)
    var videoId: String?
    var playUrls: [String: AnyObject] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.setPlayer()
        self.requestVideoInfo()
    }

    func setPlayer() {
        self.playerCtrl = ALMoviePlayerController.init(frame: defaultFrame)
        guard let player = self.playerCtrl else {
            return
        }

        //player.view.alpha = 0.0
        player.delegate = self; //IMPORTANT!

        //create the controls
        let movieControls = ALMoviePlayerControls(moviePlayer: player, style: ALMoviePlayerControlsStyleDefault)
        movieControls.barColor = UIColor.blackColor()
        movieControls.timeRemainingDecrements = true

        //assign controls
        player.controls = movieControls
        self.vPlayer.addSubview(player.view)



        //        //THEN set contentURL
        //        [self resetCurViewDisplay];
        //        //delay initial load so statusBarOrientati
        //        double delayInSeconds = 0.3;
        //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //            [self configureViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        //            [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        //                self.playerCtrl.view.alpha = 1.f;
        //                } completion:^(BOOL finished) {
        //                self.navigationItem.leftBarButtonItem.enabled = YES;
        //                self.navigationItem.rightBarButtonItem.enabled = YES;
        //                }];
        //            });

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func requestVideoInfo() {
        guard let infoId = self.videoDocument?.id else {
            return
        }
        DefaultServiceRequests.rac_requesForVideoCoursewareInfo(infoId, userId: LoginManager.shareInstance.userId)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(failed: { (error) in
                AppInfo.showDefaultNetworkErrorToast()

                },
                next: {[unowned self] (data) in
                    let returnMsg = ReturnMsg.mapToModel(data)

                    if let msg = returnMsg {
                        if msg.isSuccess {
                            self.videoDetail = VideoDetailInfoViewModel.mapToModel(data)
                            self.videoId = self.videoDetail?.videoId
                            self.reloadData()
                        }
                        else {
                            AppInfo.showToast(returnMsg?.errorMsg)
                        }
                    }
                    else {
                        AppInfo.showToast("未知错误")
                    }
                })
            .start()
    }

    func reloadData() {
        guard let curVidoeId = self.videoId else {
            return
        }

        if DownloadManager.shareInstance.isVideoDownloaded(curVidoeId) {

        }
        else {
            self.playNetworkUrl()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let player = self.playerCtrl {
            player.cancelRequestPlayInfo()
            player.currentPlaybackTime = player.duration
            player.contentURL = nil
            player.stop()
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        self.playerCtrl?.delegate = nil
        self.playerCtrl?.view.removeFromSuperview()
        self.playerCtrl = nil
    }
}

extension VideoDetailViewController: ALMoviePlayerControllerDelegate {

    func movieTimedOut() {

    }

    func moviePlayerWillMoveFromWindow() {
        //movie player must be readded to this view upon exiting fullscreen mode.
        guard let player = self.playerCtrl else {
            return
        }

        if !self.view.subviews.contains(player.view) {
            self.vPlayer.addSubview(player.view)
        }

        //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
        player.setFrame(defaultFrame)
    }

    func playLocalUrl(localPath: String) {
        self.playUrls = ["playurl" : localPath]
        self.playerCtrl?.contentURL = NSURL(fileURLWithPath: localPath)
        self.playerCtrl?.prepareToPlay()
        self.playerCtrl?.play()
    }

    func playNetworkUrl() {
        guard let videoId = self.videoId, player = self.playerCtrl else {
            AppInfo.showToast("未找到视频")
            return
        }

        player.videoId = videoId
        player.timeoutSeconds = 30

        player.failBlock = { _ in
            AppInfo.showToast("视频无法播放")
        }

        player.getPlayUrlsBlock = { [unowned self]url in
            if let status = url["status"] as? NSNumber {
                if status.intValue == 0 {

                }
                else {
                    AppInfo.showToast("视频无法播放, 可能正处于转码、审核等状态")
                }
            }
            else {
                AppInfo.showToast("视频无法播放, 可能正处于转码、审核等状态")
            }
            if let url = url as? [String: AnyObject] {
                self.playUrls = url
            }
        }

        player.startRequestPlayInfo()
    }

}

extension VideoDetailViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func preCover(sender: AnyObject) {

    }

    @IBAction func nextCover(sender: AnyObject) {

    }

}
