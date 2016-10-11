//
//  WebDetailViewController.swift
//  Medhorizon
//
//  Created by ZongBo Zhou on 10/11/16.
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
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}

extension WebDetailViewController {
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
