//
//  WorldListViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/13/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

final class WorldData {
    var curPage = initOffset
    
    var brannerList: [BrannerViewModel] = []
    var expertList: [ExpertListViewModel] = []
    var isHaveMoreData = true
}

class WorldListViewModel {
    var data: [Int: [Int: WorldData]] = [:]
    
    var departmentId: DepartmentType = GlobalData.shareInstance.departmentId.value
    var coursewareType: CoursewareType = .Video
    
    func getCurData() -> WorldData {
        return getDataWith(departmentId.rawValue, course: coursewareType.rawValue)
    }
    
    func getDataWith(department: Int, course: Int) -> WorldData {
        if var departmentData = data[department] {
            if let result = departmentData[course] {
                return result
            }
            else {
                let newData = WorldData()
                departmentData[course] = newData
                data[department] = departmentData
                return newData
            }
        }
        else {
            let newData = WorldData()
            let departmentData: [Int: WorldData] = [course : newData]
            data[department] = departmentData
            return newData            
        }
    }
    
}

extension WorldListViewModel {
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