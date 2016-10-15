//
//  LoginManager.swift
//  Medhorizon
//
//  Created by lich on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

class LoginManager {
    
    static let shareInstance = LoginManager()

    var mainCtrl: MainTabbarViewController?

    var userId: String?
    
    var isLogin: Bool {
        return userId != nil
    }
    
    static func loginOrEnterUserInfo(baseCtrl: UIViewController? = nil) {
        let loginCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        if let baseCtrl = baseCtrl {
            baseCtrl.presentViewController(loginCtrl, animated: true, completion: nil)
        }
        else {
            LoginManager.shareInstance.mainCtrl?.presentViewController(loginCtrl, animated: true, completion: nil)
        }
    }
    
}
