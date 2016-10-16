//
//  GlobalData.swift
//  Medhorizon
//
//  Created by lich on 10/10/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

//分享QQ好友，分享QQ空间
//APP ID:1105664608
//APP KEY:Nv1twVt5kWjqsvNc
//
//第三方微信登录   分享微信好友  微信朋友圈
//AppID：wxd6cfa4b7e0104f54
//AppSecret：a6289763642953ca832be61e0abfcf0f
//
//
let privatePolicyUrl = "http://app.medhorizon.com.cn/Info/privacy.aspx" //隐私声明：
//积分明细：http://app.medhorizon.com.cn/Info/scoreRule.aspx
let feedbackUrl = "http://app.medhorizon.com.cn/Info/subject.aspx" //意见反馈：

let departmentKey = "GlobalData.DepartmentIdKey"

class GlobalData {
    static let shareInstance = GlobalData()
    
    let departmentId: MutableProperty<DepartmentType> = MutableProperty(.Child)
    
    init() {
        let department = NSUserDefaults.standardUserDefaults().integerForKey(departmentKey)
        if let type = DepartmentType(rawValue: department) {
            departmentId.value = type
        }
    }
    
    func saveDepartment(type: DepartmentType) {
        departmentId.value = type
        NSUserDefaults.standardUserDefaults().setInteger(type.rawValue, forKey: departmentKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}
