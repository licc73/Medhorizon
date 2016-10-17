//
//  MyFavViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MyFavViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vNoFav: UIView!

    var favList: [FavViewModel] = []

    var isHaveMoreData: Bool = true

    var curPage = serverFirstPageNum

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.registerNib(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: messageTableViewCellId)
        self.initMJRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getFavFromServer(page: Int) {
        guard let userId = LoginManager.shareInstance.userId else {
            return
        }
        DefaultServiceRequests.rac_requesForFavList(userId, fid: FavType.All.rawValue, pageNum: page, pageSize: pageSize)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(failed: {[unowned self] (error) in
                AppInfo.showDefaultNetworkErrorToast()
                self.tableView.endRefresh()
                },
                next: {[unowned self] (page, data) in
                    let returnMsg = ReturnMsg.mapToModel(data)

                    if let msg = returnMsg where msg.isSuccess {
                        self.curPage = page

                        if let favList = data["InfoList"] as? [[String: AnyObject]] {
                            let favListModel = favList.flatMap {FavViewModel.mapToModel($0)}
                            if serverFirstPageNum == page {
                                self.favList = favListModel
                            }
                            else {
                                self.favList.appendContentsOf(favListModel)
                            }

                            if favList.count == pageSize {
                                self.isHaveMoreData = true
                            }
                            else {
                                self.isHaveMoreData = false
                            }
                        }
                        self.reloadData()
                    }
                    else {
                        //AppInfo.showToast(returnMsg?.errorMsg)
                    }
                })
            .start()
    }

    func initMJRefresh() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self]_ in
            self.getFavFromServer(serverFirstPageNum)
            })

        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self]_ in
            self.getFavFromServer(self.curPage + 1)
            })

        self.tableView.mj_footer.automaticallyHidden = true

        self.tableView.mj_header.beginRefreshing()
    }

    func reloadData() {
        if self.favList.count > 0 {
            self.tableView.backgroundView = nil
        }
        else {
            self.tableView.backgroundView = self.vNoFav
        }
        self.tableView.reloadData()
        self.tableView.endRefresh(self.isHaveMoreData)
    }


     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowNewsDetail.rawValue {
            if let destination = segue.destinationViewController as? WebDetailViewController {
                if let data = sender as? FavViewModel, fid = data.fid, fType = FavType(rawValue: fid) {
                    if case FavType.News = fType {

                    }
                    else {
                        destination.showActionToolBar = true
                    }
                    destination.title = data.title
                    destination.favData = data
                }
            }
        }

     }


}

extension MyFavViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavTableViewCell", forIndexPath: indexPath) as! FavTableViewCell
        cell.fav = self.favList[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let fav = self.favList[indexPath.row]
        guard let userId = LoginManager.shareInstance.userId else {
            return
        }
        
        performFavOrCancel(userId, InfoId: fav.infoId, type: FavOpType.CancelFav)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(next: {[unowned self] (returnMsg) in
                if let msg = returnMsg where msg.isSuccess {
                    self.tableView.beginUpdates()
                    self.favList.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    if self.favList.count == 0 {
                        self.reloadData()
                    }
                }
            }).start()


    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNewsDetail.rawValue, sender: self.favList[indexPath.row])
    }
}

extension MyFavViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
