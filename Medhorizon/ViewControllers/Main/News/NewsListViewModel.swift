//
//  NewsListViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/10/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

let pageSize = 20
final class NewsData {
    let initOffset = 1
    
    let BrannerList: [Branner] = []
    var isHaveMoreData = true
}

class NewsListViewModel {
    var data: [Int: NewsData] = [:]
    
    let departmentId: DepartmentType = GlobalData.shareInstance.departmentId.value
    
    func getCurData() -> NewsData {
        if let result = data[departmentId.rawValue] {
            return result
        }
        
        let newData = NewsData()
        data[departmentId.rawValue] = newData
        return newData
    }
    
}

extension NewsListViewModel {
    func performSendRequest(pageNum: Int) -> SignalProducer<(), ServiceError> {
        
        return DefaultServiceRequests.rac_requesForNewsList(departmentId.rawValue, pageNum: pageNum, pageSize: pageSize)
            .flatMap(.Latest, transform: { [unowned self] (departmentId, page, serviceData) -> SignalProducer<(), ServiceError> in
                if let department = DepartmentType(rawValue: departmentId) where department == self.departmentId {
                    let curData = self.getCurData()
                    
                }
                else {
                    return SignalProducer(error: .UnknowError)
                }
            })
    }
}
