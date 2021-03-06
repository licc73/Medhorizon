//
//  DownloadViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class DownloadViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vNoData: UIView!

    // var isPlayMovie = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.reloadData()

        if DownloadManager.shareInstance.countOfDownloadList > 0 {
            self.tableView.backgroundView = nil
        }
        else {
            self.tableView.backgroundView = self.vNoData
        }
        self.setupBind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBind() {
        DownloadManager.shareInstance.downloadHotSignal.producer
            .throttle(2, onScheduler: RACScheduler.mainThreadScheduler())
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .startWithNext { [unowned self](item) in
                if let sItem = item where sItem.status == .Finish ||  sItem.status == .Fail {
                   self.tableView.endEditing(true)
                    self.tableView.reloadData()
                }
        }

//        NSNotificationCenter.defaultCenter()
//            .rac_notifications(MPMoviePlayerDidEnterFullscreenNotification, object: nil)
//            .takeUntil(self.rac_WillDeallocSignalProducer())
//            .observeOn(UIScheduler())
//            .on { [unowned self] (_) in
//                self.isPlayMovie = true
//                self.setNeedsStatusBarAppearanceUpdate()
//            }.start()
//
//        NSNotificationCenter.defaultCenter()
//            .rac_notifications(MPMoviePlayerDidExitFullscreenNotification, object: nil)
//            .takeUntil(self.rac_WillDeallocSignalProducer())
//            .observeOn(UIScheduler())
//            .on { [unowned self] (_) in
//                self.isPlayMovie = false
//                self.setNeedsStatusBarAppearanceUpdate()
//            }.start()
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowNormalLink.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController, wrapper = sender as? DownloadItemWrapper {
                destination.title = wrapper.download.title
                destination.filePath = wrapper.download.getResourcePath()
            }
        }
    }

    

    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }


}

class DownloadItemWrapper {
    let download: DownloadItem
    init(download: DownloadItem) {
        self.download = download
    }
}
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DownloadManager.shareInstance.countOfDownloadList
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadTableViewCell", forIndexPath: indexPath) as! DownloadTableViewCell
        cell.downLoad = DownloadManager.shareInstance[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < DownloadManager.shareInstance.countOfDownloadList {
            if let item = DownloadManager.shareInstance[indexPath.row]{
                self.tableView.beginUpdates()
                DownloadManager.shareInstance.removeItem(item)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                if DownloadManager.shareInstance.countOfDownloadList == 0 {
                    self.tableView.backgroundView = self.vNoData
                }
            }

        }

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        if let download = DownloadManager.shareInstance[indexPath.row] {
            if download.fileType == .Document {
                if download.status == .Finish {
                    self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNormalLink.rawValue, sender: DownloadItemWrapper(download: download))
                }
                else if download.status == .Fail {
                    let actionController = UIAlertController(title: "温馨提示",
                                                             message:"文件下载失败，是否重新下载？",
                                                             preferredStyle: UIAlertControllerStyle.Alert)

                    actionController.addAction(UIAlertAction(title: "确定",
                        style: UIAlertActionStyle.Default, handler: {(action) -> Void in
                            var d = download
                            d.status = .Wait
                            DownloadManager.shareInstance.addDownloadItem(d)
                        }))

                    actionController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
                        
                    }))
                    
                    self.presentViewController(actionController, animated: true, completion: nil)
                }
            }
            else {
                if download.status == .Finish {
                    let path = download.getResourcePath()
                    
                    let player = LocalPlayViewCtrl(contentURL: NSURL(fileURLWithPath: path))
                    //UIApplication.sharedApplication().statusBarOrientation = .LandscapeRight
                    self.presentMoviePlayerViewControllerAnimated(player)
                }
                else if download.status == .Fail {
                    let actionController = UIAlertController(title: "温馨提示",
                                                             message:"文件下载失败，是否重新下载？",
                                                             preferredStyle: UIAlertControllerStyle.Alert)
                    
                    actionController.addAction(UIAlertAction(title: "确定",
                        style: UIAlertActionStyle.Default, handler: {(action) -> Void in
                            var d = download
                            d.status = .Wait
                            DownloadManager.shareInstance.addDownloadItem(d)
                    }))
                    
                    actionController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
                        
                    }))
                    
                    self.presentViewController(actionController, animated: true, completion: nil)
                }
                
            }
        }

    }
}

extension DownloadViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

class LocalPlayViewCtrl: MPMoviePlayerViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
       return .LandscapeRight
    }
}
