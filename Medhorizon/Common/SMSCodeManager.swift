//
//  SMSCodeManager.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

let intervalSecondSendSMSCodeAtLeast = 60

class SMSCodeManager {
    static let shareInstance = SMSCodeManager()
    var timer: NSTimer?
    let isCanSendSMSCode = MutableProperty<Bool>(true)
    let releaseSecond = MutableProperty<Int>(0)

    func getPermision() {
        if self.isCanSendSMSCode.value {
            self.releaseSecond.value = intervalSecondSendSMSCodeAtLeast
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(tick(_:)), userInfo: nil, repeats: true)
            self.isCanSendSMSCode.value = false
        }
    }

    @objc func tick(timer: NSTimer) {
        self.releaseSecond.value = self.releaseSecond.value - 1
        if self.releaseSecond.value <= 0 {
            self.isCanSendSMSCode.value = true
            self.timer?.invalidate()
            self.timer = nil
        }
    }

}

//0:注册 1:修改绑定手机 2:忘记密码
enum SMSCodeType: Int {
    case Signup = 0
    case ModifyPhone = 1
    case ForgotPwd = 2
}
