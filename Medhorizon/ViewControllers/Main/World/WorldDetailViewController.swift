//
//  WorldDetailViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/13/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class WorldDetailViewController: UIViewController {
    let placeHolderImage = UIImage(named: "")
    
    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labJob: UILabel!
    @IBOutlet weak var labContent: UILabel!
    @IBOutlet weak var labName: UILabel!

    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnDocument: UIButton!
    @IBOutlet weak var btnExcelentCase: UIButton!

    @IBOutlet weak var tableView: UITableView!

    var worldDetail: WorldDetailViewModel?

    var expertBrief: ExpertListViewModel?

    var type: CoursewareType = .Video

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        if let expert = expertBrief {
            self.worldDetail = WorldDetailViewModel(expertId: expert.id, departmentId: GlobalData.shareInstance.departmentId.value, courseType: type)
            self.setDisplayView()
            self.initMJRefresh()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDisplayView() {
        if let expert = expertBrief {
            self.labJob.text = expert.jobName
            self.labContent.text = expert.keyWordInfo
            self.labName.text = expert.zName

            if let pic = expert.picUrl, picUrl = NSURL(string: pic) {
                self.imgvThumbnail.sd_setImageWithURL(picUrl, placeholderImage: placeHolderImage)
            }
        }

        self.setTypeView()
    }

    func setTypeView() {
        self.btnExcelentCase.selected = false
        self.btnDocument.selected = false
        self.btnVideo.selected = false
        switch type {
        case .Video:
            self.btnVideo.selected = true
        case .Document:
            self.btnDocument.selected = true
        case .ExcelentCase:
            self.btnExcelentCase.selected = true
        }
    }

    func initMJRefresh() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self]_ in
            self.worldDetail?.performRefreshServerFetch()
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
            self.worldDetail?.performLoadMoreServerFetch()
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

    func setupBind() {
        GlobalData.shareInstance.departmentId
            .producer
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .on { [unowned self](department) in

                self.worldDetail?.performSwitchDepartmentFetch()
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
        let curData = self.worldDetail?.getCurData()
        self.tableView.reloadData()
        self.tableView.endRefresh(curData?.isHaveMoreData)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowWorldDetailDetail.rawValue {
            if let detail = segue.destinationViewController as? WebDetailViewController, doc = sender as? CoursewareInfoViewModel {
                detail.document = doc
                detail.title = "专业课件"
                detail.showActionToolBar = true
            }
        }
    }

}

extension WorldDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let curData = self.worldDetail?.getCurData()
        return curData?.courseList.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WorldDetailTableViewCell", forIndexPath: indexPath) as! WorldDetailTableViewCell
        let curData = self.worldDetail?.getCurData()
        cell.document = curData?.courseList[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        if let curData = self.worldDetail?.getCurData() {
            guard indexPath.row < curData.courseList.count else {
                return
            }

            let document = curData.courseList[indexPath.row]

            if LoginManager.shareInstance.isLogin {
                if self.type == .Video {

                }
                else {
                    self.performSegueWithIdentifier(StoryboardSegue.Main.ShowWorldDetailDetail.rawValue, sender: document)
                }

            }
            else {
                guard let isNeedLogin = document.isNeedLogin where !isNeedLogin else {
                    LoginManager.loginOrEnterUserInfo()
                    return
                }

                if self.type == .Video {

                }
                else {
                    self.performSegueWithIdentifier(StoryboardSegue.Main.ShowWorldDetailDetail.rawValue, sender: document)
                }
            }
        }
    }
}


extension WorldDetailViewController {
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func chooseType(sender: UIButton) {
        if sender == self.btnVideo {
            self.type = .Video
        }
        else if sender == self.btnDocument {
            self.type = .Document
        }
        else if sender == self.btnExcelentCase {
            self.type = .ExcelentCase
        }
        self.setTypeView()
        self.worldDetail?.coursewareType = type

        self.worldDetail?.performSwitchDepartmentFetch()
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

}
