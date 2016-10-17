//
//  ChangePhoneViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ChangePhoneViewController: UIViewController {

    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCheckCode: UITextField!

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
        self.txtPhone.setupDefaultDisplay()
        self.txtCheckCode.setupDefaultDisplay()
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

        combineLatest(phoneSP, checkCodeSP)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on {[unowned self] (isValidPhone, isCheckCode) in
                if isValidPhone && isCheckCode {
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

extension ChangePhoneViewController {
    @IBAction func back(sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func confirm(sender: AnyObject) {
        self.view.endEditing(true)

        guard let phone = self.txtPhone.text, smsCode = self.txtCheckCode.text, userId = LoginManager.shareInstance.userId else {
            return
        }

        LoginManager.performModifyPhone(userId, phone: phone, vcode: smsCode)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on( failed: { (_) in
                AppInfo.showDefaultNetworkErrorToast()
                }, next: {[unowned self] (returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            AppInfo.showToast("您已成功修改绑定手机")
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

    @IBAction func sendCheckCode(sender: AnyObject) {
        self.view.endEditing(true)

        guard let phone = self.txtPhone.text else {
            return
        }

        guard SMSCodeManager.shareInstance.isCanSendSMSCode.value else {
            return
        }

        SMSCodeManager.shareInstance.getPermision()

        LoginManager.performSendSMSCode(phone, type: .ModifyPhone)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(failed: {(error) in
                AppInfo.showDefaultNetworkErrorToast()
                },
                next: { (returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            AppInfo.showToast("验证码发送成功，请注意查收")
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

extension ChangePhoneViewController: UITextFieldDelegate {

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
