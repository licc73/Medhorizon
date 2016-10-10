//
//  AppInfo.swift
//  Medhorizon
//
//  Created by lichangchun on 10/9/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

class AppInfo {
    static var screenWidth: CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    static func showToast(message: String?, duration: NSTimeInterval = 2) {
        UIApplication.sharedApplication().keyWindow?.makeToast(message, duration: duration, position: CSToastPositionCenter)
    }

    static func showDefaultNetworkErrorToast() {
        self.showToast("没有网络连接，请稍候重试")
    }
}
