//
//  NewsListViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/10/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

let initOffset = 1
let pageSize = 20

final class NewsData {
    var curPage = initOffset
    
    var brannerList: [BrannerViewModel] = []
    var newsList: [NewsViewModel] = []
    var isHaveMoreData = true
}

class NewsListViewModel {
    var data: [Int: NewsData] = [:]
    
    var departmentId: DepartmentType = GlobalData.shareInstance.departmentId.value
    
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
    func performSendRequest(pageNum: Int) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForNewsList(departmentId.rawValue, pageNum: pageNum, pageSize: pageSize)
            .flatMap(.Latest, transform: { [unowned self] (departmentId, page, serviceData) -> SignalProducer<ReturnMsg?, ServiceError> in
                if let department = DepartmentType(rawValue: departmentId) where department == self.departmentId {
                    let curData = self.getCurData()
                    let returnMsg = ReturnMsg.mapToModel(serviceData)

                    if let msg = returnMsg where msg.isSuccess {
                        curData.curPage = page

                        if let branner = serviceData["BrannerList"] as? [[String: AnyObject]] {
                            curData.brannerList = branner.flatMap {BrannerViewModel.mapToModel($0)}
                        }

                        if let newsList = serviceData["newsList"] as? [[String: AnyObject]] {
                            let newsListViewModel = newsList.flatMap {NewsViewModel.mapToModel($0)}
                            if initOffset == page {
                                curData.newsList = newsListViewModel
                            }
                            else {
                                curData.newsList.appendContentsOf(newsListViewModel)
                            }

                            if newsList.count == pageSize {
                                curData.isHaveMoreData = true
                            }
                            else {
                                curData.isHaveMoreData = false
                            }
                        }
                        return SignalProducer(value: msg)
                    }
                    return SignalProducer(value: nil)
                }
                else {
                    return SignalProducer(error: .UnknowError)
                }
            })
    }

    func performRefreshServerFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        return self.performSendRequest(initOffset)
    }

    func performSwitchDepartmentFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        let curData = self.getCurData()
        if curData.newsList.count > 0 {
            return SignalProducer(value: ReturnMsg.defaultSuccessReturnMsg)
        }
        else {
            return self.performRefreshServerFetch()
        }
    }

    func performLoadMoreServerFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        let curData = self.getCurData()
        return self.performSendRequest(curData.curPage + 1)
    }

}
