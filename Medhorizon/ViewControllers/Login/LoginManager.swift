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
                if let phone = user.phone {
                    self.loginInfo?.phone = phone
                }
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

                    LoginManager.shareInstance.loginInfo = LoginBriefInfo.mapToModel(object, phone: phone)
                    LoginManager.shareInstance.userId = LoginManager.shareInstance.loginInfo?.userId

                    LoginManager.shareInstance.saveLoginInfo()
                    LoginManager.shareInstance.loginOrLogoutNotification.value = true
                }

                return SignalProducer(value: returnMsg)
            })
    }

    static func performLoginWithWX(userId: String?, token: String, openId: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForLoginWithWX(userId, token: token, openId: openId)
            .flatMap(.Latest, transform: { (object) -> SignalProducer<ReturnMsg?, ServiceError> in
                let returnMsg = ReturnMsg.mapToModel(object)
                if let msg = returnMsg where msg.isSuccess {

                    LoginManager.shareInstance.loginInfo = LoginBriefInfo.mapToModel(object, phone: "")
                    LoginManager.shareInstance.userId = LoginManager.shareInstance.loginInfo?.userId

                    LoginManager.shareInstance.saveLoginInfo()
                    LoginManager.shareInstance.loginOrLogoutNotification.value = true
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

extension LoginManager {

    static func performModifyNickName(userId: String, nickName: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForModifyUserNickName(userId, nickName: nickName)
            .map({ (object) -> ReturnMsg? in
                return ReturnMsg.mapToModel(object)
            })
    }

    static func performModifyPhone(userId: String, phone: String, vcode: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForModifyPhone(userId, phone: phone, vCode: vcode)
            .map({ (object) -> ReturnMsg? in
                return ReturnMsg.mapToModel(object)
            })
    }

    static func performModifyPwd(userId: String, oldPwd: String, newPwd: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForModifyPwd(userId, oldPwd: oldPwd, newPwd: newPwd)
            .map({ (object) -> ReturnMsg? in
                return ReturnMsg.mapToModel(object)
            })
    }

    static func performForTrueName(userId: String, type: TrueNameType, wwid: String?, doctor: (String, String, String)?) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForTrueName(userId, type: type.rawValue, wwid: wwid, doctor: doctor)
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

extension LoginManager {
    static func performUploadData() {
        var device: String = ""
        if let deviceKey = NSUserDefaults.standardUserDefaults().stringForKey("DeviceAppUUIDKey") {
            device = deviceKey
        }
        else {
            device = NSUUID().UUIDString
            NSUserDefaults.standardUserDefaults().setValue(device, forKey: "DeviceAppUUIDKey")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
//        ThirdPartyManager.getCurrentDeviceModel()
        DefaultServiceRequests.rac_requesForUpload("iPhone", address: "0,0", uid: LoginManager.shareInstance.userId ?? device, version: "1.0")
            .start()
    }

}
