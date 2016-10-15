//
//  MeetingDetailViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/15/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class MeetingDetailViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnDocment: UIButton!

    var meeting: MeetingViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnVideo.makeImageAndTitleUpDown()
        self.btnDocment.makeImageAndTitleUpDown()
        
        self.loadWebRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebRequest() {
        if let userId = LoginManager.shareInstance.userId {
            if let link = self.meeting?.linkUrl, linkUrl = NSURL(string: link + "&UserId=\(userId)") {
                self.webView.loadRequest(NSURLRequest(URL: linkUrl))
                return
            }
        }

        if let link = self.meeting?.linkUrl, linkUrl = NSURL(string: link) {
            self.webView.loadRequest(NSURLRequest(URL: linkUrl))
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowNormalLink.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController {
                if let data = sender as? String {
                    destination.linkUrl = data
                    destination.title = self.meeting?.title
                }
            }
        }
        else {
            if let id = segue.identifier where id == StoryboardSegue.Main.ShowMeetingDoc.rawValue {
                if let destination = segue.destinationViewController as? DocumentListViewController {
                    if let mid = sender as? String {
                        destination.forMeeting = true
                        destination.mid = mid
                        destination.title = self.meeting?.title
                    }
                }
            }
        }

    }


}

extension MeetingDetailViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func vidoeOnClicked(sender: AnyObject) {
        let link = self.meeting?.outLink
        if link != nil {
            if let link = link where link != "" {
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNormalLink.rawValue, sender: link)
            }
            else {
                AppInfo.showToast("本次会议还未收录该内容")
            }
        }
        else {
            AppInfo.showToast("本次会议还未收录该内容")
        }
    }

    @IBAction func documentOnClicked(sender: AnyObject) {
        let fileNum = self.meeting?.fileNum
        if fileNum != nil {
            if let fileNum = fileNum where fileNum != 0 {
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowMeetingDoc.rawValue, sender: self.meeting?.id)
            }
            else {
                 AppInfo.showToast("本次会议还未收录该内容")
            }
        }
        else {
            AppInfo.showToast("本次会议还未收录该内容")
        }
    }

}
