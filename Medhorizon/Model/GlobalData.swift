//
//  GlobalData.swift
//  Medhorizon
//
//  Created by lich on 10/10/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

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
