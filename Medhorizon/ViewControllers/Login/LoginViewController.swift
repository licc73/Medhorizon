//
//  LoginViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/15/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPwd: UITextField!

    @IBOutlet weak var btnLogin: UIButton!

    var isInLoginInWeiXinFlow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .Black
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)

        self.setDisplayView()
        self.setupBind()
    }

    func setDisplayView() {
        self.txtPhone.leftView = UIImageView(image: UIImage(named: "icon_phone"))
        self.txtPwd.leftView = UIImageView(image: UIImage(named: "icon_pwd"))
        self.txtPhone.setupDefaultDisplay()
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

        combineLatest(phoneSP, pwdSP)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on { [unowned self] (isValidPhone, isValidPwd) in
            if isValidPhone && isValidPwd {
                self.btnLogin.enabled = true
            }
            else {
                self.btnLogin.enabled = false
            }
        }
        .start()

        NSNotificationCenter.defaultCenter().rac_addObserverForName("WXLOGINSUCNOTIFICATION", object: nil)
            .toSignalProducer()
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on( failed: { [unowned self](_) in
                self.isInLoginInWeiXinFlow = false
            }) { [unowned self](object) in

                if self.isInLoginInWeiXinFlow {
                    self.isInLoginInWeiXinFlow = false
                    guard let object = object as? NSNotification,
                        dic = object.userInfo as? [String: AnyObject],
                        openId = mapToString(dic)("openid"),
                        token = mapToString(dic)("access_token")
                        else {
                            return
                    }
                    SVProgressHUD.show()
                    LoginManager.performLoginWithWX(nil, token: token, openId: openId)
                        .takeUntil(self.rac_WillDeallocSignalProducer())
                        .observeOn(UIScheduler())
                        .on(failed: {(error) in
                            AppInfo.showDefaultNetworkErrorToast()
                            SVProgressHUD.dismiss()
                            },
                            next: { [unowned self](returnMsg) in
                                SVProgressHUD.dismiss()
                                if let msg = returnMsg {
                                    if msg.isSuccess {
                                        AppInfo.showToast("登录成功")
                                        self.dismissViewControllerAnimated(true, completion: nil)
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
            }.start()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.isInLoginInWeiXinFlow = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController {

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }

}

extension LoginViewController {

    @IBAction func back(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func login(sender: AnyObject) {
        self.view.endEditing(true)

        guard let phone = self.txtPhone.text, pwd = self.txtPwd.text else {
            return
        }
        SVProgressHUD.show()
        LoginManager.performLogin(phone, pwd: pwd)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on(failed: {(error) in
                AppInfo.showDefaultNetworkErrorToast()
                SVProgressHUD.dismiss()
                },
                next: { [unowned self](returnMsg) in
                    SVProgressHUD.dismiss()
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            AppInfo.showToast("登录成功")
                            self.dismissViewControllerAnimated(true, completion: nil)
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

    @IBAction func signup(sender: AnyObject) {
        self.view.endEditing(true)

        self.performSegueWithIdentifier(StoryboardSegue.Main.ShowSignupView.rawValue, sender: nil)
    }

    @IBAction func forgotPwd(sender: AnyObject) {
        self.view.endEditing(true)
        self.performSegueWithIdentifier(StoryboardSegue.Main.ShowForgotPwd.rawValue, sender: nil)
    }

    @IBAction func loginWithWeixin(sender: AnyObject) {
        self.view.endEditing(true)

        ThirdPartyManager.shareInstance().sendAuthRequest(self)
         self.isInLoginInWeiXinFlow = true
    }

    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

extension LoginViewController: UITextFieldDelegate {

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
