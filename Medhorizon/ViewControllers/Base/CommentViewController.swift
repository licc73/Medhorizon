//
//  CommentViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/14/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class CommentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var commentListData: CommentListViewModel?

    var id: String?

    @IBOutlet weak var vTool: UIView!
    var actions: [ActionType] = []
    var vAction: ActionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.vTool.backgroundColor = UIColor.colorWithHex(0xf5f6f7)
        self.vAction = ActionView(frame: CGRectZero)
        self.vAction?.config(actions)
        self.vAction?.delegate = self
        self.vTool.addSubview(self.vAction!)
        
        if let id = self.id {
            self.commentListData = CommentListViewModel(infoId: id)
            self.initMJRefresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMJRefresh() {
        self.tableView.mj_header = NMIssueRefreshHeader(refreshingBlock: {[unowned self]_ in
            self.commentListData?.performRefreshServerFetch()
                .takeUntil(self.rac_WillDeallocSignalProducer())
                .observeOn(UIScheduler())
                .on(failed: {[unowned self] (error) in
                    AppInfo.showDefaultNetworkErrorToast()
                    self.tableView.endRefresh()
                    },
                    next: {[unowned self] (returnMsg) in
                        if let msg = returnMsg {
                            if msg.isSuccess {
                                self.reloadData()
                            }
                            else {
                                AppInfo.showToast(msg.errorMsg)
                            }
                        }
                    })
                .start()
            })

        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self]_ in
            self.commentListData?.performLoadMoreServerFetch()
                .takeUntil(self.rac_WillDeallocSignalProducer())
                .observeOn(UIScheduler())
                .on(failed: {[unowned self](error) in
                    AppInfo.showDefaultNetworkErrorToast()
                    self.tableView.endRefresh()
                    },
                    next: {[unowned self] (returnMsg) in
                        if let msg = returnMsg {
                            if msg.isSuccess {
                                self.reloadData()
                            }
                            else {
                                AppInfo.showToast(msg.errorMsg)
                            }
                        }
                    })
                .start()
            })
        self.tableView.mj_header.beginRefreshing()
        self.tableView.mj_footer.automaticallyHidden = true
    }

    func reloadData() {
        self.tableView.reloadData()
        self.tableView.endRefresh(self.commentListData?.isHaveMoreData)
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

extension CommentViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentListData?.commentCount ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let comment = self.commentListData?[indexPath.row] else {
            return UITableViewCell()
        }
        if comment.1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
            cell.comment = comment.0
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReplyCommentTableViewCell", forIndexPath: indexPath) as! ReplyCommentTableViewCell
            cell.comment = comment.0
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}

extension CommentViewController: ActionViewDelegate {

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

    }
    
}
