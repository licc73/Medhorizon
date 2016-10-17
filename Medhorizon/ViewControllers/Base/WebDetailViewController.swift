//
//  WebDetailViewController.swift
//  Medhorizon
//
//  Created by lich on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class WebDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    @IBOutlet weak var vTool: UIView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var toolHeight: NSLayoutConstraint!

    var showDownloadToolBar: Bool = false
    var showActionToolBar: Bool = false
    var actions: [ActionType] = [.Comment, .Fav, .Share, .Download]
    var vAction: ActionView?
    
    var newsData: NewsViewModel?
    var brannerData: BrannerViewModel?
    var document: CoursewareInfoViewModel?
    var favData: FavViewModel?    
    
    var sTitle: String?
    var sContent: String?
    var sLink: String?
    var sPic: String?
    var id: String?

    var isFav = false {
        didSet {
            self.vAction?.setFav(isFav)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.extractData()
        self.setToolBar()

        self.setupBind()
        self.getFavStatus()
    }

    func setToolBar() {
        if showActionToolBar {
            self.btnDownload.hidden = true
            self.vTool.backgroundColor = UIColor.colorWithHex(0xf5f6f7)
            self.vAction = ActionView(frame: CGRectZero)
            self.vAction?.config(actions)
            self.vAction?.delegate = self
            self.vAction?.setFav(self.isFav)
            self.vTool.addSubview(self.vAction!)
        }
        else if showDownloadToolBar {

        }
        else {
            self.vTool.hidden = true
            self.toolHeight.constant = 0
        }
    }
    
    func extractData() {
        if let newsData = newsData {
            sTitle = newsData.title
            sContent = newsData.keyWordInfo
            sLink = newsData.linkUrl
            sPic = newsData.picUrl
            self.id = newsData.id
        }
        else if let brannerData = brannerData {
            sTitle = brannerData.title
            sContent = sTitle
            sLink = brannerData.linkUrl
            sPic = brannerData.picUrl
            self.id = brannerData.id
        }
        else if let doc = document {
            sTitle = doc.title
            sContent = doc.keyWordInfo
            sLink = doc.linkUrl
            sPic = doc.picUrl
            self.id = doc.id
        }
        else if let fav = favData {
            sTitle = fav.title
            sContent = fav.title
            sLink = fav.linkUrl
            sPic = fav.picUrl
            self.id = fav.infoId
        }
        
        self.loadWebRequest()
    }
    
    func loadWebRequest() {
        if let userId = LoginManager.shareInstance.userId {
            if let link = self.sLink, linkUrl = NSURL(string: link + "&UserId=\(userId)") {
                self.webView.loadRequest(NSURLRequest(URL: linkUrl))
                return
            }
        }
        
        if let link = self.sLink, linkUrl = NSURL(string: link) {
            self.webView.loadRequest(NSURLRequest(URL: linkUrl))
        }
    }

    func setupBind() {
        NSNotificationCenter.defaultCenter()
            .rac_notifications(loginStatusChangeNotification, object: nil)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self] (_) in
                self.getFavStatus()
                if LoginManager.shareInstance.isLogin {
                    guard let userId = LoginManager.shareInstance.userId else {
                        self.loadWebRequest()
                        return
                    }
                    self.notifyWebViewUserLogin(userId)
                }
                else {
                    self.loadWebRequest()
                }
        }.start()
    }

    func getFavStatus() {
        guard let userId = LoginManager.shareInstance.userId, infoId = self.id else {
            return
        }
        performGetFavStatus(userId, InfoId: infoId)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self] (data) in
                self.isFav = data.1
            }.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowCommentList.rawValue {
            if let destination = segue.destinationViewController as? CommentViewController {
                destination.title = "专家问答"
                destination.id = self.id
            }
        }

    }

    
    func notifyWebViewUserLogin(userId: String) {
        self.webView.stringByEvaluatingJavaScriptFromString(String("setUserId(\(userId));"))
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestString = request.URL?.absoluteString
        if let js = requestString where js == "http://app.medhorizon.com.cn/NewsDetail/call-medicine_app-method://login" {
            LoginManager.loginOrEnterUserInfo()
            return false
        }
        else if let js = requestString where js == "http://app.medhorizon.com.cn/NewsDetail/call-medicine_app-method://share" {
            self.showShareView()
            return false
        }
        return true
    }

    func showShareView() {

    }
}

extension WebDetailViewController {
    @IBAction func back(sender: AnyObject) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
        else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    @IBAction func downloadSource(sender: AnyObject) {
        self.checkCanDownload()
    }

    func checkCanDownload() {
        if let doc = self.document {
            if LoginManager.shareInstance.isLogin {
                if let userId = LoginManager.shareInstance.userId {
                    if let score = doc.needScore {
                        if score != 0 {
                            performForCheckDownLoad(userId, InfoId: doc.id, scoreNum: score)
                                .takeUntil(self.rac_WillDeallocSignalProducer())
                                .observeOn(UIScheduler())
                                .on(failed: { (error) in
                                    AppInfo.showDefaultNetworkErrorToast()
                                    }, next: {[unowned self] (msg, b) in
                                        if b {
                                            self.addDocumentToQueue(doc, toUser: userId)
                                        }
                                        else if let msg = msg {
                                            AppInfo.showToast(msg.errorMsg)
                                        }
                                        else {
                                            AppInfo.showToast("请稍候重试")
                                        }
                                    })
                                .start()
                        }
                        else {
                            self.addDocumentToQueue(doc, toUser: userId)
                        }
                    }
                    else {
                        self.addDocumentToQueue(doc, toUser: userId)
                    }
                }
            }
            else {
                LoginManager.loginOrEnterUserInfo()
            }
        }
    }
}

extension WebDetailViewController: ActionViewDelegate {

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
            guard let infoId = self.id,
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
                guard let userId = LoginManager.shareInstance.userId, infoId = self.id else {
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
            self.checkCanDownload()

        case .Share:
            self.showShareView()
        default:
            break
        }
    }

    func addDocumentToQueue(doc: CoursewareInfoViewModel, toUser userId: String) {
        DownloadManager.shareInstance.addDownloadItem(DownloadItem(sourceUrl: doc.sourceUrl, fileType: .Document, picUrl: doc.picUrl ?? "", status: .Wait, title: doc.title, progress: 0, userId: userId, downloadItem: nil))
    }
}
