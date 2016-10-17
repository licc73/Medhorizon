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

    var coverFlow: CoverFlowView?

    var vAction: ActionView?
    var isFav: Bool = false {
        didSet {
            self.vAction?.setFav(isFav)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.setPlayer()
        self.setCoverFlowAndToolBar()
        self.requestVideoInfo()
        self.getFavStatus()
        self.setupBind()
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

        player.shouldAutoplay = false


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

    func setCoverFlowAndToolBar() {
        self.coverFlow = CoverFlowView(frame: CGRectMake(0, 0, AppInfo.screenWidth, AppInfo.screenHeight - defaultFrame.size.height - 64 - 44))
        self.coverFlow?.delegate = self
        self.coverFlow?.enableAutoScrollTimer = false
        self.coverFlow?.pageCtrl.hidden = true
        if let cover = self.coverFlow {
            self.vCover.addSubview(cover)
            self.vCover.sendSubviewToBack(cover)
        }

        self.vTool.backgroundColor = UIColor.colorWithHex(0xf5f6f7)
        self.vAction = ActionView(frame: CGRectZero)
        self.vAction?.config([.Comment, .Fav, .Download])
        self.vAction?.delegate = self
        self.vTool.addSubview(self.vAction!)
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

        if DownloadManager.shareInstance.isSuccessDownloaded(curVidoeId) {

        }
        else {
            self.playNetworkUrl()
        }
        self.vAction?.setFav(self.isFav)
        self.coverFlow?.reloadData()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let player = self.playerCtrl {
            if player.isPreparedToPlay {
                player.pause()
            }

//            player.cancelRequestPlayInfo()
//            player.currentPlaybackTime = player.duration
//            player.contentURL = nil
//            player.stop()
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setupBind() {
        NSNotificationCenter.defaultCenter()
            .rac_notifications(loginStatusChangeNotification, object: nil)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self] (_) in
                self.getFavStatus()
            }.start()

        NSNotificationCenter.defaultCenter()
            .rac_notifications(MPMoviePlayerLoadStateDidChangeNotification, object: nil)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self] (notification) in
                if let status = self.playerCtrl?.loadState {
                    if status.contains(MPMovieLoadState.Playable) || status.contains(MPMovieLoadState.PlaythroughOK) {
                        if SetupValueManager.shareInstance.isPlayInWifiOnly {
                            if let value = SetupValueManager.shareInstance.network?.isReachableOnEthernetOrWiFi where value {
                                if !SetupValueManager.shareInstance.isPlayWhenOpen {
                                    self.playerCtrl?.pause()
                                }
                            }
                            else {
                                self.playerCtrl?.pause()
                            }
                        }
                        else if !SetupValueManager.shareInstance.isPlayWhenOpen {
                            self.playerCtrl?.pause()
                        }
                    }
                }

            }.start()
    }

    func getFavStatus() {
        guard let userId = LoginManager.shareInstance.userId, infoId = self.videoDocument?.id else {
            return
        }
        performGetFavStatus(userId, InfoId: infoId)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self] (data) in
                self.isFav = data.1
            }.start()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowCommentList.rawValue {
            if let destination = segue.destinationViewController as? CommentViewController {
                destination.title = "专家问答"
                destination.id = self.videoDocument?.id
            }
        }
    }


    deinit {
        self.playerCtrl?.delegate = nil
        self.playerCtrl?.view.removeFromSuperview()
        self.playerCtrl = nil
    }
}

extension VideoDetailViewController: ActionViewDelegate {

    func actionViewShouldBeginAddComment(view view: ActionView) -> Bool {
        if LoginManager.shareInstance.isLogin {
            return true
        }
        else {
            LoginManager.loginOrEnterUserInfo()
            return false
        }
    }

    func actionView(view view: ActionView, willSend comment: String) -> Bool {
        if LoginManager.shareInstance.isLogin {
            guard let infoId = self.videoDocument?.id,
                userId = LoginManager.shareInstance.userId else {
                    LoginManager.loginOrEnterUserInfo()
                    return false
            }

            performAddComment(userId, infoId: infoId, comment: comment)
                .takeUntil(self.rac_WillDeallocSignalProducer())
                .observeOn(UIScheduler())
                .on(failed: {(error) in
                    AppInfo.showDefaultNetworkErrorToast()
                    },
                    next: { (returnMsg) in
                        if let msg = returnMsg {
                            if msg.isSuccess {
                                AppInfo.showToast("你已成功提问")
                            }
                            else {
                                AppInfo.showToast(msg.errorMsg)
                            }
                        }
                        else {
                            AppInfo.showToast("未知错误")
                        }
                })
                .start()
            return true
        }
        else {
            LoginManager.loginOrEnterUserInfo()
            return false
        }
    }

    func actionView(view view: ActionView, didSelectAction type: ActionType) {
        switch type {
        case .Comment:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowCommentList.rawValue, sender: nil)
        case .Fav:
            if LoginManager.shareInstance.isLogin {
                guard let userId = LoginManager.shareInstance.userId, infoId = self.videoDocument?.id else {
                    return
                }
                performFavOrCancel(userId, InfoId: infoId, type: isFav ? .CancelFav : .Fav)
                    .takeUntil(self.rac_WillDeallocSignalProducer())
                    .observeOn(UIScheduler())
                    .on (failed: {(error) in
                        AppInfo.showDefaultNetworkErrorToast()
                        })
                    { [unowned self] (msg) in
                        if let msg = msg where msg.isSuccess {
                            self.isFav = !self.isFav
                            if self.isFav {
                                AppInfo.showToast("收藏成功")
                            }
                            else {
                                AppInfo.showToast("取消收藏成功")
                            }
                        }
                        else {
                            AppInfo.showToast("操作失败")
                        }
                    }.start()
            }
            else {
                LoginManager.loginOrEnterUserInfo()
            }
        case .Download:
            self.checkDownload()
        default:
            break
        }
    }

    func checkDownload() {
        if LoginManager.shareInstance.isLogin {
            if let userId = LoginManager.shareInstance.userId, videoId = self.videoId {
                let item = DownloadItem(sourceUrl: videoId, fileType: .Video, picUrl: self.videoDocument?.picUrl ?? "", status: .Wait, title: self.videoDocument?.title ?? "", progress: 0, userId: userId, downloadItem: nil)
                DownloadManager.shareInstance.addDownloadItem(item)
            }
        }
        else {
            LoginManager.loginOrEnterUserInfo()
        }
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

extension VideoDetailViewController: CoverFlowViewDelegate {

    func coverFlowView(view: CoverFlowView, didSelect index: Int) {

    }

    func numberOfCoversInCoverFlowView(view: CoverFlowView) -> Int {
        return self.videoDetail?.picList.count ?? 0
    }

    func coverImage(view: CoverFlowView, atIndex index: Int) -> String? {
        return self.videoDetail?.picList[index]
    }
    
}

extension VideoDetailViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func preCover(sender: AnyObject) {
        guard let cover = self.coverFlow else {
            return
        }

        if cover.iCurrentPage == 0 {
            AppInfo.showToast("当前已经是第一张")
        }
        else {
            cover.scrollToPage(cover.iCurrentPage - 1)
        }
    }

    @IBAction func nextCover(sender: AnyObject) {
        guard let cover = self.coverFlow else {
            return
        }

        if cover.iCurrentPage >= cover.iTotalCount - 1 {
            AppInfo.showToast("当前已经是最后一张")
        }
        else {
            cover.scrollToPage(cover.iCurrentPage + 1)
        }
    }

}
