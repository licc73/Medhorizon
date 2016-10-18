//
//  ForgotPwdViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ForgotPwdViewController: UIViewController {
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCheckCode: UITextField!
    @IBOutlet weak var txtPwd: UITextField!

    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)

        self.setDisplayView()
        self.setupBind()
    }

    func setDisplayView() {
        self.txtPhone.leftView = UIImageView(image: UIImage(named: "icon_txt_left_clear_view"))
        self.txtCheckCode.leftView = UIImageView(image: UIImage(named: "icon_txt_left_clear_view"))
        self.txtPwd.leftView = UIImageView(image: UIImage(named: "icon_txt_left_clear_view"))
        self.txtPhone.setupDefaultDisplay()
        self.txtCheckCode.setupDefaultDisplay()
        self.txtPwd.setupDefaultDisplay()
    }

    func setupBind() {
        let phoneSP = self.txtPhone.rac_textSignal()
            .toSignalProducer()
            .map { (object) -> Bool in
                if let s = object as? String {
                    if s.isValidPhone {
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

        let checkCodeSP = self.txtCheckCode.rac_textSignal()
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

        let pwdSP = self.txtPwd.rac_textSignal()
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

        combineLatest(phoneSP.flatMapError { _ in SignalProducer<Bool, NoError>.empty}, SMSCodeManager.shareInstance.isCanSendSMSCode.producer)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self](isPhone, canSendSMS) in
                self.btnSendCode.enabled = isPhone && canSendSMS
            }
            .start()

        SMSCodeManager.shareInstance.releaseSecond
            .producer
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self](second) in
                if second == 0 {
                    self.btnSendCode.setTitle("获取验证码", forState: .Normal)
                }
                else {
                    self.btnSendCode.setTitle("\(second)秒后重新获取", forState: .Normal)
                }
            }
            .start()

        combineLatest(phoneSP, pwdSP, checkCodeSP)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on {[unowned self] (isValidPhone, isValidPwd, isCheckCode) in
                if isValidPhone && isValidPwd && isCheckCode {
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

extension ForgotPwdViewController {
    @IBAction func back(sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func confirm(sender: AnyObject) {
        self.view.endEditing(true)

        guard let phone = self.txtPhone.text, smsCode = self.txtCheckCode.text, pwd = self.txtPwd.text else {
            return
        }

        LoginManager.performForgotPwd(phone, smsCode: smsCode, pwd: pwd)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on( failed: { (_) in
                AppInfo.showDefaultNetworkErrorToast()
                }, next: { [unowned self](returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            LoginManager.performLogin(phone, pwd: pwd)
                                .takeUntil(self.rac_WillDeallocSignalProducer())
                                .observeOn(UIScheduler())
                                .on(failed: {(error) in
                                    AppInfo.showDefaultNetworkErrorToast()
                                    },
                                    next: { [unowned self] (returnMsg) in
                                        if let msg = returnMsg {
                                            if msg.isSuccess {
                                                AppInfo.showToast("您已成功找回密码")
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                                return
                                            }
                                            else {

                                            }
                                        }
                                        else {

                                        }
                                        AppInfo.showToast("您已成功找回密码")
                                        self.navigationController?.popViewControllerAnimated(true)
                                })
                                .start()
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

    @IBAction func sendCheckCode(sender: AnyObject) {
        self.view.endEditing(true)

        guard let phone = self.txtPhone.text else {
            return
        }

        guard SMSCodeManager.shareInstance.isCanSendSMSCode.value else {
            return
        }

        SMSCodeManager.shareInstance.getPermision()

        LoginManager.performSendSMSCode(phone, type: .ForgotPwd)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(failed: {(error) in
                SMSCodeManager.shareInstance.releasePermision()
                AppInfo.showDefaultNetworkErrorToast()
                },
                next: { (returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            AppInfo.showToast("验证码发送成功，请注意查收")
                        }
                        else {
                            SMSCodeManager.shareInstance.releasePermision()
                            AppInfo.showToast(msg.errorMsg)
                        }
                    }
                    else {
                        SMSCodeManager.shareInstance.releasePermision()
                        AppInfo.showToast("未知错误")
                    }
            })
            .start()
    }

    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

extension ForgotPwdViewController: UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtPhone {
            guard let curString = self.txtPhone.text else {
                return true
            }
            if curString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) + string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - range.length > 11 {
                return false
            }
        }
        return true
    }
    
}
