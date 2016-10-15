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

    var userId: String?
    
    var isLogin: Bool {
        return userId != nil
    }

    var loginInfo: LoginBriefInfo?

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

            }
            else {
                baseCtrl.presentViewController(loginCtrl, animated: true, completion: nil)
            }
        }
        else {
            if LoginManager.shareInstance.isLogin {

            }
            else {
                LoginManager.shareInstance.mainCtrl?.presentViewController(loginCtrl, animated: true, completion: nil)
            }
        }
    }

    static func performLogin(phone: String, pwd: String) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForLogin(phone, pwd: pwd)
            .flatMap(.Latest, transform: { (object) -> SignalProducer<ReturnMsg?, ServiceError> in
                let returnMsg = ReturnMsg.mapToModel(object)
                if let msg = returnMsg where msg.isSuccess {
                    LoginManager.shareInstance.loginInfo = LoginBriefInfo.mapToModel(object, phone: phone)
                    LoginManager.shareInstance.userId = LoginManager.shareInstance.loginInfo?.userId
                    
                    LoginManager.shareInstance.saveLoginInfo()
                }

                return SignalProducer(value: returnMsg)
            })
    }
    
}
