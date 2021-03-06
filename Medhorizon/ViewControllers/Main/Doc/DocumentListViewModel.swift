//
//  DocumentListViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/12/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

final class DocumentData {
    var curPage = serverFirstPageNum

    var docList: [CoursewareInfoViewModel] = []
    var isHaveMoreData = true
}

class DocumentListViewModel {
    var data: [Int: DocumentData] = [:]
    
    var departmentId: DepartmentType = GlobalData.shareInstance.departmentId.value

    var forMeeting = false
    var mid = ""
    var meetingData = DocumentData()
    
    func getCurData() -> DocumentData {

        if forMeeting {
            return self.meetingData
        }

        if let result = data[departmentId.rawValue] {
            return result
        }
        
        let newData = DocumentData()
        data[departmentId.rawValue] = newData
        return newData
    }
    
}

extension DocumentListViewModel {
    func performSendRequest(pageNum: Int) -> SignalProducer<ReturnMsg?, ServiceError> {
        if forMeeting {
            return DefaultServiceRequests.rac_requesForMeetingDetailInfo(mid, pageNum: pageNum, pageSize: pageSize)
                .flatMap(.Latest, transform: { [unowned self] (mid, page, serviceData) -> SignalProducer<ReturnMsg?, ServiceError> in
                    let curData = self.getCurData()
                    let returnMsg = ReturnMsg.mapToModel(serviceData)

                    if let msg = returnMsg where msg.isSuccess {
                        curData.curPage = page

                        if let infoList = serviceData["InfoList"] as? [[String: AnyObject]] {
                            let docListViewModel = infoList.flatMap { CoursewareInfoViewModel.mapToMeetingModel($0) }
                            if serverFirstPageNum == page {
                                curData.docList = docListViewModel
                            }
                            else {
                                curData.docList.appendContentsOf(docListViewModel)
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
                    })
        }
        else {
            return DefaultServiceRequests.rac_requesForDocumentList(departmentId.rawValue, pageNum: pageNum, pageSize: pageSize)
                .flatMap(.Latest, transform: { [unowned self] (departmentId, page, serviceData) -> SignalProducer<ReturnMsg?, ServiceError> in
                    if let department = DepartmentType(rawValue: departmentId) where department == self.departmentId {
                        let curData = self.getCurData()
                        let returnMsg = ReturnMsg.mapToModel(serviceData)

                        if let msg = returnMsg where msg.isSuccess {
                            curData.curPage = page

                            if let infoList = serviceData["InfoList"] as? [[String: AnyObject]] {
                                let docListViewModel = infoList.flatMap { CoursewareInfoViewModel.mapToDocumentModel($0) }
                                if serverFirstPageNum == page {
                                    curData.docList = docListViewModel
                                }
                                else {
                                    curData.docList.appendContentsOf(docListViewModel)
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

    }
    
    func performRefreshServerFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        return self.performSendRequest(serverFirstPageNum)
    }
    
    func performSwitchDepartmentFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        let curData = self.getCurData()
        if curData.docList.count > 0 {
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
