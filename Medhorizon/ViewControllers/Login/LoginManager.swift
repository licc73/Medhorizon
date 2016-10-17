//
//  LoginManager.swift
//  Medhorizon
//
//  Created by lich on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

let loginPhoneKey = "loginPhoneKey"
let loginUserIdKey = "loginUserIdKey"
let loginHeadPicKey = "loginHeadPicKey"
let loginNickNameKey = "loginNickNameKey"

let loginStatusChangeNotification = "loginStatusChangeNotification"

class LoginManager {
    static let shareInstance = LoginManager()

    var mainCtrl: MainTabbarViewController?

    var loginInfo: LoginBriefInfo?
    var userId: String?
    var isLogin: Bool {
        return userId != nil
    }

    let loginOrLogoutNotification: MutableProperty<Bool?> = MutableProperty(nil)

    var userDetailInfo: UserDetailInfo? {
        didSet {
            if let user = userDetailInfo {
                self.loginInfo?.picUrl = user.headpic
                self.loginInfo?.nickName = user.nickName
                self.saveLoginInfo()
            }
        }
    }

    init() {
        let phone = NSUserDefaults.standardUserDefaults().stringForKey(loginPhoneKey)
        let userId = NSUserDefaults.standardUserDefaults().stringForKey(loginUserIdKey)
        let pic = NSUserDefaults.standardUserDefaults().stringForKey(loginHeadPicKey)
        let nickName = NSUserDefaults.standardUserDefaults().stringForKey(loginNickNameKey)

        if let phone = phone, userId = userId {
            self.loginInfo = LoginBriefInfo(userId: userId, phone: phone, nickName: nickName, picUrl: pic)
            self.userId = userId
        }

        NSNotificationCenter.defaultCenter().postNotificationName(loginStatusChangeNotification, object: nil)
    }

    func saveLoginInfo() {

        if let login = loginInfo {
            NSUserDefaults.standardUserDefaults().setValue(login.phone, forKey: loginPhoneKey)
            NSUserDefaults.standardUserDefaults().setValue(login.userId, forKey: loginUserIdKey)
            NSUserDefaults.standardUserDefaults().setValue(login.picUrl, forKey: loginHeadPicKey)
            NSUserDefaults.standardUserDefaults().setValue(login.nickName, forKey: loginNickNameKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(loginStatusChangeNotification, object: nil)
        }

    }

    func clearLoginInfo() {
        LoginManager.shareInstance.loginOrLogoutNotification.value = false
        self.userId = nil
        self.loginInfo = nil
        self.userDetailInfo = nil

        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: loginPhoneKey)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: loginUserIdKey)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: loginHeadPicKey)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: loginNickNameKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(loginStatusChangeNotification, object: nil)
    }

    static func loginOrEnterUserInfo(baseCtrl: UIViewController? = nil) {
        let loginCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        if let baseCtrl = baseCtrl {
            if LoginManager.shareInstance.isLogin {
                LoginManager.shareInstance.mainCtrl?.performSegueWithIdentifier(StoryboardSegue.Main.ShowUserInfo.rawValue, sender: nil)
            }
            else {
                baseCtrl.presentViewController(loginCtrl, animated: true, completion: nil)
            }
        }
        else {
            if LoginManager.shareInstance.isLogin {
                LoginManager.shareInstance.mainCtrl?.performSegueWithIdentifier(StoryboardSegue.Main.ShowUserInfo.rawValue, sender: nil)
            }
            else {
                LoginManager.shareInstance.mainCtrl?.presentViewController(loginCtrl, animated: true, completion: nil)
            }
        }
    }
    
}

extension LoginManager { //login work flow

    static func performLogin(phone: String, pwd: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForLogin(phone, pwd: pwd)
            .flatMap(.Latest, transform: { (object) -> SignalProducer<ReturnMsg?, ServiceError> in
                let returnMsg = ReturnMsg.mapToModel(object)
                if let msg = returnMsg where msg.isSuccess {
                    LoginManager.shareInstance.loginOrLogoutNotification.value = true
                    LoginManager.shareInstance.loginInfo = LoginBriefInfo.mapToModel(object, phone: phone)
                    LoginManager.shareInstance.userId = LoginManager.shareInstance.loginInfo?.userId

                    LoginManager.shareInstance.saveLoginInfo()
                }

                return SignalProducer(value: returnMsg)
            })
    }

    static func performSendSMSCode(phone: String, type: SMSCodeType) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForSendSMSCode(phone, type: type.rawValue)
            .map({ (object) -> ReturnMsg? in
                return ReturnMsg.mapToModel(object)
            })
    }

    static func performRegister(phone: String, smsCode: String, pwd: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForRegister(phone, smsCode: smsCode, pwd: pwd)
            .map({ (object) -> ReturnMsg? in
                return ReturnMsg.mapToModel(object)
            })
    }

    static func performForgotPwd(phone: String, smsCode: String, pwd: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForForgotPwd(phone, smsCode: smsCode, pwd: pwd)
            .map({ (object) -> ReturnMsg? in
                return ReturnMsg.mapToModel(object)
            })
    }

}

extension LoginManager { // userInfo flow

    static func performGetUserDetail(userId: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForGetUserDetail(userId)
            .map({ (object) -> ReturnMsg? in
                let returnMsg = ReturnMsg.mapToModel(object)
                if let msg = returnMsg where msg.isSuccess {
                    LoginManager.shareInstance.userDetailInfo = UserDetailInfo.mapToModel(object)
                }
                return returnMsg
            })
    }
    
}
