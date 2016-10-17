//
//  DocumentListViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class DocumentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var docList: DocumentListViewModel?
    var forMeeting = false
    var mid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //self.tableView.tableHeaderView = self.coverFlow

        if forMeeting && mid != "" {
            self.docList = DocumentListViewModel()
            self.docList?.forMeeting = true
            self.docList?.mid = self.mid
        }
        else {
            self.docList = DocumentListViewModel()
        }

        
        self.setupBind()
        
        self.initMJRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMJRefresh() {
        self.tableView.mj_header = NMIssueRefreshHeader(refreshingBlock: {[unowned self]_ in
            self.docList?.performRefreshServerFetch()
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
            self.docList?.performLoadMoreServerFetch()
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
                self.docList?.departmentId = department
                self.docList?.performSwitchDepartmentFetch()
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

        DownloadManager.shareInstance.downloadHotSignal.producer
            .throttle(2, onScheduler: RACScheduler.mainThreadScheduler())
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .startWithNext { [unowned self](item) in
                if let sItem = item where sItem.status == .Finish {
                    self.updateCell(sItem)
                }
        }
    }

    func updateCell(item: DownloadItem) {
        if let curData = self.docList?.getCurData() {
            var index = 0
            for doc in curData.docList {
                if doc.sourceUrl == item.sourceUrl {
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
                    break
                }
                index += 1
            }


        }
    }
    
    func reloadData() {
        let curData = self.docList?.getCurData()
        
        self.tableView.reloadData()
        self.tableView.endRefresh(curData?.isHaveMoreData)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowDocumentInfo.rawValue {
            if let detail = segue.destinationViewController as? WebDetailViewController, doc = sender as? CoursewareInfoViewModel {
                detail.document = doc
                detail.title = "文献指南"
                detail.showDownloadToolBar = true
            }
        }
        else if let id = segue.identifier where id == StoryboardSegue.Main.ShowNormalLink.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController, doc = sender as? CoursewareInfoViewModel {
                destination.title = doc.title
                destination.filePath = DownloadItem.filePathWithSource(doc.sourceUrl, type: .Document)
            }
        }
    }
    
    
}

extension DocumentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let curData = self.docList?.getCurData()
        return curData?.docList.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DocumentListTableViewCell", forIndexPath: indexPath) as! DocumentListTableViewCell
        let curData = self.docList?.getCurData()
        cell.document = curData?.docList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        if let curData = self.docList?.getCurData() {
            guard indexPath.row < curData.docList.count else {
                return
            }

            let document = curData.docList[indexPath.row]

            if LoginManager.shareInstance.isLogin {
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowDocumentInfo.rawValue, sender: document)
            }
            else {
                guard let isNeedLogin = document.isNeedLogin where !isNeedLogin else {
                    LoginManager.loginOrEnterUserInfo()
                    return
                }

                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowDocumentInfo.rawValue, sender: document)
            }
        }
    }
}

extension DocumentListViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

extension DocumentListViewController: DocumentListTableViewCellDelegate {

    func documentListTableViewCellViewDocument(cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPathForCell(cell), curData = self.docList?.getCurData() {
            guard indexPath.row < curData.docList.count else {
                return
            }
            
            let document = curData.docList[indexPath.row]
            
            if LoginManager.shareInstance.isLogin {
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowDocumentInfo.rawValue, sender: document)
            }
            else {
                guard let isNeedLogin = document.isNeedLogin where !isNeedLogin else {
                    LoginManager.loginOrEnterUserInfo()
                    return
                }
                
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowDocumentInfo.rawValue, sender: document)
            }
        }
    }
    
    func documentListTableViewCellDownloadDocument(cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPathForCell(cell), curData = self.docList?.getCurData() {
            guard indexPath.row < curData.docList.count else {
                return
            }
            
            let document = curData.docList[indexPath.row]

            if DownloadManager.shareInstance.isSuccessDownloaded(document.sourceUrl) && NSFileManager.defaultManager().fileExistsAtPath(DownloadItem.filePathWithSource(document.sourceUrl, type: .Document)) {
                self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNormalLink.rawValue, sender: document)
                return
            }
            
            if LoginManager.shareInstance.isLogin {
                if let userId = LoginManager.shareInstance.userId {
                    if let score = document.needScore {
                        if score != 0 {
                            performForCheckDownLoad(userId, InfoId: document.id, scoreNum: score)
                                .takeUntil(self.rac_WillDeallocSignalProducer())
                                .observeOn(UIScheduler())
                                .on(failed: { (error) in
                                    AppInfo.showDefaultNetworkErrorToast()
                                    }, next: {[unowned self] (msg, b) in
                                        if b {
                                            self.addDocumentToQueue(document, toUser: userId)
                                        }
                                        else if let msg = msg {
                                            AppInfo.showToast(msg.errorMsg)
                                        }
                                        else {
                                            AppInfo.showToast("请稍候重试")
                                        }
                                })
                            .start()
                        }
                        else {
                            self.addDocumentToQueue(document, toUser: userId)
                        }
                    }
                    else {
                        self.addDocumentToQueue(document, toUser: userId)
                    }
                }
            }
            else {
                LoginManager.loginOrEnterUserInfo()
                
            }
        }
    }

    func addDocumentToQueue(doc: CoursewareInfoViewModel, toUser userId: String) {
        DownloadManager.shareInstance.addDownloadItem(DownloadItem(sourceUrl: doc.sourceUrl, fileType: .Document, picUrl: doc.picUrl ?? "", status: .Wait, title: doc.title, progress: 0, userId: userId, downloadItem: nil))
    }
    
}
