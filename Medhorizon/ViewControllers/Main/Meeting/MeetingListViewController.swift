//
//  MeetingListViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MeetingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var meetingList: MeetingListViewModel?
    var coverFlow: CoverFlowView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        self.coverFlow = CoverFlowView(frame: CGRectMake(0, 0, AppInfo.screenWidth, AppInfo.screenWidth * 25.0 / 64.0))
        self.coverFlow?.delegate = self

        //self.tableView.tableHeaderView = self.coverFlow

        self.meetingList = MeetingListViewModel()

        self.setupBind()

        self.initMJRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initMJRefresh() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self]_ in
            self.meetingList?.performRefreshServerFetch()
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
            self.meetingList?.performLoadMoreServerFetch()
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

        self.tableView.mj_footer.automaticallyHidden = true
    }

    func setupBind() {
        GlobalData.shareInstance.departmentId
            .producer
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .on { [unowned self](department) in
                self.meetingList?.departmentId = department
                self.meetingList?.performSwitchDepartmentFetch()
                    .takeUntil(self.rac_WillDeallocSignalProducer())
                    .observeOn(UIScheduler())
                    .on(failed: { (error) in
                        AppInfo.showDefaultNetworkErrorToast()
                        self.reloadData()
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
            }
            .start()
    }

    func reloadData() {
        let curData = self.meetingList?.getCurData()
        self.tableView.tableHeaderView = nil
        if curData?.brannerList.count ?? 0 > 0 {
            self.tableView.tableHeaderView = self.coverFlow
            self.coverFlow?.reloadData()
        }


        self.tableView.reloadData()
        self.tableView.endRefresh(curData?.isHaveMoreData)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowMeetingBranner.rawValue {
            if let detail = segue.destinationViewController as? WebDetailViewController {
                if let data = sender as? BrannerViewModel {
                    detail.brannerData = data
                    detail.title = data.title
                }
            }
        }
        else if let id = segue.identifier where id == StoryboardSegue.Main.ShowMeetingDetail.rawValue {
            if let detail = segue.destinationViewController as? MeetingDetailViewController {
                if let data = sender as? MeetingViewModel {
                    detail.meeting = data
                }
            }
        }
    }


}

extension MeetingListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let curData = self.meetingList?.getCurData()
        return curData?.meetingList.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MeetingListTableViewCell", forIndexPath: indexPath) as! MeetingListTableViewCell
        let curData = self.meetingList?.getCurData()
        cell.meeting = curData?.meetingList[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        if let curData = self.meetingList?.getCurData() {
            guard indexPath.row < curData.meetingList.count else {
                return
            }

            let meeting = curData.meetingList[indexPath.row]

            if LoginManager.shareInstance.isLogin {
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowMeetingDetail.rawValue, sender: meeting)
            }
            else {
                guard let isNeedLogin = meeting.isNeedLogin where !isNeedLogin else {
                    LoginManager.loginOrEnterUserInfo()
                    return
                }

                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowMeetingDetail.rawValue, sender: meeting)
            }
        }
    }
}

extension MeetingListViewController: CoverFlowViewDelegate {

    func coverFlowView(view: CoverFlowView, didSelect index: Int) {
        if let curData = self.meetingList?.getCurData() {
            guard index >= 0 && index < curData.brannerList.count else {
                return
            }

            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowMeetingBranner.rawValue, sender: curData.brannerList[index])
        }

    }

    func numberOfCoversInCoverFlowView(view: CoverFlowView) -> Int {
        let curData = self.meetingList?.getCurData()
        return curData?.brannerList.count ?? 0
    }

    func coverImage(view: CoverFlowView, atIndex index: Int) -> String? {
        let curData = self.meetingList?.getCurData()
        return curData?.brannerList[index].picUrl
    }
    
}
