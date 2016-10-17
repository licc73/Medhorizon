//
//  DownloadViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.reloadData()
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
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowNormalLink.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController, wrapper = sender as? DownloadItemWrapper {
                destination.title = wrapper.download.title
                destination.filePath = wrapper.download.getResourcePath()
            }
        }
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
            }

        }

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        if let download = DownloadManager.shareInstance[indexPath.row] {
            if download.fileType == .Document {
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNormalLink.rawValue, sender: DownloadItemWrapper(download: download))
            }
            else {
                let path = download.getResourcePath()

                let player = MPMoviePlayerViewController(contentURL: NSURL(fileURLWithPath: path))

                self.presentMoviePlayerViewControllerAnimated(player)
            }
        }

    }
}

extension DownloadViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
