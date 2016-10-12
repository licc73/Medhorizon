//
//  WebDetailViewController.swift
//  Medhorizon
//
//  Created by lich on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

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
    
    
    var sTitle: String?
    var sContent: String?
    var sLink: String?
    var sPic: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.extractData()
        self.setToolBar()
    }

    func setToolBar() {
        if showActionToolBar {
            self.btnDownload.hidden = true
            self.vTool.backgroundColor = UIColor.colorWithHex(0xf5f6f7)
            self.vAction = ActionView(frame: CGRectZero)
            self.vAction?.config(actions)
            self.vAction?.delegate = self
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
        }
        else if let brannerData = brannerData {
            sTitle = brannerData.title
            sContent = sTitle
            sLink = brannerData.linkUrl
            sPic = brannerData.picUrl
        }
        else if let doc = document {
            sTitle = doc.title
            sContent = doc.keyWordInfo
            sLink = doc.linkUrl
            sPic = doc.picUrl
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            return false
        }
        return true
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

    }
}

extension WebDetailViewController: ActionViewDelegate {

    func actionViewShouldBeginAddComment(view view: ActionView) -> Bool {
        return true
    }

    func actionView(view view: ActionView, willSendComment: String) -> Bool {
        return true
    }

    func actionView(view view: ActionView, didSelectAction type: ActionType) {

    }
}
