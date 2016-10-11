//
//  LoginManager.swift
//  Medhorizon
//
//  Created by ZongBo Zhou on 10/11/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

class LoginManager {
    
    static let shareInstance = LoginManager()
    
    var userId: String?
    
    var isLogin: Bool {
        return userId != nil
    }
    
    static func loginOrEnterUserInfo() {
        
    }
    
}
