//
//  MyPointViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MyPointViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vTableHeader: UIView!
    @IBOutlet weak var labPoint: UILabel!
    @IBOutlet weak var vNoPoint: UIView!

    var pointList: [PointViewModel] = []

    var isHaveMoreData: Bool = true

    var curPage = serverFirstPageNum

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        //self.tableView.tableHeaderView = self.vTableHeader
        self.initMJRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getPointFromServer(page: Int) {
        guard let userId = LoginManager.shareInstance.userId else {
            return
        }
        DefaultServiceRequests.rac_requesForPointList(userId, pageNum: page, pageSize: pageSize)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(failed: {[unowned self] (error) in
                AppInfo.showDefaultNetworkErrorToast()
                self.tableView.endRefresh()
                },
                next: {[unowned self] (page, data) in
                    let returnMsg = ReturnMsg.mapToModel(data)

                    if let msg = returnMsg where msg.isSuccess {
                        let point = mapToString(data)("SumScore") ?? "0"
                        let pointDesc = "当前积分：%1$@%2$@"
                        //let formatAttr = NSAttributedString(string: "\(pointDesc)", attributes: [NSForegroundColorAttributeName: UIColor.colorWithHex(0x999999), NSFontAttributeName: UIFont.systemFontOfSize(12)])
                        let pointAttr = NSAttributedString(string: "\(point)", attributes: [NSForegroundColorAttributeName: UIColor.colorWithHex(0x2892cb), NSFontAttributeName: UIFont.systemFontOfSize(30)])
                        let pointUnit = NSAttributedString(string: "分", attributes: [NSForegroundColorAttributeName: UIColor.colorWithHex(0x2892cb), NSFontAttributeName: UIFont.systemFontOfSize(12)])

                        self.labPoint.attributedText = NSAttributedString(attributes: [NSForegroundColorAttributeName : UIColor.colorWithHex(0x999999),  NSFontAttributeName: UIFont.systemFontOfSize(12)], format: pointDesc, pointAttr, pointUnit)
                        
                        //self.labPoint.text = mapToString(data)("SumScore")
                        self.curPage = page

                        if let pointList = data["InfoList"] as? [[String: AnyObject]] {
                            let pointListModel = pointList.flatMap {PointViewModel.mapToModel($0)}
                            if serverFirstPageNum == page {
                                self.pointList = pointListModel
                            }
                            else {
                                self.pointList.appendContentsOf(pointListModel)
                            }

                            if pointList.count == pageSize {
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
        self.tableView.mj_header = NMIssueRefreshHeader(refreshingBlock: {[unowned self]_ in
            self.getPointFromServer(serverFirstPageNum)
            })

        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self]_ in
            self.getPointFromServer(self.curPage + 1)
            })

        self.tableView.mj_footer.automaticallyHidden = true

        self.tableView.mj_header.beginRefreshing()
    }

    func reloadData() {
        if self.pointList.count > 0 {
            self.tableView.tableHeaderView = self.vTableHeader
            self.tableView.backgroundView = nil
        }
        else {
            self.tableView.tableHeaderView = nil
            self.tableView.backgroundView = self.vNoPoint
        }

        self.tableView.reloadData()
        self.tableView.endRefresh(self.isHaveMoreData)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowNormalLink.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController {
                destination.linkUrl = pointPolicyUrl
                destination.title = "积分规则"
            }
        }
    }


}

extension MyPointViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pointList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PointListTableViewCell", forIndexPath: indexPath) as! PointListTableViewCell
        cell.point = self.pointList[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}

extension MyPointViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func openPointPolicy(sender: AnyObject) {
        self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNormalLink.rawValue, sender: nil)
    }

}
