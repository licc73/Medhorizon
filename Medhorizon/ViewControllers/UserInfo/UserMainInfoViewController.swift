//
//  UserMainInfoViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

let userHeaderTableViewCellId = "UserHeaderTableViewCellTableViewCell"
let separatorLineTableViewCellId = "SeparatorLineTableViewCell"
let baseInfoTableViewCellId = "BaseInfoTableViewCell"
let msgTableViewCellId = "MsgTableViewCell"

class UserMainInfoViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var funcList: [UserMainInfoType] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.setupDefaultDisplay()
        //self.generateData()
        self.setupBind()

        self.refreshUserDetail()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.generateData()
    }

    func setupDefaultDisplay() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        self.tableView.registerNib(UINib(nibName: "UserHeaderTableViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: userHeaderTableViewCellId)
        self.tableView.registerNib(UINib(nibName: "SeparatorLineTableViewCell", bundle: nil), forCellReuseIdentifier: separatorLineTableViewCellId)
        self.tableView.registerNib(UINib(nibName: "BaseInfoTableViewCell", bundle: nil), forCellReuseIdentifier: baseInfoTableViewCellId)
        self.tableView.registerNib(UINib(nibName: "MsgTableViewCell", bundle: nil), forCellReuseIdentifier: msgTableViewCellId)
        self.tableView.registerNib(UINib(nibName: "LogoutTableViewCell", bundle: nil), forCellReuseIdentifier: logoutTableViewCellId)
    }

    func generateData() {
        self.funcList.removeAll()

        let loginInfo = LoginManager.shareInstance.loginInfo
        let detail = LoginManager.shareInstance.userDetailInfo

        self.funcList.append(UserMainInfoType.Header(UserInfoHeaderPicType(picUrl: loginInfo?.picUrl, nickName: loginInfo?.nickName, onlineDay: detail?.signDays, cellHeight: 130)))
        self.funcList.append(UserMainInfoType.Msg(UserInfoBaseInfoType(title: "消息", icon: "icon_userinfo_msg", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xdddddd), insets: UIEdgeInsetsZero, lineHeight: 1)))

        self.funcList.append(UserMainInfoType.PersonalInfo(UserInfoBaseInfoType(title: "个人资料", icon: "icon_userinfo_detailinfo", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xdddddd), insets: UIEdgeInsetsZero, lineHeight: 0.5)))

        self.funcList.append(UserMainInfoType.Fav(UserInfoBaseInfoType(title: "我的收藏", icon: "icon_userinfo_fav", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xdddddd), insets: UIEdgeInsetsZero, lineHeight: 0.5)))

        self.funcList.append(UserMainInfoType.Point(UserInfoBaseInfoType(title: "我的积分", icon: "icon_userinfo_point", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xdddddd), insets: UIEdgeInsetsZero, lineHeight: 0.5)))

        self.funcList.append(UserMainInfoType.Download(UserInfoBaseInfoType(title: "离线下载", icon: "icon_userinfo_download", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xb1d1e8), insets: UIEdgeInsetsZero, lineHeight: 1)))

        self.funcList.append(UserMainInfoType.Setting(UserInfoBaseInfoType(title: "设置", icon: "icon_userinfo_setup", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xdddddd), insets: UIEdgeInsetsMake(0, 15, 0, 15), lineHeight: 0.5)))

        self.funcList.append(UserMainInfoType.Feedback(UserInfoBaseInfoType(title: "意见反馈", icon: "icon_userinfo_feedback", titleColor: nil, cellHeight: 50)))
        //self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xb1d1e8), insets: UIEdgeInsetsZero, lineHeight: 1)))

        self.funcList.append(UserMainInfoType.Logout)
        //self.funcList.append(UserMainInfoType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xb1d1e8), insets: UIEdgeInsetsZero, lineHeight: 1)))

        self.tableView.reloadData()
    }

    func setupBind() {

    }

    func refreshUserDetail() {
        if let userId = LoginManager.shareInstance.userId {
            LoginManager.performGetUserDetail(userId)
                .takeUntil(self.rac_WillDeallocSignalProducer())
                .observeOn(UIScheduler())
                .on(failed: {(error) in

                    },
                    next: {[unowned self] (returnMsg) in
                        if let msg = returnMsg where msg.isSuccess{
                            if self.funcList.count > 0 {
                                self.generateData()
                                //self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
                            }
                        }
                    })
                .start()
        }
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

        if let id = segue.identifier where id == StoryboardSegue.Main.ShowFeedback.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController {
                if let userId = LoginManager.shareInstance.userId {
                    destination.linkUrl = feedbackUrl + "?UserId=\(userId)"
                }
                else {
                    destination.linkUrl = feedbackUrl
                }
                destination.title = "意见反馈"
            }
        }
    }
    

}

extension UserMainInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.funcList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let function = self.funcList[indexPath.row]

//        if case UserMainInfoType.Logout = function {
//            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
//            cell.textLabel?.textAlignment = .Center
//            cell.textLabel?.textColor = UIColor.colorWithHex(0x2892cb)
//            cell.textLabel?.text = "退出登录"
//            return cell
//        }

        let cell = tableView.dequeueReusableCellWithIdentifier(function.cellId, forIndexPath: indexPath)

        switch function {
        case let .Header(header):
            if let cell = cell as? UserHeaderTableViewCellTableViewCell {
                cell.setHeadPic(header.picUrl, nickName: header.nickName, day: header.onlineDay)
            }
        case let .Msg(cellInfo):
            if let cell = cell as? BaseInfoTableViewCell {
                cell.setIcon(cellInfo.icon, title: cellInfo.title, textColor: cellInfo.titleColor)
            }
        case let .SeparatorLine(cellInfo):
            if let cell = cell as? SeparatorLineTableViewCell {
                cell.setLineColor(cellInfo.color, insets: cellInfo.insets)
            }
        case let .PersonalInfo(cellInfo):
            if let cell = cell as? BaseInfoTableViewCell {
                cell.setIcon(cellInfo.icon, title: cellInfo.title, textColor: cellInfo.titleColor)
            }
        case let .Fav(cellInfo):
            if let cell = cell as? BaseInfoTableViewCell {
                cell.setIcon(cellInfo.icon, title: cellInfo.title, textColor: cellInfo.titleColor)
            }
        case let .Point(cellInfo):
            if let cell = cell as? BaseInfoTableViewCell {
                cell.setIcon(cellInfo.icon, title: cellInfo.title, textColor: cellInfo.titleColor)
            }
        case let .Download(cellInfo):
            if let cell = cell as? BaseInfoTableViewCell {
                cell.setIcon(cellInfo.icon, title: cellInfo.title, textColor: cellInfo.titleColor)
            }
        case let .Setting(cellInfo):
            if let cell = cell as? BaseInfoTableViewCell {
                cell.setIcon(cellInfo.icon, title: cellInfo.title, textColor: cellInfo.titleColor)
            }
        case let .Feedback(cellInfo):
            if let cell = cell as? BaseInfoTableViewCell {
                cell.setIcon(cellInfo.icon, title: cellInfo.title, textColor: cellInfo.titleColor)
            }
        case .Logout:
            if let cell = cell as? LogoutTableViewCell {
                cell.bntButton.addTarget(self, action: #selector(logout(_:)), forControlEvents: .TouchUpInside)
            }

        default:
            return UITableViewCell()
        }

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let function = self.funcList[indexPath.row]
        return function.cellHeight
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        let function = self.funcList[indexPath.row]
        switch function {
        case .Logout:
            break

        case .Feedback:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowFeedback.rawValue, sender: nil)
        case .Msg:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowMessageView.rawValue, sender: nil)
        case .Fav:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowFavView.rawValue, sender: nil)
        case .PersonalInfo:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowUserDetailInfo.rawValue, sender: nil)
        case .Point:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowPointView.rawValue, sender: nil)
        case .Download:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowDownloadView.rawValue, sender: nil)
        case .Setting:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowSetupView.rawValue, sender: nil)
        default:
            break
        }

    }

}

extension UserMainInfoViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func logout(sender: UIButton) {
        let actionController = UIAlertController(title: "温馨提示",
                                                 message:"你确定要退出登录吗？",
                                                 preferredStyle: UIAlertControllerStyle.Alert)

        actionController.addAction(UIAlertAction(title: "确定",
            style: UIAlertActionStyle.Default, handler: {[unowned self] (action) -> Void in
                LoginManager.shareInstance.clearLoginInfo()
                self.navigationController?.popViewControllerAnimated(true)
            }))

        actionController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in

        }))

        self.presentViewController(actionController, animated: true, completion: nil)
    }
    
}
