//
//  UserDetailInfoViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class UserDetailInfoViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var funcList: [UserEditType] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.setupDefaultDisplay()
        self.generateData()
        self.setupBind()
    }

    func setupDefaultDisplay() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        self.tableView.registerNib(UINib(nibName: "UserHeaderEditTableViewCell", bundle: nil), forCellReuseIdentifier: userHeaderEditTableViewCellId)
        self.tableView.registerNib(UINib(nibName: "SeparatorLineTableViewCell", bundle: nil), forCellReuseIdentifier: separatorLineTableViewCellId)
        self.tableView.registerNib(UINib(nibName: "UserBaseInfoEditTableViewCell", bundle: nil), forCellReuseIdentifier: userBaseInfoEditTableViewCellId)
        self.tableView.registerNib(UINib(nibName: "UserTableHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: userTableHeaderTableViewCellId)
    }

    func generateData() {
        self.funcList.removeAll()

        let loginInfo = LoginManager.shareInstance.loginInfo
        let detail = LoginManager.shareInstance.userDetailInfo

        self.funcList.append(UserEditType.Header(UserEditInfoHeaderPicType(title:"头像", picUrl: loginInfo?.picUrl, cellHeight: 100)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: nil, insets: UIEdgeInsetsMake(0, 15, 0, 15), lineHeight: 0.5)))

        self.funcList.append(UserEditType.NickName(UserEditInfoBaseInfoType(title: "昵称", value: loginInfo?.nickName, titleColor: nil, valueColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0x2e94cb), insets: UIEdgeInsetsZero, lineHeight: 1)))

        self.funcList.append(UserEditType.SectionHeader(UserEditSectionHeaderInfoType(title: "账号绑定", icon: "icon_account", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.Phone(UserEditInfoBaseInfoType(title: "手机", value: loginInfo?.phone, titleColor: nil, valueColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: nil, insets: UIEdgeInsetsMake(0, 15, 0, 15), lineHeight: 0.5)))
        self.funcList.append(UserEditType.Weixin(UserEditInfoBaseInfoType(title: "微信", value: detail?.weixin, titleColor: nil, valueColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0x2e94cb), insets: UIEdgeInsetsZero, lineHeight: 1)))

        self.funcList.append(UserEditType.SectionHeader(UserEditSectionHeaderInfoType(title: "安全设置", icon: "icon_safe", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.Pwd(UserEditInfoBaseInfoType(title: "登录密码", value: loginInfo?.phone, titleColor: nil, valueColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0x2e94cb), insets: UIEdgeInsetsZero, lineHeight: 1)))

        var strueTitle = ""
        if let detail = detail {
            if let w = detail.WWID where w != "" {
                strueTitle = "强生员工"
            }
            else if let b = detail.isTrueName where b {
                strueTitle = "实名"
            }
            else {
                strueTitle = "未认证"
            }
        }

        self.funcList.append(UserEditType.TrueName(UserEditInfoBaseInfoType(title: "实名认证", value: strueTitle, titleColor: nil, valueColor: nil, cellHeight: 40)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0x2e94cb), insets: UIEdgeInsetsZero, lineHeight: 1)))

        self.tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.refreshUserDetail()
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
                destination.linkUrl = feedbackUrl
                destination.title = "意见反馈"
            }
        }
    }


}

extension UserDetailInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.funcList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let function = self.funcList[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier(function.cellId, forIndexPath: indexPath)

        switch function {
        case let .Header(cellInfo):
            if let cell = cell as? UserHeaderEditTableViewCell {
                cell.setTitle(cellInfo.title, imgUrl: cellInfo.picUrl)
            }
        case let .NickName(cellInfo):
            if let cell = cell as? UserBaseInfoEditTableViewCell {
                cell.setTitle(cellInfo.title, value: cellInfo.value)
            }
        case let .Phone(cellInfo):
            if let cell = cell as? UserBaseInfoEditTableViewCell {
                cell.setTitle(cellInfo.title, value: cellInfo.value)
            }
        case let .Weixin(cellInfo):
            if let cell = cell as? UserBaseInfoEditTableViewCell {
                cell.setTitle(cellInfo.title, value: cellInfo.value)
            }
        case let .Pwd(cellInfo):
            if let cell = cell as? UserBaseInfoEditTableViewCell {
                cell.setTitle(cellInfo.title, value: cellInfo.value)
            }
        case let .TrueName(cellInfo):
            if let cell = cell as? UserBaseInfoEditTableViewCell {
                cell.setTitle(cellInfo.title, value: cellInfo.value)
            }
        case let .SeparatorLine(cellInfo):
            if let cell = cell as? SeparatorLineTableViewCell {
                cell.setLineColor(cellInfo.color, insets: cellInfo.insets)
            }
        case let .SectionHeader(cellInfo):
            if let cell = cell as? UserTableHeaderTableViewCell {
                cell.setTitle(cellInfo.title, icon: cellInfo.icon)
            }
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
        case .Header:
            let actionController = UIAlertController(title: nil,
                                                     message:"请选择",
                                                     preferredStyle: UIAlertControllerStyle.ActionSheet)

            actionController.addAction(UIAlertAction(title: "从相机",
                style: UIAlertActionStyle.Default, handler: {(action) -> Void in

            }))

            actionController.addAction(UIAlertAction(title: "从相册",
                style: UIAlertActionStyle.Default, handler: {(action) -> Void in

            }))

            actionController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in

            }))

            self.presentViewController(actionController, animated: true, completion: nil)

        default:
            break
        }
    }

}

extension UserDetailInfoViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
