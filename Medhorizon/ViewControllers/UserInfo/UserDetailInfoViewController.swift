//
//  UserDetailInfoViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SVProgressHUD

class UserDetailInfoViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var funcList: [UserEditType] = []

    var headerImg: UIImage? = nil

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
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xb1d1e8), insets: UIEdgeInsetsZero, lineHeight: 0.5)))

        self.funcList.append(UserEditType.SectionHeader(UserEditSectionHeaderInfoType(title: "账号绑定", icon: "icon_account", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.Phone(UserEditInfoBaseInfoType(title: "手机", value: loginInfo?.phone, titleColor: nil, valueColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: nil, insets: UIEdgeInsetsMake(0, 15, 0, 15), lineHeight: 0.5)))
        self.funcList.append(UserEditType.Weixin(UserEditInfoBaseInfoType(title: "微信", value: detail?.weixin, titleColor: nil, valueColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xb1d1e8), insets: UIEdgeInsetsZero, lineHeight: 0.5)))

        self.funcList.append(UserEditType.SectionHeader(UserEditSectionHeaderInfoType(title: "安全设置", icon: "icon_safe", titleColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.Pwd(UserEditInfoBaseInfoType(title: "登录密码", value: "修改", titleColor: nil, valueColor: nil, cellHeight: 50)))
        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xb1d1e8), insets: UIEdgeInsetsZero, lineHeight: 0.5)))

//        var strueTitle = ""
//        if let detail = detail {
//            if let w = detail.WWID where w != "" {
//                strueTitle = "强生员工"
//            }
//            else if let b = detail.isTrueName where b {
//                strueTitle = "医生"
//            }
//            else {
//                strueTitle = "未认证"
//            }
//        }
//
//        self.funcList.append(UserEditType.TrueName(UserEditInfoBaseInfoType(title: "用户身份", value: strueTitle, titleColor: nil, valueColor: nil, cellHeight: 40)))
//        self.funcList.append(UserEditType.SeparatorLine(UserInfoSeparatorLineType(color: UIColor.colorWithHex(0xb1d1e8), insets: UIEdgeInsetsZero, lineHeight: 0.5)))

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
                cell.setTitle(cellInfo.title, imgUrl: cellInfo.picUrl, localImg: headerImg)
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
                                                     message:"个人头像",
                                                     preferredStyle: UIAlertControllerStyle.ActionSheet)



            actionController.addAction(UIAlertAction(title: "从手机相册选择",
                style: UIAlertActionStyle.Default, handler: {(action) -> Void in
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.allowsEditing = true//设置可编辑
                    picker.sourceType = .PhotoLibrary
                    self.presentViewController(picker, animated: true, completion: nil)
            }))

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                actionController.addAction(UIAlertAction(title: "拍照",
                    style: UIAlertActionStyle.Default, handler: {(action) -> Void in
                        let picker = UIImagePickerController()
                        picker.delegate = self
                        picker.allowsEditing = true//设置可编辑
                        picker.sourceType = .Camera
                        self.presentViewController(picker, animated: true, completion: nil)
                }))
            }

            actionController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in

            }))

            self.presentViewController(actionController, animated: true, completion: nil)
        case .NickName:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowChangeNickName.rawValue, sender: nil)
        case .Phone:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowChangePhoneView.rawValue, sender: nil)
        case .Pwd:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowChangePwdView.rawValue, sender: nil)
        case .TrueName:
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowTrueNameVerifyView.rawValue, sender: nil)
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

extension UserDetailInfoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        if let img = info[UIImagePickerControllerEditedImage] as? UIImage, pressImgData = UIImageJPEGRepresentation(img, 0.7) {

            self.headerImg = UIImage(data: pressImgData)
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow:0, inSection: 0)], withRowAnimation: .Automatic)

            self.uploadPic(pressImgData)
        }

        picker.dismissViewControllerAnimated(true, completion: nil)
    }


    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func uploadPic(imgData: NSData) {
        guard let userId = LoginManager.shareInstance.userId else {
            return
        }
        SVProgressHUD.show()
        //1.创建会话对象
        let session: NSURLSession = NSURLSession.sharedSession()

        //2.根据会话对象创建task
        let url: NSURL = NSURL(string: "http://app.medhorizon.com.cn/upHeadPicUrl")!

        //3.创建可变的请求对象
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)

        //4.修改请求方法为POST
        request.HTTPMethod = "POST"

        let sPost = String(format: "UserId=\(userId)&HeadUrl=data:image/jpg;base64,%@", imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0)))

        //5.设置请求体
        request.HTTPBody = sPost.dataUsingEncoding(NSUTF8StringEncoding)

        //6.根据会话对象创建一个Task(发送请求）
        /*
         第一个参数：请求对象
         第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
         data：响应体信息（期望的数据）
         response：响应头信息，主要是对服务器端的描述
         error：错误信息，如果请求失败，则error有值
         */
        let dataTask: NSURLSessionDataTask = session.dataTaskWithRequest(request) {[unowned self] (data, response, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                AppInfo.showToast("上传图片失败，请稍候重试")
                return
            }
            //if(error == nil){
            //8.解析数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            var dict: NSDictionary? = nil
            do {
                dict  = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.init(rawValue: 0)) as? NSDictionary
            } catch {

            }
            if let dic = dict as? [String: AnyObject], msg = ReturnMsg.mapToModel(dic) {
                if msg.isSuccess {
                    let headUrl = mapToString(dic)("HeadPic")
                    LoginManager.shareInstance.userDetailInfo?.headpic = headUrl
                    self.refreshUserDetail()
                }
                else {
                    AppInfo.showToast(msg.errorMsg)
                }
            }
            else {
                AppInfo.showToast("上传图片失败，请稍候重试")
            }
            //}
        }
        //5.执行任务
        dataTask.resume()
    }
}
