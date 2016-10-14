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
    var curPage = serverFirstPageNum
    
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
        return DefaultServiceRequests.rac_requesForWorldInfoList(departmentId.rawValue, tid: self.coursewareType.rawValue, pageNum: pageNum, pageSize: pageSize)
            .flatMap(.Latest, transform: { [unowned self] (departmentId, tid, page, serviceData) -> SignalProducer<ReturnMsg?, ServiceError> in
                if let department = DepartmentType(rawValue: departmentId) where department == self.departmentId,
                    let type = CoursewareType(rawValue: tid) where type == self.coursewareType {
                    let curData = self.getCurData()
                    let returnMsg = ReturnMsg.mapToModel(serviceData)
                    
                    if let msg = returnMsg where msg.isSuccess {
                        curData.curPage = page
                        
                        if let branner = serviceData["BrannerList"] as? [[String: AnyObject]] {
                            curData.brannerList = branner.flatMap {BrannerViewModel.mapToModel($0)}
                        }
                        
                        if let expertList = serviceData["ExpertsList"] as? [[String: AnyObject]] {
                            let expertListViewModel = expertList.flatMap {ExpertListViewModel.mapToModel($0)}
                            if serverFirstPageNum == page {
                                curData.expertList = expertListViewModel
                            }
                            else {
                                curData.expertList.appendContentsOf(expertListViewModel)
                            }
                            
                            if expertList.count == pageSize {
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
        return self.performSendRequest(serverFirstPageNum)
    }
    
    func performSwitchDepartmentFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        let curData = self.getCurData()
        if curData.expertList.count > 0 {
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
