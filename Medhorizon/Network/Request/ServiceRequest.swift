//
//  ServiceRequest.swift
//  Medhorizon
//
//  Created by Changchun li on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa
import Prelude

let defaultAppKey = "827ccb0eea8a706c4c34a16891f84e7b"

struct DefaultServiceRequests {
    
    static let alamofireManager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return  Manager(configuration: configuration)
    }()
    
    static func rac_requesForNewsList(departmentId: String, pageNum: Int, pageSize: Int) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.NewsList(defaultAppKey, departmentId, pageNum, pageSize))
            <~ justCast
    }
    
}
