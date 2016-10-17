//
//  ChangePwdViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ChangePwdViewController: UIViewController {

    @IBOutlet weak var txtOldPwd: UITextField!
    @IBOutlet weak var txtNewPwd: UITextField!

    @IBOutlet weak var btnConfirm: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)

        self.setDisplayView()
        self.setupBind()
    }

    func setDisplayView() {
        self.txtOldPwd.leftView = UIImageView(image: UIImage(named: "icon_txt_left_clear_view"))
        self.txtNewPwd.leftView = UIImageView(image: UIImage(named: "icon_txt_left_clear_view"))
        self.txtOldPwd.setupDefaultDisplay()
        self.txtNewPwd.setupDefaultDisplay()
    }

    func setupBind() {

        let checkOldPwdSP = self.txtOldPwd.rac_textSignal()
            .toSignalProducer()
            .map { (object) -> Bool in
                if let s = object as? String {
                    if s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                        return true
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
        }

        let checkNewPwdSP = self.txtNewPwd.rac_textSignal()
            .toSignalProducer()
            .map { (object) -> Bool in
                if let s = object as? String {
                    if s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                        return true
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
        }

        combineLatest(checkOldPwdSP, checkNewPwdSP)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on {[unowned self] (isValidOld, isValidNew) in
                if isValidOld && isValidNew {
                    self.btnConfirm.enabled = true
                }
                else {
                    self.btnConfirm.enabled = false
                }
            }
            .start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ChangePwdViewController {
    @IBAction func back(sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func confirm(sender: AnyObject) {
        self.view.endEditing(true)

        guard let oldPwd = self.txtOldPwd.text, newPwd = self.txtNewPwd.text, userId = LoginManager.shareInstance.userId else {
            return
        }

        LoginManager.performModifyPwd(userId, oldPwd: oldPwd, newPwd: newPwd)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on( failed: { (_) in
                AppInfo.showDefaultNetworkErrorToast()
                }, next: {[unowned self] (returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            AppInfo.showToast("您已成功修改密码，请牢记")
                            self.navigationController?.popViewControllerAnimated(true)
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
    }
    
    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
