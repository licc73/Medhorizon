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
    
    var newsData: NewsViewModel?
    var brannerData: Branner?
    
    
    var sTitle: String?
    var sContent: String?
    var sLink: String?
    var sPic: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.extractData()
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
}
