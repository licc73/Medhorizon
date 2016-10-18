//
//  SignupViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/15/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class SignupViewController: UIViewController {
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCheckCode: UITextField!
    @IBOutlet weak var txtPwd: UITextField!

    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnCheckPolicy: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!

    let isCheckPolicy: MutableProperty<Bool> = MutableProperty(false)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

        let checkPolicy: SignalProducer<Bool, NSError> = self.isCheckPolicy.producer.mapError { _ in NSError(domain: "", code: 0, userInfo: nil)
        }

        checkPolicy
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self](isCheck) in
                self.btnCheckPolicy.selected = isCheck
            }
            .start()

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

        combineLatest(phoneSP, pwdSP, checkCodeSP, checkPolicy)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on {[unowned self] (isValidPhone, isValidPwd, isCheckCode, isCheckPolicy) in
                if isValidPhone && isValidPwd && isCheckCode && isCheckPolicy {
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowNormalLink.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController {
                destination.linkUrl = privatePolicyUrl
                destination.title = "隐私声明"
            }
        }
    }


}

extension SignupViewController {
    @IBAction func back(sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func confirm(sender: AnyObject) {
        self.view.endEditing(true)

        guard let phone = self.txtPhone.text, smsCode = self.txtCheckCode.text, pwd = self.txtPwd.text else {
            return
        }

        LoginManager.performRegister(phone, smsCode: smsCode, pwd: pwd)
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
                                    next: { [unowned self](returnMsg) in
                                        if let msg = returnMsg {
                                            if msg.isSuccess {
                                                AppInfo.showToast("注册成功")
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                                return
                                            }
                                            else {

                                            }
                                        }
                                        else {

                                        }
                                        AppInfo.showToast("注册成功")
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

        LoginManager.performSendSMSCode(phone, type: .Signup)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(failed: {(error) in
                AppInfo.showDefaultNetworkErrorToast()
                SMSCodeManager.shareInstance.releasePermision()
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

    @IBAction func checkPolicy(sender: AnyObject) {
        self.view.endEditing(true)
        self.isCheckPolicy.value = !self.isCheckPolicy.value
    }

    @IBAction func openPolicy(sender: AnyObject) {
        self.view.endEditing(true)
        self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNormalLink.rawValue, sender: nil)
    }

    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

extension SignupViewController: UITextFieldDelegate {

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
