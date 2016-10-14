//
//  WorldDetailViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/14/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

final class WorldDetailData {
    var curPage = serverFirstPageNum
    
    var courseList: [CoursewareInfoViewModel] = []
    var isHaveMoreData = true
}

class WorldDetailViewModel {
    let expertId: String
    let departmentId: DepartmentType
    var coursewareType: CoursewareType
    
    init(expertId: String, departmentId: DepartmentType, courseType: CoursewareType) {
        self.expertId = expertId
        self.departmentId = departmentId
        self.coursewareType = courseType
    }
    
    var data: [Int: WorldDetailData] = [:]
    
    func getCurData() -> WorldDetailData {
        if let result = data[coursewareType.rawValue] {
            return result
        }
        
        let newData = WorldDetailData()
        data[coursewareType.rawValue] = newData
        return newData
    }
}

extension WorldDetailViewModel {
    func performSendRequest(pageNum: Int) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForExpertDetailInfo(departmentId.rawValue, expertId: self.expertId, tid: self.coursewareType.rawValue, pageNum: pageNum, pageSize: pageSize)
            .flatMap(.Latest, transform: { [unowned self] (departmentId, expertId, tid, page, serviceData) -> SignalProducer<ReturnMsg?, ServiceError> in
                if let department = DepartmentType(rawValue: departmentId) where department == self.departmentId,
                    let type = CoursewareType(rawValue: tid) where type == self.coursewareType {
                    let curData = self.getCurData()
                    let returnMsg = ReturnMsg.mapToModel(serviceData)
                    
                    if let msg = returnMsg where msg.isSuccess {
                        curData.curPage = page
                        
                        if let infoList = serviceData["InfoList"] as? [[String: AnyObject]] {
                            let infoViewModel = infoList.flatMap {CoursewareInfoViewModel.mapToModel($0)}
                            if serverFirstPageNum == page {
                                curData.courseList = infoViewModel
                            }
                            else {
                                curData.courseList.appendContentsOf(infoViewModel)
                            }
                            
                            if infoList.count == pageSize {
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
        if curData.courseList.count > 0 {
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
