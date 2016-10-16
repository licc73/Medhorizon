//
//  SetupValueManager.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import Alamofire

class SetupValueManager {
    let network = NetworkReachabilityManager(host: DefaultServiceAPI.defaultServiceConfiguration.hostName())
    
    let isPlayInWifiOnlyKey = "Medhorizon.SetupValueManager.isPlayInWifiOnlyKey"
    let isPlayWhenOpenKey = "Medhorizon.SetupValueManager.isPlayWhenOpenKey"
    static let shareInstance = SetupValueManager()

    var isPlayInWifiOnly = false
    var isPlayWhenOpen = false

    init() {
        self.isPlayInWifiOnly = NSUserDefaults.standardUserDefaults().boolForKey(isPlayInWifiOnlyKey)
        self.isPlayWhenOpen = NSUserDefaults.standardUserDefaults().boolForKey(isPlayWhenOpenKey)
    }

    func saveInfo() {
        NSUserDefaults.standardUserDefaults().setBool(isPlayInWifiOnly, forKey: isPlayInWifiOnlyKey)
        NSUserDefaults.standardUserDefaults().setBool(isPlayWhenOpen, forKey: isPlayWhenOpenKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}
