//
//  SysMessageViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SysMessageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var messageList: [SysMessageViewModel] = []

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

    func getMessageFromServer(page: Int) {
        guard let userId = LoginManager.shareInstance.userId else {
            return
        }
        DefaultServiceRequests.rac_requesForSysMessageList(userId, pageNum: page, pageSize: pageSize)
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

                        if let messageList = data["InfoList"] as? [[String: AnyObject]] {
                            let sysMessage = messageList.flatMap {SysMessageViewModel.mapToModel($0)}
                            if serverFirstPageNum == page {
                                self.messageList = sysMessage
                            }
                            else {
                                self.messageList.appendContentsOf(sysMessage)
                            }

                            if messageList.count == pageSize {
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
            self.getMessageFromServer(serverFirstPageNum)
            })

        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self]_ in
            self.getMessageFromServer(self.curPage + 1)
            })

        self.tableView.mj_footer.automaticallyHidden = true

        self.tableView.mj_header.beginRefreshing()
    }

    func reloadData() {
        self.tableView.reloadData()
        self.tableView.endRefresh(self.isHaveMoreData)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

extension SysMessageViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(messageTableViewCellId, forIndexPath: indexPath) as! MessageTableViewCell
        cell.sysMessage = self.messageList[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
}
